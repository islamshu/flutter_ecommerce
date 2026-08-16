import 'package:aycel/features/cart/data/cart_model.dart';
import 'package:aycel/features/checkout/data/city_model.dart';
import 'package:aycel/features/checkout/data/order_model.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final CartModel carts;
  final List<CityModel> cities;

  CheckoutLoaded({required this.carts, required this.cities});
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});
}

class PaymentMethodSelected extends CheckoutState {}

class CheckoutSending extends CheckoutState {}

class CheckoutSend extends CheckoutState {
  final OrderModel order;

  CheckoutSend({required this.order});
}
