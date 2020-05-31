class TableGroup {
  int id;
  String name;
  List<Tables> tables;

  TableGroup({this.id, this.name, this.tables});

  TableGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['tables'] != null) {
      tables = new List<Tables>();
      json['tables'].forEach((v) {
        tables.add(new Tables.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.tables != null) {
      data['tables'] = this.tables.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}

class Tables {
  int id;
  String tableName;
  List<Orders> orders;

  Tables({this.id, this.tableName, this.orders});

  Tables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableName = json['tableName'];
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tableName'] = this.tableName;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  List<String> extraNames;
  int extraPrice;
  int productId;
  String productName;
  String productIcon;
  int qty;
  double price;
  String serveName;

  Orders(
      {this.extraNames,
        this.extraPrice,
        this.productId,
        this.productName,
        this.productIcon,
        this.qty,
        this.price,
        this.serveName});

  Orders.fromJson(Map<String, dynamic> json) {
    extraNames = json['extraNames'].cast<String>();
    extraPrice = json['extraPrice'];
    productId = json['product_id'];
    productName = json['product_name'];
    productIcon = json['productIcon'];
    qty = json['qty'];
    price = json['price'];
    serveName = json['serve_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraNames'] = this.extraNames;
    data['extraPrice'] = this.extraPrice;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['productIcon'] = this.productIcon;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['serve_name'] = this.serveName;
    return data;
  }
}
