import '../product_detail_model.dart';

abstract class ProductState {}

class ProductInit extends ProductState {}

class ProductLoading extends ProductState{}

class ProductLoaded extends ProductState{
  final ProductDetailModel product;
  ProductLoaded({required this.product});
}

class ProductError extends ProductState{
  final String message;
  ProductError({required this.message});
}