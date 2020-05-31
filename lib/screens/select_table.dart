import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menuapp/models/dummy.dart';
import 'package:menuapp/models/table_group.dart';
import 'package:menuapp/screens/select_menu_category.dart';
import 'package:menuapp/screens/table_details.dart';
import 'package:menuapp/widgets/table_item.dart';
import 'package:page_transition/page_transition.dart';

class SelectTablePage extends StatefulWidget {
  @override
  _SelectTablePageState createState() => _SelectTablePageState();
}

class _SelectTablePageState extends State<SelectTablePage> {


  ///////////////////////
  var data = DUMMY_GROUPS_WITH_TABLES.toList();

  List<Tables> tables = [];
  List<String> tableGroups = [];

  void getTables(String categoryName) {
    setState(() {
      // önce masaları temizle
      tables = [];
      if (categoryName == 'Hepsi') {
        // tüm masaları tables a ekle
        data.forEach((element) => tables.addAll(element.tables));
      } else {
        // seçili kategorilerdeki masaları tables a ekle
        tables = data
            .singleWhere((element) => element.name == categoryName)
            .tables
            .toList();
      }
    });
  }

  @override
  void initState() {
    setState(() {


      // table groups doldur
      data.forEach((element) => tableGroups.add(element.name));
      tableGroups.add('Hepsi');
    });
  }

  Offset referenceOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('ANT POS'),
          ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [

            Container(
              height: 90,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 75,
                      child: ListView.builder(
                          itemExtent: 150,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.all(5.0),
                                child: Material(
                                  color: Colors.blue,
                                  child: InkWell(
                                      splashColor: Colors.redAccent,
                                      onTap: () {
                                        getTables(tableGroups[index]);
                                      },
                                      child: Center(
                                        child: Text(
                                          tableGroups[index],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )),
                                ),
                              ),
                          itemCount: tableGroups.length),
                    ),
                  ),
                ],
              ),
            ),



            Expanded(
              child: GridView.builder(
                itemCount: tables.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.25),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(tables[index].tableName);
                      // todo: masa seçildikten sonra kategori seçimine yönlendir
                      // todo: sipariş varsa, masa detay sayfası aç
                      if (tables[index].orders.length > 0) {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: TableDetailsPage(tables[index]),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: SelectMenuCategoryPage(),
                          ),
                        );
                      }
                    },
                    child: TableItem(
                        tables[index].tableName,
                        tables[index].orders.length > 0
                            ? Colors.lime
                            : Colors.grey[100]),
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
