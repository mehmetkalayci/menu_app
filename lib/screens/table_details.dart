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

    Widget _getWaitingOrders() {
      if (basketItems.length > 0) {
        return Column(
          children: <Widget>[
            Text(
              'Onay Bekleyen Siparişler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: ListView.separated(
                  itemCount: basketItems.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
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
                      trailing: Text('x' + basketItems[index].qty.toString()),
                    );
                  }),
            ),
          ],
        );
      } else {
        return Container();
      }
    }

    Widget _getOrders() {
      return Column(
        children: <Widget>[
          Text(
            'Siparişler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
                itemCount: this.widget._table.orders.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      print(this.widget._table.orders[index].productName);
                    },
                    title: Text(this.widget._table.orders[index].productName),
                    subtitle: Text(this.widget._table.orders[index].serveName),
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.string(
                        this.widget._table.orders[index].productIcon ?? '',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    trailing: Text(
                        'x' + this.widget._table.orders[index].qty.toString()),
                  );
                }),
          ),
        ],
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
          child: Column(children: <Widget>[_getOrders(), _getWaitingOrders()]),
        ),
      ),
    );
  }
}
