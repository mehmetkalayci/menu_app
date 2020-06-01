import 'package:flutter/material.dart';
import 'package:menuapp/models/basket_item.dart';

class BasketState  with ChangeNotifier {


  int _lastTableId = 0;
  String _lastTableName = '';
  int _lastSelectedProduct = 0;
  List<BasketItem> _basketItems = [];

  List<BasketItem> get getBasketItems => _basketItems;
  int get getLastTableId => _lastTableId;
  String get getLastTableName => _lastTableName;
  int get getLastSelectedProduct => _lastSelectedProduct;

  void setLastTable(int tableId, String tableName) {
    this._lastTableId = tableId;
    this._lastTableName = tableName;
    notifyListeners();
  }

  void setLastSelectedProductId(int selectedProductId) {
    this._lastSelectedProduct = selectedProductId;
    notifyListeners();
  }

  void addToCart(BasketItem item) {
    _basketItems.add(item);
    notifyListeners();
  }

  void clear(BasketItem item) {
    if (_basketItems.remove(item)) {
      notifyListeners();
    }
  }
}