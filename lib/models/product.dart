class Product {
  int id;
  int categoryId;
  String productName;
  String icon;
  int stockId;
  int printerId;
  List<ServeTypes> serveTypes;
  List<Extras> extras;

  Product(
      {this.id,
        this.categoryId,
        this.productName,
        this.icon,
        this.stockId,
        this.printerId,
        this.serveTypes,
        this.extras});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    productName = json['product_name'];
    icon = json['icon'];
    stockId = json['stock_id'];
    printerId = json['printer_id'];
    if (json['serveTypes'] != null) {
      serveTypes = new List<ServeTypes>();
      json['serveTypes'].forEach((v) {
        serveTypes.add(new ServeTypes.fromJson(v));
      });
    }
    if (json['extras'] != null) {
      extras = new List<Extras>();
      json['extras'].forEach((v) {
        extras.add(new Extras.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryId'] = this.categoryId;
    data['product_name'] = this.productName;
    data['icon'] = this.icon;
    data['stock_id'] = this.stockId;
    data['printer_id'] = this.printerId;
    if (this.serveTypes != null) {
      data['serveTypes'] = this.serveTypes.map((v) => v.toJson()).toList();
    }
    if (this.extras != null) {
      data['extras'] = this.extras.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServeTypes {
  int serveTypeDefinitionId;
  String name;
  double price;
  double stockReductionAmount;

  ServeTypes(
      {this.serveTypeDefinitionId,
        this.name,
        this.price,
        this.stockReductionAmount});

  ServeTypes.fromJson(Map<String, dynamic> json) {
    serveTypeDefinitionId = json['serveTypeDefinitionId'];
    name = json['name'];
    price = json['price'];
    stockReductionAmount = json['stock_reduction_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serveTypeDefinitionId'] = this.serveTypeDefinitionId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['stock_reduction_amount'] = this.stockReductionAmount;
    return data;
  }
}

class Extras {
  int id;
  String name;
  double price;

  Extras({this.id, this.name, this.price});

  Extras.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
