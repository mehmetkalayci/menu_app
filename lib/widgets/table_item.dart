import 'package:flutter/material.dart';

class TableItem extends StatelessWidget {

  final String _title;
  final Color _color;
  TableItem(this._title, this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(10),
      height: 75,
      width: 100,
      decoration: BoxDecoration(
          color: this._color,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                offset: Offset(0, 0),
                blurRadius: 3)
          ]),
      child: Center(
          child: Text(this._title,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}
