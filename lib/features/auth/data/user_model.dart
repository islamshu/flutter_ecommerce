class UserModel {
  int id;
  String name;
  String phoneNumber;
  dynamic? cityId;
  bool isActive;
  String image;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.cityId,
    required this.isActive,
    required this.image,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ,
    name: json["name"],
    phoneNumber: json["phone_number"],
    cityId: json["city_id"] ?? null,
    isActive: json["is_active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone_number": phoneNumber,
    "city_id": cityId,
    "is_active": isActive,
    "image": image,
    "created_at": createdAt.toIso8601String(),
  };
}
