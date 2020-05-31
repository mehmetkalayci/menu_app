import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:menuapp/models/table_group.dart';

class TableDetailsPage extends StatefulWidget {
  Tables _table;
  TableDetailsPage(this._table);
  @override
  _TableDetailsPAgeState createState() => _TableDetailsPAgeState();
}

class _TableDetailsPAgeState extends State<TableDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(this.widget._table.tableName), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // todo: buradan menu kategorilere git ve ürün eklet
          },
        ),
      ]),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Expanded(
              child: ListView.separated(
                  itemCount: this.widget._table.orders.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: Colors.black54),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        print(this.widget._table.orders[index].productName);
                      },
                      title: Text(this.widget._table.orders[index].productName),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.string(
                          this.widget._table.orders[index].productIcon ?? '',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    );
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
