import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menuapp/models/basket_state.dart';
import 'package:menuapp/models/category.dart';
import 'package:menuapp/screens/list_products.dart';
import 'package:page_transition/page_transition.dart';

import 'package:http/http.dart' as http;

class SelectMenuCategoryPage extends StatefulWidget {
  @override
  _SelectMenuCategoryPageState createState() => _SelectMenuCategoryPageState();
}

class _SelectMenuCategoryPageState extends State<SelectMenuCategoryPage> {
  var allCategories = [];
  List<Category> selectedCategories = [];

  ListQueue<Map<int, String>> selectedMenus = ListQueue<Map<int, String>>();
  String _breadcrumbs = '';

  void getCategories(int catId, String catName) {
    setState(() {
      selectedCategories =
          allCategories.where((element) => element.parentId == catId).toList();
    });

    if (selectedCategories.length <= 0) {
      // artık seçilecek kategori kalmadı, kategorideki ürünleri göster
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ListProductsPage(catId, catName),
        ),
      );

      // yönlendirme yaptıktan sonra; geri gelinceki durumu hazırla
      setState(() {
        selectedMenus.clear();
        selectedMenus.addLast({0: ''});
        getCategories(0, '');
      });
    } else {
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

  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://telgrafla.com/categories",
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      this.allCategories = responseData
          .map((item) => Category.fromJson(item))
          .cast<Category>()
          .toList();

      setState(() {
        isLoading = false;

        // ana kategorileri getir
        getCategories(0, '');

        // seçili menülere 0 ı ekle
        selectedMenus.addLast({0: ''});

        // breadcrumbs ekrana yazılması için güncelle
        _updateBreadcrumbs();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  void initState() {
    _fetchData();
  }

  //////////////////////

  Future<bool> _onBackPressed() async {
    if (selectedMenus.length > 1) {
      selectedMenus.removeLast();
      // geri gittikçe menüyü eski haline getir
      getCategories(
          selectedMenus.last.keys.last, selectedMenus.last.values.last);
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
            child: this.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        if (_breadcrumbs != '')
                           Text(
                              _breadcrumbs,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: selectedCategories.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  selectedMenus.addLast({
                                    selectedCategories[index].id:
                                        selectedCategories[index].categoryName
                                  });

                                  getCategories(selectedCategories[index].id,
                                      selectedCategories[index].categoryName);
                                },
                                title: Text(
                                    selectedCategories[index].categoryName),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: SvgPicture.string(
                                      selectedCategories[index].icon ?? ''),
                                ),
                              );

/*                              return Card(
                                elevation: 10,
                                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                child: ListTile(
                                  onTap: () {
                                    selectedMenus.addLast({
                                      selectedCategories[index].id:
                                          selectedCategories[index].categoryName
                                    });

                                    getCategories(selectedCategories[index].id, selectedCategories[index].categoryName);
                                  },
                                  title: Text(
                                      selectedCategories[index].categoryName),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: SvgPicture.string(
                                        selectedCategories[index].icon ?? ''),
                                  ),
                                ),
                              );
                              */
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
