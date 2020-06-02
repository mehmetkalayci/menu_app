import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menuapp/models/basket_state.dart';
import 'package:menuapp/models/table_group.dart';
import 'package:menuapp/screens/select_menu_category.dart';
import 'package:menuapp/screens/table_details.dart';
import 'package:menuapp/widgets/table_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class SelectTablePage extends StatefulWidget {
  @override
  _SelectTablePageState createState() => _SelectTablePageState();
}

class _SelectTablePageState extends State<SelectTablePage> {
  List<Tables> tables = [];
  List<TableGroup> tableGroups = [];

  bool isLoading = false;

  void getTables(String categoryName) {
    setState(() {
      // önce masaları temizle
      tables = [];
      if (categoryName == 'Hepsi') {
        // tüm masaları tables a ekle
        tableGroups.forEach((element) => tables.addAll(element.tables));
      } else {
        // seçili kategorilerdeki masaları tables a ekle
        tables = tableGroups
            .singleWhere((element) => element.name == categoryName)
            .tables
            .toList();
      }
    });
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://telgrafla.com/tables",
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      this.tableGroups = responseData
          .map((item) => TableGroup.fromJson(item))
          .cast<TableGroup>()
          .toList();

      setState(() {
        // table groups doldur
        //tableGroups.forEach((element) => tableGroups.add(element.name));

        isLoading = false;
      });
    } else {
      throw Exception('Failed to load tables&groups');
    }

    getTabs();
  }

  List<Tab> _tabs = List<Tab>();

  void getTabs() {
    _tabs.clear();
    this.tableGroups.forEach((element) => _tabs.add(Tab(text: element.name.toUpperCase())));
    //_tabs.add(Tab(text: 'HEPSİ'));
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var basketState = Provider.of<BasketState>(context);

    return DefaultTabController(
      length: this._tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ANT POS'),
            bottom:this.isLoading ? null : TabBar(tabs: this._tabs) ,
        ),
        body: TabBarView(
          children: [
            for (var item in this.tableGroups)
              GridView.builder(
                itemCount: item.tables.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.25),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(item.tables[index].id);
                      print(item.tables[index].tableName);
                      // burada masaya ait detaya gidip bir ürün eklenebilir
                      // ya da masa boşsa doğrudan kategoriye gidip ürün eklenebilir
                      // bu adımda tıklanan masaId sini basket_state içindeki lastTableId'ye atayacağız
                      basketState.setLastTable(item.tables[index]);

                      // lastTableId içindeki değeri basketItems'a değer ürün eklerken kullanacağız

                      if (item.tables[index].orders.length > 0 ||
                          basketState.getBasketItems
                                  .where((element) =>
                                      element.tableId == item.tables[index].id)
                                  .toList()
                                  .length >
                              0) {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: TableDetailsPage(item.tables[index]),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            // kategori seçerken masaId sini de gönderdik
                            child: SelectMenuCategoryPage(),
                          ),
                        );
                      }
                    },
                    // burada masalar gösteriliyor
                    // masada onaylanmamış sıpariş varsa kırmızı göster
                    // masa boşşa gri, doluysa ve tüm sıparişleri onaylanmış ise yeşil göster
                    child: TableItem(
                        item.tables[index].tableName,
                        basketState.getBasketItems
                                    .where((element) =>
                                        element.tableId ==
                                        item.tables[index].id)
                                    .toList()
                                    .length >
                                0
                            ? Colors.redAccent
                            : item.tables[index].orders.length > 0
                                ? Colors.lime
                                : Colors.grey[100]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
