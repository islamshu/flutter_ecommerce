import 'package:aycel/features/cart/data/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel carts;
  CartLoaded({required this.carts});
}
class CartError extends CartState {
  final String message;
  CartError({required this.message});
}
class CartErrorUpdate extends CartState{
  final String message;
  CartErrorUpdate({required this.message});
}
class CartItemUpdated extends CartState {
  final int itemId;

  CartItemUpdated({
    required this.itemId,
  });
}
