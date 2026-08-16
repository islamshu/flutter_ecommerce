class AuthModel {
  int id;
  String name;
  String phoneNumber;
  dynamic cityId;
  bool isActive;
  String token;
  DateTime createdAt;

  AuthModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.cityId,
    required this.isActive,
    required this.token,
    required this.createdAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    id: json["id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    cityId: json["city_id"],
    isActive: json["is_active"],
    token: json["token"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone_number": phoneNumber,
    "city_id": cityId,
    "is_active": isActive,
    "token": token,
    "created_at": createdAt.toIso8601String(),
  };
}
