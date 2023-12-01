class Product {
  int? id;
  String? pname;
  String? pprice;
  String? pdesc;
  String? pimg;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
        this.pname,
        this.pprice,
        this.pdesc,
        this.pimg,
        this.createdAt,
        this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pname = json['pname'];
    pprice = json['pprice'];
    pdesc = json['pdesc'];
    pimg = json['pimg'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pname'] = this.pname;
    data['pprice'] = this.pprice;
    data['pdesc'] = this.pdesc;
    data['pimg'] = this.pimg;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}