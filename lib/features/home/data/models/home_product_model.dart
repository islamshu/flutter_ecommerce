class HomeProductModel {
  final int id;
  final String name;
  bool isFavorite;
  final String finalPrice;
  final String image;
  final int isFeatured;
  final double rating;
  String price;
  dynamic discountPrice;
  bool hasDiscount;
  String discountType;
  String discountValue;

  HomeProductModel({
    required this.id,
    required this.name,
    required this.isFavorite,
    required this.price,
    required this.finalPrice,
    required this.image,
    required this.isFeatured,
    required this.rating,
    required this.discountPrice,
    required this.hasDiscount,
    required this.discountType,
    required this.discountValue,
  });

  factory HomeProductModel.fromJson(Map<String, dynamic> json) {
    return HomeProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      price: json['price']?.toString() ?? '',
      discountPrice: json['discount_price'] ?? '',
      hasDiscount: json['has_discount'] ?? false,
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value']?.toString() ?? '',
      finalPrice: json['final_price'] ?? "",
      image: json['image'] ?? '',
      isFeatured: json['is_featured'] ?? 0,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_favorite': isFavorite,
      'final_price': finalPrice,
      'image': image,
      'is_featured': isFeatured,
      'rating': rating,
    };
  }

  HomeProductModel copyWith({bool? isFavorite}) {
    return HomeProductModel(
      id: id,
      name: name,
      isFavorite: isFavorite ?? this.isFavorite,
      finalPrice: finalPrice,
      image: image,
      isFeatured: isFeatured,
      rating: rating,
      price: price,
      discountPrice: discountPrice,
      hasDiscount: hasDiscount,
      discountType: discountType,
      discountValue: discountValue,
    );
  }
}
