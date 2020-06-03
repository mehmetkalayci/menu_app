import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:menuapp/models/basket_item.dart';
import 'package:menuapp/models/table_group.dart';

class BasketState  with ChangeNotifier {

  // hangi masaya ürün ekleneceği bulmak için
  Tables _lastSelectedTable;
  Tables get getLastSelectedTable => _lastSelectedTable;

  // en son seçilen ürün değeri
//  Product _lastSelectedProduct;
//  Product get getLastSelectedProduct => _lastSelectedProduct;


  // mevcut sepeti tut
  List<BasketItem> _basketItems = [];
  List<BasketItem> get getBasketItems => _basketItems;




  //////////////////////////////////////

  void setLastTable(Tables table) {
    this._lastSelectedTable = table;
    notifyListeners();
  }

//  void setLastSelectedProduct(Product product) {
//    this._lastSelectedProduct = product;
//    notifyListeners();
//  }

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