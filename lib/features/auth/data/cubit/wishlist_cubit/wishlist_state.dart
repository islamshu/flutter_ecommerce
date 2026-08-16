import 'package:aycel/features/auth/data/user_model.dart';

abstract class WishlistState {}

class WishlistInit extends WishlistState {}

class WishListLoading extends WishlistState{}

class WishListLoaded extends WishlistState{}
class WishListError extends WishlistState{
  final String message;
  WishListError(this.message);
}

