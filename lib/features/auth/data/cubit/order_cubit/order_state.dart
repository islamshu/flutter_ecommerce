import 'package:aycel/features/auth/data/user_model.dart';

abstract class OrderState {}

class OrderInit extends OrderState {}

class OrderLoading extends OrderState{}

class OrderLoaded extends OrderState{}
class OrderError extends OrderState{
  final String message;
  OrderError(this.message);
}

