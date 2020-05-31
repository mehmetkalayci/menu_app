class Category {
  int id;
  String categoryName;
  int parentId;
  String icon;

  Category({this.id, this.categoryName, this.parentId, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    parentId = json['parent_id'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['parent_id'] = this.parentId;
    data['icon'] = this.icon;
    return data;
  }

  @override
  String toString() {
    return " id:" +
        this.id.toString() +
        ", categoryName:" +
        this.categoryName;
  }
}
