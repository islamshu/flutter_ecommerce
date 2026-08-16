import '../../../home/data/models/category_model.dart';
import '../category_product_model.dart';

abstract class CatState {}

class CatsInitial extends CatState {}

class CatsLoading extends CatState {}

class CatsLoaded extends CatState {
  final List<CategoryModel> cats;
  final List<CategoryProductModel> products;
  final int selectedCategoryId;
  final bool isLoadingProducts;


  CatsLoaded({
    required this.cats,
    required this.products,
    required this.selectedCategoryId,
    this.isLoadingProducts = false,
  });
}

class CatsError extends CatState {
  final String message;

  CatsError({required this.message});
}
