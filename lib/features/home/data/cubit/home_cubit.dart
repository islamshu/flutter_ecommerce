import 'package:flutter_bloc/flutter_bloc.dart';
import '../home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  final HomeRepo homeRepo;

  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      final home = await homeRepo.getHomeData();
      emit(HomeLoaded(home));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
  // Future<void> getHomeData() async {
  //   emit(HomeLoading());
  //
  //   try {
  //     final sliders = await homeRepo.getSliders();
  //     final categories = await homeRepo.getcats();
  //     final products = await  homeRepo.getproducts();
  //
  //     emit(
  //       HomeLoaded(
  //         sliders: sliders,
  //         categories: categories,
  //         products: products,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(HomeError(e.toString()));
  //   }
  // }
  Future<void> sendFav(productId) async {
    final response =homeRepo.sendFav(productId);
  }
  Future<void> refresh() => getHomeData();
}