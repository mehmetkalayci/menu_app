import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menuapp/models/category.dart';
import 'package:menuapp/models/dummy.dart';
import 'package:menuapp/screens/list_products.dart';
import 'package:page_transition/page_transition.dart';

class SelectMenuCategoryPage extends StatefulWidget {
  @override
  _SelectMenuCategoryPageState createState() => _SelectMenuCategoryPageState();
}

class _SelectMenuCategoryPageState extends State<SelectMenuCategoryPage> {




  List<Category> allCategories = DUMMY_CATEGORIES.toList();
  List<Category> selectedCategories = [];

  ListQueue<int> selectedMenuIds = ListQueue();

  void getCategories(int catId) {
    setState(() {
      selectedCategories =
          allCategories.where((element) => element.parentId == catId).toList();
    });

    if (selectedCategories.length <= 0) {
      // todo: kategorideki ürünleri getir
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          // burada selectedCategories[0] dogrudan alınabilir, zaten başka alt kategori yok 1 tane nesne var
          child: ListProductsPage(catId),
        ),
      );
    } else {
      // todo: alt kategorileri getir

    }
  }

  //////////////////////

  @override
  void initState() {
    getCategories(0);
    selectedMenuIds.addLast(0);
  }

  //////////////////////

  Future<bool> _onBackPressed() async {
    print(selectedMenuIds);
    if (selectedMenuIds.length > 1) {
      selectedMenuIds.removeLast();
      // geri gittikçe menüyü eski haline getir
      getCategories(selectedMenuIds.last);
    } else {
      // todo: burada en üst kademedeki menüye, yani ana menüye ulaştı ve geri gitmek istiyorsa sayfayı kapat
       false;
    }
  }

  //////////////////////

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selectedCategories.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          selectedMenuIds.addLast(selectedCategories[index].id);
                          getCategories(selectedCategories[index].id);
                        },
                        title: Text(selectedCategories[index].categoryName),
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.string(
                              selectedCategories[index].icon ?? ''),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
