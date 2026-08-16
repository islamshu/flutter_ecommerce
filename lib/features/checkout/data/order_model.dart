class OrderModel {
  final int? id;
  final String? code;
  final String? status;
  final double? total;
  final double? subtotal;
  final double? tax;
  final double? discount;
  final double? deleveryFee;
  final String? paymentMethod;
  final List<OrderItemModel>? items;
  final String? createdAt;
  final String? fname;
  final String? lname;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;



  OrderModel({
    this.id,
    this.code,
    this.status,
    this.total,
    this.subtotal,
    this.tax,
    this.discount,
    this.deleveryFee,
    this.paymentMethod,
    this.items,
    this.createdAt, this.fname, this.lname, this.email, this.phone, this.address, this.city,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      status: json['status'] as String?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      total: json['total'] != null
          ? double.tryParse(json['total'].toString())
          : null,
      subtotal: json['subtotal'] != null
          ? double.tryParse(json['subtotal'].toString())
          : null,
      tax: json['tax'] != null
          ? double.tryParse(json['tax'].toString())
          : null,
      discount: json['discount'] != null
          ? double.tryParse(json['discount'].toString())
          : null,
      deleveryFee: json['delevery_fee'] != null
          ? double.tryParse(json['delevery_fee'].toString())
          : null,
      paymentMethod: json['payment_method'] as String?,
      items: json['items'] != null
          ? (json['items'] as List)
          .map(
            (item) => OrderItemModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList()
          : null,
      createdAt: json['created_at'] as String?,

    );
  }
}

class OrderItemModel {
  final int? id;
  final int? productId;
  final String? productName;
  final String? color;
  final String? size;
  final int? quantity;
  final double? price;
  final double? total;
  final String? image;

  OrderItemModel({
    this.id,
    this.productId,
    this.productName,
    this.color,
    this.size,
    this.quantity,
    this.price,
    this.total,
    this.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int?,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String?,
      color: json['color'] as String?,
      size: json['size'] as String?,
      quantity: json['quantity'] as int?,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      total: json['total'] != null
          ? double.tryParse(json['total'].toString())
          : null,
      image: json['image'] as String?,
    );
  }
}