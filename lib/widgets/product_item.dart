import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductItem extends StatelessWidget {
  final String _title;
  final String _icon;
  ProductItem(this._title, this._icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                offset: Offset(0, 0),
                blurRadius: 3)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.string(
            this._icon,
            width: 50,
            height: 50,
          ),
          SizedBox(height: 5),
          Text(
            this._title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, height: 1.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
