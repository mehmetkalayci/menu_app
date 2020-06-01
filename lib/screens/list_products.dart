import 'package:flutter/material.dart';
import 'package:menuapp/models/basket_item.dart';
import 'package:menuapp/models/basket_state.dart';
import 'package:menuapp/models/dummy.dart';
import 'package:menuapp/models/product.dart';
import 'package:menuapp/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ListProductsPage extends StatefulWidget {
  int _categoryId;
  ListProductsPage(this._categoryId);

  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  List<Product> products = [];
  String categoryName = '';

  @override
  void initState() {
    super.initState();

    categoryName = DUMMY_CATEGORIES
        .singleWhere((element) => element.id == this.widget._categoryId)
        .categoryName;

    products = DUMMY_PRODUCTS
        .where((element) => element.categoryId == this.widget._categoryId)
        .toList();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var basketState = Provider.of<BasketState>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(categoryName),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        // burada ürün seçildi. basketState içindeki lastSelectedProduct'a seçilen bu ürünün Idsini atadık
                        basketState
                            .setLastSelectedProductId(products[index].id);

                        print(products[index].productName);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                            ),
                            context: context,
                            builder: (builder) {
                              return MyBottomSheet(products[index]);
                            });
                      },
                      child: ProductItem(
                          products[index].productName, products[index].icon));
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  Product _product;
  MyBottomSheet(this._product);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  int qty = 1;
  ServeTypes selectedServeType;
  List<Extras> selectedExtras = [];

  final orderNoteController = TextEditingController();

  @override
  void dispose() {
    orderNoteController.dispose();
    super.dispose();
  }

  Widget _getServeTypes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'SERVİS TÜRÜ',
          style:
              TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 70,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 70,
                  child: ListView.builder(
                      itemExtent: 120,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: RaisedButton(
                              color: selectedServeType ==
                                      this.widget._product.serveTypes[index]
                                  ? Colors.lightGreenAccent
                                  : Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                // burada servis türü seçimi yaptık
                                setState(() {
                                  selectedServeType =
                                      this.widget._product.serveTypes[index];
                                });

                                print('serveTypeDefinitionId');
                                print(this.widget._product.serveTypes[index].serveTypeDefinitionId.toString());
                              },
                              child: Text(
                                this.widget._product.serveTypes[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, height: 1.2),
                              ),
                            ),
                          ),
                      itemCount: this.widget._product.serveTypes.length),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getExtras() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          'EKSTRALAR',
          style:
              TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 70,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 70,
                  child: ListView.builder(
                      itemExtent: 120,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: RaisedButton(
                              color: selectedExtras.contains(
                                      this.widget._product.extras[index])
                                  ? Colors.lightGreenAccent
                                  : Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                // seçilen ekstraları selectedExtras'a ekledik, varsa sildik
                                setState(() {
                                  if (this.selectedExtras.contains(
                                      this.widget._product.extras[index])) {
                                    this.selectedExtras.remove(
                                        this.widget._product.extras[index]);
                                  } else {
                                    this.selectedExtras.add(
                                        this.widget._product.extras[index]);
                                  }
                                });
                              },
                              child: Text(
                                this.widget._product.extras[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, height: 1.2),
                              ),
                            ),
                          ),
                      itemCount: this.widget._product.extras.length),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getAmount() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          'MİKTAR',
          style:
              TextStyle(fontSize: 18, height: 1, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    this.qty > 1 ? this.qty-- : 1;
                  });
                }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.qty.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    this.qty++;
                  });
                })
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getTakeNote() {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          'SİPARİŞ NOTU',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          textAlign: TextAlign.center,
          maxLines: 1,
          minLines: 1,
          decoration: InputDecoration(hintText: 'Sipariş notunuzu girin...'),
          controller: orderNoteController,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var basketState = Provider.of<BasketState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.black12,
                height: 2.5,
                width: 50,
              ),
            ),
            _getTakeNote(),
            if (this.widget._product.serveTypes.length > 0) _getServeTypes(),
            if (this.widget._product.extras.length > 0) _getExtras(),
            _getAmount(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.amber,
                    onPressed: () {
                      // todo: burada belirnen masaId'siyle basket statetine siparişi ekle
                      print('hangi masaya eklenecek->' +
                          basketState.getLastTableId.toString());
                      print('hangi masaya eklenecek->' +
                          basketState.getLastTableName.toString());
                      print('masaya hangi ürün eklenecek->' +
                          basketState.getLastSelectedProduct.toString());


                      // sepete eklenecek BasketItem nesnesini oluştur
                      basketState.addToCart(new BasketItem(
                        id: basketState.getBasketItems.length + 1,
                        // seçilen ürün
                        productId: this.widget._product.id,
                        productName: this.widget._product.productName,
                        productIcon: this.widget._product.icon,
                        printerId: this.widget._product.printerId,
                        qty: this.qty,

                        // seçilen ekstralar
                        extraIds: this.selectedExtras.map((e) => e.id).toList(),
                        extraNames:
                            this.selectedExtras.map((e) => e.name).toList(),
                        extraPrice: this
                            .selectedExtras
                            .fold(0, (prev, element) => prev + element.price),

                        // seçilen sunum
                        serveId: this.selectedServeType.serveTypeDefinitionId,
                        serveName: this.selectedServeType.name,
                        price: this.selectedServeType.price,
                        stockReductionAmount:
                            this.selectedServeType.stockReductionAmount,
                        // todo: buradaki stockId, serveTypeDefinitionId mi???
                        stockId: this.selectedServeType.serveTypeDefinitionId,
                        // tableId 'yi basketStateten al
                        tableId: basketState.getLastTableId,

                        orderMemo: this.orderNoteController.text,

                        username:
                            'shared prefden alınacak ya da provider a ekle',
                      ));
                    },
                    child: Text(
                      '${basketState.getLastTableName.toUpperCase()}  \'E EKLE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
