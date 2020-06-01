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
  var allCategories = DUMMY_CATEGORIES.toList();
  List<Category> selectedCategories = [];

  ListQueue<Map<int, String>> selectedMenus = ListQueue<Map<int, String>>();
  String _breadcrumbs = '';

  void getCategories(int catId) {
    setState(() {
      selectedCategories = allCategories.where((element) => element.parentId == catId).toList();
    });

    if (selectedCategories.length <= 0) {
      // artık seçilecek kategori kalmadı, kategorideki ürünleri göster
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ListProductsPage(catId),
        ),
      );

      // yönlendirme yaptıktan sonra; geri gelinceki durumu hazırla
      setState(() {
        selectedMenus.clear();
        selectedMenus.addLast({0: ''});
        getCategories(0);
      });


    } else{
      // her kategori değişiminde
      // breadcrumbs ekrana yazılması için güncelle
      _updateBreadcrumbs();
    }

  }

  void _updateBreadcrumbs() {
    if (selectedMenus.length > 0) {
      _breadcrumbs = '';
      selectedMenus.forEach((element) {
        _breadcrumbs += element.values.last.toString() + ' / ';
      });
      _breadcrumbs = _breadcrumbs.substring(0, _breadcrumbs.length - 3);
    }
  }


  @override
  void initState() {

    // ana kategorileri getir
    getCategories(0);

    // seçili menülere 0 ı ekle
    selectedMenus.addLast({0: ''});

    // breadcrumbs ekrana yazılması için güncelle
    _updateBreadcrumbs();
  }

  //////////////////////

  Future<bool> _onBackPressed() async {
    if (selectedMenus.length > 1) {
      selectedMenus.removeLast();
      // geri gittikçe menüyü eski haline getir
      getCategories(selectedMenus.last.keys.last);
      return false;
    } else {
      return true;
    }
  }

  //////////////////////

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kategori Seçin'),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Text(
                  _breadcrumbs,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedCategories.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          selectedMenus.addLast({
                            selectedCategories[index].id:
                                selectedCategories[index].categoryName
                          });

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
