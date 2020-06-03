import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:menuapp/models/basket_item.dart';
import 'package:menuapp/models/basket_state.dart';
import 'package:menuapp/models/table_group.dart';
import 'package:menuapp/screens/select_menu_category.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TableDetailsPage extends StatefulWidget {
  Tables _table;
  TableDetailsPage(this._table);
  @override
  _TableDetailsPageState createState() => _TableDetailsPageState();
}

class _TableDetailsPageState extends State<TableDetailsPage> {
  Future<http.Response> postRequest(data) async {
    var body = json.encode(data);

    var response = await http.post('https://telgrafla.com/api/send.php',
        headers: {"Content-Type": "application/json"}, body: body);

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

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
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: SelectMenuCategoryPage(),
              ),
            );
            // todo navigasyondan sonra sayfa yenilenecek
          },
        ),
      ]),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            if (this.widget._table.orders.length > 0)
              Expanded(

                child: Column(
                  children: <Widget>[
                    Text(
                      'Siparişler',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(height: 1),
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
                            subtitle: Text(
                                this.widget._table.orders[index].serveName +
                                    ' ' +
                                    this
                                        .widget
                                        ._table
                                        .orders[index]
                                        .extraNames
                                        .join(', ')),
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SvgPicture.string(
                                this.widget._table.orders[index].productIcon ?? '',
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
              ),
            if (basketItems.length > 0)
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Onay Bekleyen Siparişler',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.separated(
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
                                subtitle: Text(basketItems[index].serveName +
                                    ' ' +
                                    basketItems[index].extraNames.join(', ')),
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
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () async {
                          // todo: http istegi gönderilecek
                          // todo: basketstate temizlenecek
                          // todo: masalar tekrar çekilecek

                          var temp = basketItems.map((e) => e.toJson()).toList();

                          this.postRequest(temp).then((value) {
                            if (value.statusCode == 200) {
                              // istek başarıyla gittiyse; basketState'ten sepeti temizle
                              // basketItems ı da temizle

                              basketItems.forEach((element) =>
                                  basketState.removeFromCart(element));
                              // sepet gönderildi, sepetteki elemanlar temizlendi
                              // şimdi masaları yeniden çekme isteği gönder

                              //basketState.fetchTableGroups();

                              // todo burada tekrar çek datayı yenile
                              // todo: buraya bir bak çalışıyor mu

                              Fluttertoast.showToast(
                                  msg: "Siparişler Alındı",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Hata Oluştu!\n" +
                                      value.statusCode.toString(),
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 1);
                            }
                          }).catchError((e) => Fluttertoast.showToast(
                              msg: e.toString(),
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 1));
                        },
                        child: Text(
                          'Siparişleri Onayla',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ]),
        ),
      ),
    );
  }
}
