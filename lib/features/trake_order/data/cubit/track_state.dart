import 'package:aycel/features/checkout/data/order_model.dart';

abstract class TrackState {}

class TrackInitial extends TrackState{}

class TrackLoading extends TrackState{}

class TrackLoaded extends TrackState{
  final OrderModel order;
  TrackLoaded({required this.order});
}

class TrackErorr extends TrackState{
  final String erorr;
  TrackErorr({required this.erorr});
}