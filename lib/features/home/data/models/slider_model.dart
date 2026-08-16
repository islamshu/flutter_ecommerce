class SliderModel {
  final int id;
  final String image;
  final String? title;

  SliderModel({
    required this.id,
    required this.image,
    this.title,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'title': title,
  };
}