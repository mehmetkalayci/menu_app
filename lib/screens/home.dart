import 'package:flutter/material.dart';
import 'package:menuapp/screens/select_menu_category.dart';
import 'package:menuapp/screens/select_table.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  final List<Widget> _children = [SelectTablePage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ANT POS'),
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.featured_play_list),
            title: new Text('SİPARİŞ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_basket),
            title: new Text('SEPET', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
        ],
      ),
    );
  }
}
