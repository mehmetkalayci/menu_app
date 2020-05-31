import 'package:flutter/material.dart';
import 'package:menuapp/models/dummy.dart';
import 'package:menuapp/models/product.dart';
import 'package:menuapp/widgets/product_item.dart';

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

class MyBottomSheet extends StatelessWidget {
  Product _product;
  MyBottomSheet(this._product);

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
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                print(this._product.serveTypes[index].name);
                              },
                              child: Text(
                                this._product.serveTypes[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, height: 1.2),
                              ),
                            ),
                          ),
                      itemCount: this._product.serveTypes.length),
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
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () {
                                print(this._product.extras[index].name);
                              },
                              child: Text(
                                this._product.extras[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, height: 1.2),
                              ),
                            ),
                          ),
                      itemCount: this._product.extras.length),
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
                  print('eksi');
                }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  print('artı');
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
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            if (this._product.serveTypes.length > 0) _getServeTypes(),
            if (this._product.extras.length > 0) _getExtras(),
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
                      print('asdf');
                    },
                    child: Text(
                      'MASA 1 \'E EKLE',
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

