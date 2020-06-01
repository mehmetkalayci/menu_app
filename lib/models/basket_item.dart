class BasketItem {
  int id;
  List<int> extraIds;
  List<String> extraNames;
  double extraPrice;
  double price;
  int printerId;
  int productId;
  String productName;
  String productIcon; // bu alanı json kısmına dahil etmedik
  int qty;
  int serveId;
  String serveName;
  int stockId;
  double stockReductionAmount;
  int tableId;
  String username;
  String orderMemo;

  BasketItem(
      {this.id,
        this.extraIds,
        this.extraNames,
        this.extraPrice,
        this.price,
        this.printerId,
        this.productId,
        this.productName,
        this.productIcon,
        this.qty,
        this.serveId,
        this.serveName,
        this.stockId,
        this.stockReductionAmount,
        this.tableId,
        this.username,
        this.orderMemo});

  BasketItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    extraIds = json['extraIds'].cast<int>();
    extraNames = json['extraNames'].cast<String>();
    extraPrice = json['extraPrice'];
    price = json['price'];
    printerId = json['printer_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    qty = json['qty'];
    serveId = json['serve_id'];
    serveName = json['serve_name'];
    stockId = json['stock_id'];
    stockReductionAmount = json['stock_reduction_amount'];
    tableId = json['table_id'];
    username = json['username'];
    orderMemo = json['order_memo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['extraIds'] = this.extraIds;
    data['extraNames'] = this.extraNames;
    data['extraPrice'] = this.extraPrice;
    data['price'] = this.price;
    data['printer_id'] = this.printerId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['qty'] = this.qty;
    data['serve_id'] = this.serveId;
    data['serve_name'] = this.serveName;
    data['stock_id'] = this.stockId;
    data['stock_reduction_amount'] = this.stockReductionAmount;
    data['table_id'] = this.tableId;
    data['username'] = this.username;
    data['order_memo'] = this.orderMemo;
    return data;
  }
}
