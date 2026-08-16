abstract class CartProductState {}

class CartInitial extends CartProductState {}

class CartAdding extends CartProductState {}

class CartAdded extends CartProductState {}

class CartError extends CartProductState {
  final String message;
  CartError(this.message);
}