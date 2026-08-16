import 'package:aycel/core/constant/api_endpoints.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/cart/data/cart_model.dart';
import 'package:aycel/features/checkout/data/city_model.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_exceptions.dart';

class CheckoutRepo {
  ApiService apiService = ApiService();

  Future<List<CityModel>> getCity() async {
    try {
      final response = await apiService.get(ApiEndpoints.cities);
      if (response["code"] == 200) {
        return (response["data"]["cities"] as List)
            .map((e) => CityModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<CartModel> getCart() async {
    try {
      final response = await apiService.get(ApiEndpoints.cart);
      if (response['code'] == 200) {
        final list = response['data'];
        return CartModel.fromJson(response['data']);
      } else {
        throw ApiError(message: response?['message'] ?? 'Failed to get cart');
      }
    } on DioException catch (e) {
      print("errorrrr");
      throw ApiExceptions.handleException(e);
    } catch (e) {
      print("errorrrr");
      throw ApiError(message: e.toString());
    }
  }
  Future<OrderModel> PostCheckout(
    String fname,
      String lname,
      String email,
      String phone,
      String payment_method,
      String address,
      int city_id,
  ) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.checkout,
        body: {
          "fname": fname,
          "lname": lname,
          "email": email,
          "phone": phone,
          "payment_method": payment_method,
          "address": address,
          "city_id": city_id,
        },
      );
      if (response['code'] == 200) {
        return OrderModel.fromJson(response['data']['order']);
      } else {
        throw ApiError(message: response?['message'] ?? 'Failed to get cart');
      }
    } on DioException catch (e) {
      print("errorrrr");
      throw ApiExceptions.handleException(e);
    } catch (e) {
      print("errorrrr");
      throw ApiError(message: e.toString());
    }
  }
}
