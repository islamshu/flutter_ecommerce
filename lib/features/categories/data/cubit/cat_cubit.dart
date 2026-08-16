import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/data/models/category_model.dart';
import '../category_product_model.dart';
import '../cats_rebo.dart';
import 'cat_state.dart';

class CatCubit extends Cubit<CatState> {
  final CatsRebo _catsRepo;

  List<CategoryModel> categories = [];
  List<CategoryProductModel> products = [];
  int selectedCategoryId = 0;

  CatCubit({required CatsRebo catsRepo})
      : _catsRepo = catsRepo,
        super(CatsInitial());

  Future<void> getCategories() async {
    try {
      emit(CatsLoading());

      categories = await _catsRepo.getCats();

      if (categories.isNotEmpty) {
        selectedCategoryId = categories.first.id;
        await _loadProducts(selectedCategoryId);
      } else {
        products = [];
        selectedCategoryId = 0;
        emit(CatsLoaded(
          cats: categories,
          products: products,
          selectedCategoryId: selectedCategoryId,
        ));
      }
    } catch (e) {
      emit(CatsError(message: e.toString()));
    }
  }

  Future<void> _loadProducts(int categoryId) async {
    emit(CatsLoaded(
      cats: categories,
      products: products,
      selectedCategoryId: selectedCategoryId,
      isLoadingProducts: true,
    ));

    try {
      products = await _catsRepo.getProducts(categoryId);

      emit(CatsLoaded(
        cats: categories,
        products: products,
        selectedCategoryId: selectedCategoryId,
        isLoadingProducts: false,
      ));
    } catch (e) {
      emit(CatsLoaded(
        cats: categories,
        products: products,
        selectedCategoryId: selectedCategoryId,
        isLoadingProducts: false,
      ));
      emit(CatsError(message: e.toString()));
    }
  }

  Future<void> changeCategory(int id) async {
    final categoryExists = categories.any((cat) => cat.id == id);
    if (!categoryExists) {
      emit(CatsError(message: 'Category with ID $id not found'));
      return;
    }

    try {
      selectedCategoryId = id;
      await _loadProducts(id);
    } catch (e) {
      emit(CatsError(message: e.toString()));
    }
  }

  CategoryModel? get selectedCategory {
    try {
      return categories.firstWhere(
            (cat) => cat.id == selectedCategoryId,
        orElse: () => throw Exception('Category not found'),
      );
    } catch (_) {
      return categories.isNotEmpty ? categories.first : null;
    }
  }
  Future refresh()async{
    await getCategories();
  }
}
