class CityModel {
  final int id;
  final String title;
  final int price;

  CityModel({required this.id, required this.title, required this.price});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: json['price']  as int? ?? 0,
    );
  }
}
