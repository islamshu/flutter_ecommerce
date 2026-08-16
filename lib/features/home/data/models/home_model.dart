import 'category_model.dart';
import 'home_product_model.dart';
import 'slider_model.dart';

class HomeModel {
  final List<SliderModel>? sliders;
  final List<CategoryModel>? categories;
  final List<HomeProductModel>? featuredProducts;

  HomeModel({
     this.sliders,
     this.categories,
     this.featuredProducts,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    final sliders = (data['sliders'] as List)
        .map((e) => SliderModel.fromJson(e))
        .toList();

    final categories = (data['categories'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();

    final products = (data['featured_products'] as List)
        .map((e) => HomeProductModel.fromJson(e))
        .toList();

    return HomeModel(
      sliders: sliders,
      categories: categories,
      featuredProducts: products,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'sliders': sliders?.map((e) => e.toJson()).toList() ?? [],
        'categories': categories?.map((e) => e.toJson()).toList() ??[],
        'featured_products':
        featuredProducts?.map((e) => e.toJson()).toList()??[],
      }
    };
  }
}