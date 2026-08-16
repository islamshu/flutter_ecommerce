import 'package:flutter_bloc/flutter_bloc.dart';

import '../product_detail_model.dart';
import '../product_repo.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _productRepo;

  ProductCubit({required ProductRepo productRepo})
    : _productRepo = productRepo,
      super(ProductInit());

  ProductDetailModel? product;

  int selectedImage = 0;
  int selectedColor = 0;
  int selectedSize = 0;
  int quantity = 1;
  int? selectedColorId;
  int? selectedSizeId;

  Future<void> getProduct(int id) async {
    try {
      emit(ProductLoading());

      final result = await _productRepo.getDetiles(id);

      product = result;

      selectedImage = 0;
      selectedColor = 0;
      selectedSize = 0;
      selectedColorId = result.colors.isNotEmpty
          ? result.colors.first.id
          : null;
      selectedSizeId = result.sizes.isNotEmpty ? result.sizes.first.id : null;
      quantity = 1;

      emit(ProductLoaded(product: result));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void selectImage(int index) {
    selectedImage = index;

    if (product != null) {
      emit(ProductLoaded(product: product!));
    }
  }

  void selectColor(int index) {
    selectedColor = index;
    quantity = availableStock > 0 ? 1 : 0;
    selectedColorId = product!.colors[index].id;

    if (product != null) {
      emit(ProductLoaded(product: product!));
    }
  }

  void selectSize(int index) {
    selectedSize = index;
    quantity = availableStock > 0 ? 1 : 0;
    selectedSizeId = product!.sizes[index].id;

    if (product != null) {
      emit(ProductLoaded(product: product!));
    }
  }

  void increaseQuantity() {
    if (quantity < availableStock) {
      quantity++;
      emit(ProductLoaded(product: product!));
    }
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      emit(ProductLoaded(product: product!));
    }
  }

  Variation? get selectedVariation {
    if (product == null) return null;

    final hasColors = product!.colors.isNotEmpty;
    final hasSizes = product!.sizes.isNotEmpty;
    final colorId = hasColors ? product!.colors[selectedColor].id : null;
    final sizeId = hasSizes ? product!.sizes[selectedSize].id : null;

    try {
      return product!.variations.firstWhere((v) {
        if (hasColors && hasSizes) {
          return v.colorId == colorId && v.sizeId == sizeId;
        }

        if (hasColors) {
          return v.colorId == colorId;
        }

        if (hasSizes) {
          return v.sizeId == sizeId;
        }

        return true;
      });
    } catch (_) {
      return null;
    }
  }

  int get availableStock => selectedVariation?.stock ?? 0;

  Future refresh() async {
    await getProduct(product!.id);
  }
}
