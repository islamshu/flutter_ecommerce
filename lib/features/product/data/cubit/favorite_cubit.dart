import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/data/home_repo.dart';
import '../../../home/data/models/home_product_model.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({
    required this.homeRepo,
  }) : super(FavoriteInitial());

  final HomeRepo homeRepo;

  final Set<int> favoriteIds = {};

  bool isFavorite(int id) => favoriteIds.contains(id);

  Future<void> getFavorites() async {
    try {
      final favorites = await homeRepo.getFavorites();



      favoriteIds
        ..clear()
        ..addAll(favorites.map((e) => e.id));


      emit(FavoriteUpdated());
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> toggle(int productId) async {
    final oldValue = isFavorite(productId);

    emit(FavoriteLoading(productId));

    try {
      final result = await homeRepo.sendFav(productId);

      if (result) {
        favoriteIds.add(productId);
      } else {
        favoriteIds.remove(productId);
      }

      emit(FavoriteUpdated());
    } catch (e) {
      emit(FavoriteError(e.toString()));

      // لإزالة الـ loading
      emit(FavoriteUpdated());
    }
  }
}