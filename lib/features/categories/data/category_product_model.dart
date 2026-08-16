class CategoryProductModel {
  final int id;
  final String name;
  final bool isFavorite;
  final String finalPrice;
  final String image;
  final int isFeatured;
  final double rating;
  String price;
  dynamic discountPrice;
  bool hasDiscount;
  String discountType;
  String discountValue;
  CategoryProductModel({
    required this.id,
    required this.name,
    required this.isFavorite,
    required this.finalPrice,
    required this.image,
    required this.isFeatured,
    required this.rating,
    required this.price,
    required this.discountPrice,
    required this.hasDiscount,
    required this.discountType,
    required this.discountValue,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      isFavorite: json['is_favorite'] as bool? ?? false,
      price: json['price']?.toString() ?? '',
      discountPrice: json['discount_price'] ?? '',
      hasDiscount: json['has_discount'] ?? false,
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value']?.toString() ?? '',
      finalPrice: json['final_price']?.toString() ?? '0', // ✅ تحويل آمن إلى String
      image: json['image'] as String? ?? '',
      isFeatured: json['is_featured'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0, // ✅ تحويل آمن إلى double
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
}