import 'package:aycel/features/cart/data/cart_model.dart';
import 'package:aycel/features/cart/data/cart_rebo.dart';
import 'package:aycel/features/cart/data/cubit/cart_state.dart';
import 'package:aycel/features/product/data/cart_product_repo.dart'
    hide CartRepo;
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this.cartRepo}) : super(CartInitial());

  final CartRepo cartRepo;

  CartModel? cart;
  int? updatingItemId;

  Future<void> getCartData() async {
    try {
      emit(CartLoading());

      cart = await cartRepo.getCart();

      emit(CartLoaded(carts: cart!));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> increaseQuantity(int cartItemId, int quantity) async {
    try {
      updatingItemId = cartItemId;
      emit(CartLoaded(carts: cart!));

      await cartRepo.updateCart(cartItemId, quantity);

      final index = cart!.items.indexWhere((item) => item.id == cartItemId);

      if (index != -1) {
        final oldItem = cart!.items[index];

        cart!.items[index] = oldItem.copyWith(
          quantity: quantity,
          total: oldItem.price * quantity,
        );

        cart = cart!.copyWith(
          subtotal: cart!.items.fold(0, (sum, item) => sum! + item.total),
        );
      }

      updatingItemId = null;

      emit(CartLoaded(carts: cart!));
    } catch (e) {
      updatingItemId = null;

      emit(CartErrorUpdate(message: e.toString()));
    }
  }

  Future<void> decreaseQuantity(int cartItemId, int quantity) async {
    try {
      updatingItemId = cartItemId;
      emit(CartLoaded(carts: cart!));

      await cartRepo.updateCart(cartItemId, quantity);

      final index = cart!.items.indexWhere((item) => item.id == cartItemId);

      if (index != -1) {
        final oldItem = cart!.items[index];

        cart!.items[index] = oldItem.copyWith(
          quantity: quantity,
          total: oldItem.price * quantity,
        );

        cart = cart!.copyWith(
          subtotal: cart!.items.fold(0, (sum, item) => sum! + item.total),
        );
      }
      updatingItemId = null;

      emit(CartLoaded(carts: cart!));
    } catch (e) {
      emit(CartErrorUpdate(message: e.toString()));
    }
  }

  Future remove(id) async {
    try {
      emit(CartLoading());
      await cartRepo.removeCart(id);
      cart = await cartRepo.getCart();
      emit(CartLoaded(carts: cart!));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
