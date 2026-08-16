import 'package:flutter/material.dart';

class CartModel {
  final List<CartItem> items;
  final int itemsCount;
  final int subtotal;

  CartModel({
    required this.items,
    required this.itemsCount,
    required this.subtotal,
  });

  CartModel copyWith({List<CartItem>? items, int? subtotal}) {
    return CartModel(
      items: items ?? this.items,
      itemsCount: items?.length ?? itemsCount,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e))
              .toList() ??
          [],
      itemsCount: json['items_count'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
    );
  }
}

class CartItem {
  final int id;
  final int quantity;
  final int price;
  final int total;
  final int availableStock;
  final CartProduct product;
  final CartColor? color;
  final CartSize? size;

  CartItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.total,
    required this.availableStock,
    required this.product,
    this.color,
    this.size,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      total: json['total'] ?? 0,
      availableStock: json['available_stock'] ?? 0,
      product: CartProduct.fromJson(json['product']),
      color: json['color'] != null ? CartColor.fromJson(json['color']) : null,
      size: json['size'] != null ? CartSize.fromJson(json['size']) : null,
    );
  }

  CartItem copyWith({int? quantity, int? total}) {
    return CartItem(
      id: id,
      quantity: quantity ?? this.quantity,
      price: price,
      total: total ?? this.total,
      availableStock: availableStock,
      product: product,
      color: color,
      size: size,
    );
  }
}

class CartProduct {
  final int id;
  final String name;
  final String image;
  final String finalPrice;
  final bool hasDiscount;
  final String variationType;

  CartProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.finalPrice,
    required this.hasDiscount,
    required this.variationType,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      finalPrice: json['final_price'] ?? '0',
      hasDiscount: json['has_discount'] ?? false,
      variationType: json['variation_type'] ?? '',
    );
  }
}

class CartColor {
  final int id;
  final String name;
  final String code;

  CartColor({required this.id, required this.name, required this.code});

  factory CartColor.fromJson(Map<String, dynamic> json) {
    return CartColor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class CartSize {
  final int id;
  final String name;

  CartSize({required this.id, required this.name});

  factory CartSize.fromJson(Map<String, dynamic> json) {
    return CartSize(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
