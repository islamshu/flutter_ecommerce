import '../models/category_model.dart';
import '../models/home_model.dart';
import '../models/home_product_model.dart';
import '../models/slider_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final HomeModel home;

  HomeLoaded(this.home);
}
class HomeLoadedOld extends HomeState {
  final List<SliderModel> sliders;
  final List<CategoryModel> categories;
  final List<HomeProductModel> products;

  HomeLoadedOld({
    required this.sliders,
    required this.categories,
    required this.products,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class FavLoading extends HomeState{}

class FavError extends HomeState {
  final String message;
  FavError(this.message);
}
class FavSuccess extends HomeState{
  final String message;
  FavSuccess(this.message);
}