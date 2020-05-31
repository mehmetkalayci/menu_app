
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menuapp/models/dummy.dart';
import 'package:menuapp/models/table_group.dart';
import 'package:menuapp/screens/select_menu_category.dart';
import 'package:menuapp/widgets/table_item.dart';
import 'package:page_transition/page_transition.dart';

class SelectTablePage extends StatefulWidget {
  @override
  _SelectTablePageState createState() => _SelectTablePageState();
}

class _SelectTablePageState extends State<SelectTablePage> {
  List<TableGroup> tableData = DUMMY_GROUPS_WITH_TABLES.toList();

  List<Tables> tables = [];

  void getTables(String categoryName) {
    print(categoryName);
    setState(() {
      tables = this
          .tableData
          .singleWhere((element) => element.name == categoryName)
          .tables
          .toList();
    });
    print(tables);
  }

  Offset referenceOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    List<String> tableGroupNames =
        Set.of(tableData.map((e) => e.name).toList()).toList();
    //print(tableGroupNames);

    return Scaffold(
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
                                        getTables(tableGroupNames[index]);
                                      },
                                      child: Center(
                                        child: Text(
                                          tableGroupNames[index],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )),
                                ),
                              ),
                          itemCount: tableGroupNames.length),
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
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child:
                          SelectMenuCategoryPage(),
                        ),
                      );

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
