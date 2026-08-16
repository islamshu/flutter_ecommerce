import 'package:aycel/features/auth/data/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:aycel/features/auth/data/wishlist_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home/data/models/home_product_model.dart';
import '../../auth_repo.dart';

class WishlistCubit extends Cubit<WishlistState> {
WishlistCubit({required WishlistRepo wishlistRepo})
: _wishlistRepo = wishlistRepo,
super(WishlistInit()) {
getProducts();
}
final WishlistRepo _wishlistRepo;
 List<HomeProductModel?> products =[];

Future<void> getProducts()async{
  emit(WishListLoading());
  try{
    products = await _wishlistRepo.get_products();
    emit(WishListLoaded());
  }catch(e){
    emit(WishListError(e.toString()));
  }
}
Future<void> refresh() async{
 await getProducts();
}
}



