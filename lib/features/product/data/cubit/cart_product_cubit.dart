import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart_product_repo.dart';
import 'cart_product_state.dart';

class CartProductCubit extends Cubit<CartProductState> {
  CartProductCubit({
    required this.cartRepo,
  }) : super(CartInitial());

  final CartProductRepo cartRepo;

  Future<void> addToCart({
    required int productId,
     int? colorId,
     int? sizeId,
    required int quantity,
  }) async {
    emit(CartAdding());

    try {
      await cartRepo.addToCart(
        productId: productId,
        colorId: colorId ,
        sizeId: sizeId ,
        quantity: quantity,
      );

      emit(CartAdded());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}