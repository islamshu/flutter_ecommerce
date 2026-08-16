import 'package:aycel/features/checkout/data/checkout_repo.dart';
import 'package:aycel/features/checkout/data/city_model.dart';
import 'package:aycel/features/checkout/data/cubit/checkout_state.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/data/cart_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepo _checkoutRepo;

  CartModel? cart;
  OrderModel? order;
  List<CityModel> cities = [];
  CityModel? selectedCity;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedPaymentMethod;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod = method;
    emit(PaymentMethodSelected());
  }

  CheckoutCubit({required CheckoutRepo checkoutRepo})
    : _checkoutRepo = checkoutRepo,
      super(CheckoutInitial());

  Future<void> getCheckout() async {
    try {
      emit(CheckoutLoading());

      cart = await _checkoutRepo.getCart();
      cities = await _checkoutRepo.getCity();

      emit(CheckoutLoaded(carts: cart!, cities: cities));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }
  Future<void> sendCheckout(
       fname,
       lname,
       email,
       phone,
       payment_method,
       address,
       city_id,) async{
    try {
      emit(CheckoutSending());

      order = await _checkoutRepo.PostCheckout(fname,lname,email,phone,payment_method,address,city_id);

      emit(CheckoutSend( order:order as OrderModel));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  void selectCity(CityModel city) {
    selectedCity = city;

    emit(CheckoutLoaded(carts: cart!, cities: cities));
  }
}
