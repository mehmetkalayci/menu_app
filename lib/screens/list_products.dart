import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:menuapp/models/dummy.dart';
import 'package:menuapp/models/product.dart';

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

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Text('Hello From Modal Bottom Sheet'),
            padding: EdgeInsets.all(40.0),
          );
        });
  }



  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Text(
              this.categoryName,
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.25),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(products[index].productName);
                      // todo: ürün detay alttan açılacak
                    },
                    child: Center(
                      child: ListTile(
                        onTap: () {
                          // todo: popup aç
                          print(products[index].productName);

                          _showModalSheet();
//                          scaffoldKey.currentState
//                              .showBottomSheet((context) => Container(
//                                    color: Colors.red,
//                                  ));
                        },
                        title: Text(products[index].productName),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.string(products[index].icon ?? ''),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
