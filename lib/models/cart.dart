// ignore_for_file: non_constant_identifier_names

class Cart {
  String? cart_id;
  String? subject_name;
  String? price;
  String? cart_qty;
  String? subject_id;
  String? totalprice;

  Cart(
      {this.cart_id,
      this.subject_name,
      this.price,
      this.cart_qty,
      this.subject_id,
      this.totalprice});

  Cart.fromJson(Map<String, dynamic> json) {
    cart_id = json['cart_id'];
    subject_name = json['subject_name'];
    price = json['price'];
    cart_qty = json['cart_qty'];
    subject_id = json['subject_id'];
    totalprice = json['totalprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cart_id;
    data['subject_name'] = subject_name;
    data['price'] = price;
    data['cart_qty'] = cart_qty;
    data['subject_id'] = subject_id;
    data['totalprice'] = totalprice;
    return data;
  }
}
