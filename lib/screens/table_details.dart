import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:menuapp/models/basket_item.dart';
import 'package:menuapp/models/basket_state.dart';
import 'package:menuapp/models/table_group.dart';
import 'package:menuapp/screens/select_menu_category.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TableDetailsPage extends StatefulWidget {
  Tables _table;
  TableDetailsPage(this._table);
  @override
  _TableDetailsPageState createState() => _TableDetailsPageState();
}

class _TableDetailsPageState extends State<TableDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final basketState = Provider.of<BasketState>(context);

    List<BasketItem> basketItems = basketState.getBasketItems
        .where((element) => element.tableId == this.widget._table.id)
        .toList();

    Widget slideRightBackground() {
      return Container(
        color: Colors.red,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                " Sil",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    return Scaffold(
      appBar:
          AppBar(title: Text(this.widget._table.tableName), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // todo: buradan menu kategorilere git ve ürün eklet

            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: SelectMenuCategoryPage(),
              ),
            );
          },
        ),
      ]),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            if (this.widget._table.orders.length > 0)
              Column(
                children: <Widget>[
                  Text(
                    'Siparişler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: this.widget._table.orders.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            print(this.widget._table.orders[index].productName);
                          },
                          title: Text(
                              this.widget._table.orders[index].productName),
                          subtitle:
                              Text(this.widget._table.orders[index].serveName),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.string(
                              this.widget._table.orders[index].productIcon ??
                                  '',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          trailing: Text('x' +
                              this.widget._table.orders[index].qty.toString()),
                        );
                      }),
                ],
              ),
            if (basketItems.length > 0)
              Column(
                children: <Widget>[
                  Text(
                    'Onay Bekleyen Siparişler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: basketItems.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: Key(basketItems[index].productId.toString()),
                          background: slideRightBackground(),
                          dismissThresholds: {DismissDirection.endToStart: 0.6},
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          "${basketItems[index].productName} silinsin mi?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "İptal",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Sil",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            // basketState den silindi, changenotif ile hemen yansıdı
                                            basketState.removeFromCart(
                                                basketItems[index]);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return res;
                            }
                          },
                          child: ListTile(
                            onTap: () {
                              print(basketItems[index].productName);
                            },
                            title: Text(basketItems[index].productName),
                            subtitle: Text(basketItems[index].serveName),
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SvgPicture.string(
                                basketItems[index].productIcon ?? '',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            trailing:
                                Text('x' + basketItems[index].qty.toString()),
                          ),
                        );
                      }),
                  SizedBox(height: 25),
                  SizedBox(
                    width: MediaQuery.of(context).size.width-40,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Siparişleri Onayla',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )
          ]),
        ),
      ),
    );
  }
}
