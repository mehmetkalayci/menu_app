
import 'package:flutter/material.dart';
import 'package:menuapp/models/basket_item.dart';
import 'package:menuapp/models/table_group.dart';

class BasketState  with ChangeNotifier {

  // hangi masaya ürün ekleneceği bulmak için
  Tables _lastSelectedTable;
  Tables get getLastSelectedTable => _lastSelectedTable;

  // mevcut sepeti tut
  List<BasketItem> _basketItems = [];
  List<BasketItem> get getBasketItems => _basketItems;

  // tüm masaların durumlarını tut
  List<TableGroup> _tableGroups = [];
  List<TableGroup> get getTableGroups => _tableGroups;

  void refreshTableGroups(List<TableGroup> items) {
    _tableGroups.clear();
    _tableGroups.addAll(items);
    notifyListeners();
  }

  void setLastTable(Tables table) {
    this._lastSelectedTable = table;
    notifyListeners();
  }

  void addToCart(BasketItem item) {
    _basketItems.add(item);
    notifyListeners();
  }

  void removeFromCart(BasketItem item) {
    if (_basketItems.contains(item)) {
      _basketItems.remove(item);
      notifyListeners();
    }
  }
}