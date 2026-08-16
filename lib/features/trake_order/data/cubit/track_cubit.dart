import 'package:aycel/core/router/app_routes.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:aycel/features/trake_order/data/cubit/track_state.dart';
import 'package:aycel/features/trake_order/data/track_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TrackCubit extends Cubit<TrackState> {
  final TrackRepo _trackRepo;

  OrderModel? order;
  TextEditingController code = TextEditingController() ;

  TrackCubit({required TrackRepo trackRepo})
      : _trackRepo = trackRepo,
        super(TrackInitial());

  Future<void> get_order(String orderCode) async {
    try {
      emit(TrackLoading());

      final order = await _trackRepo.get_order(orderCode);

      emit(TrackLoaded(order: order!));
    } catch (e) {
      emit(TrackErorr(erorr: e.toString()));
    }
  }

}


