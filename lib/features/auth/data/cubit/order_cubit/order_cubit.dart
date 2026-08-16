import 'package:aycel/features/auth/data/cubit/order_cubit/order_state.dart';
import 'package:aycel/features/auth/data/cubit/wishlist_cubit/wishlist_state.dart';
import 'package:aycel/features/auth/data/order_repo.dart';
import 'package:aycel/features/auth/data/wishlist_repo.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home/data/models/home_product_model.dart';
import '../../auth_repo.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required OrderRepo orderRepo})
: _orderRepo = orderRepo,
super(OrderInit()) {
getOrders();
}
final OrderRepo _orderRepo;
 List<OrderModel?> orders =[];

Future<void> getOrders()async{
  emit(OrderLoading());
  try{
    orders = await _orderRepo.get_orders();
    emit(OrderLoaded());
  }catch(e){
    emit(OrderError(e.toString()));
  }
}
Future<void> refresh() async{
 await getOrders();
}
}



