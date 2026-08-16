import 'dart:ui';

import 'package:flutter/material.dart';

class ProductDetailModel {
  int id;
  bool isFavorite;
  String name;
  String shortDescription;
  String price;
  dynamic discountPrice;
  bool hasDiscount;
  String discountType;
  String discountValue;
  String finalPrice;
  String sku;
  String image;
  int status;
  int isFeatured;
  Category category;
  String variationType;
  List<ColorModel> colors;
  List<SizeModel> sizes;
  List<ProductImage> thumbnails;
  List<ProductImage> images;
  List<Variation> variations;
  double rating;
  DateTime createdAt;

  ProductDetailModel({
    required this.id,
    required this.isFavorite,
    required this.name,
    required this.shortDescription,
    required this.price,
    required this.discountPrice,
    required this.hasDiscount,
    required this.discountType,
    required this.discountValue,
    required this.finalPrice,
    required this.sku,
    required this.image,
    required this.status,
    required this.isFeatured,
    required this.category,
    required this.variationType,
    required this.colors,
    required this.sizes,
    required this.thumbnails,
    required this.images,
    required this.variations,
    required this.rating,
    required this.createdAt,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      price: json['price']?.toString() ?? '',
      discountPrice: json['discount_price'] ?? '',
      hasDiscount: json['has_discount'] ?? false,
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value']?.toString() ?? '',
      finalPrice: json['final_price'] ?? "",
      sku: json['sku'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      isFeatured: json['is_featured'] ?? 0,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category(id: 0, name: '', slug: ''),
      variationType: json['variation_type'] ?? '',
      colors: (json['colors'] as List? ?? [])
          .map((e) => ColorModel.fromJson(e))
          .toList(),
      sizes: (json['sizes'] as List? ?? [])
          .map((e) => SizeModel.fromJson(e))
          .toList(),
      thumbnails: (json['thumbnails'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      variations: (json['variations'] as List? ?? [])
          .map((e) => Variation.fromJson(e))
          .toList(),
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_favorite': isFavorite,
      'name': name,
      'short_description': shortDescription,
      'price': price,
      'discount_price': discountPrice,
      'has_discount': hasDiscount,
      'discount_type': discountType,
      'discount_value': discountValue,
      'final_price': finalPrice,
      'sku': sku,
      'image': image,
      'status': status,
      'is_featured': isFeatured,
      'category': category.toJson(),
      'variation_type': variationType,
      'colors': colors,
      'sizes': sizes.map((e) => e.toJson()).toList(),
      'thumbnails': thumbnails.map((e) => e.toJson()).toList(),
      'images': images.map((e) => e.toJson()).toList(),
      'variations': variations.map((e) => e.toJson()).toList(),
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Category {
  int id;
  String name;
  String slug;

  Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], slug: json['slug']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}

class ProductImage {
  int id;
  String image;

  ProductImage({required this.id, required this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(id: json['id'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image};
  }
}

class ColorModel {
  int id;
  String name;
  String code;

  ColorModel({required this.id, required this.name, required this.code});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(id: json['id'], name: json['name'], code: json['code']);
  }
  Color get color {
    try {
      String hex = code.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return Colors.black;
    } catch (e) {
      return Colors.black;
    }
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }
}

class SizeModel {
  int id;
  String name;

  SizeModel({required this.id, required this.name});

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Variation {
  int id;
  int productId;
  dynamic colorId;
  dynamic color;
  dynamic colorCode;
  int sizeId;
  String size;
  int stock;

  Variation({
    required this.id,
    required this.productId,
    required this.colorId,
    required this.color,
    required this.colorCode,
    required this.sizeId,
    required this.size,
    required this.stock,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      colorId: json['color_id'] ?? 0,
      color: json['color']?? '',
      colorCode: json['color_code']?? '',
      sizeId: json['size_id'] ?? 0,
      size: json['size']?? '',
      stock: json['stock']?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'color_id': colorId,
      'color': color,
      'color_code': colorCode,
      'size_id': sizeId,
      'size': size,
      'stock': stock,
    };
  }
}
