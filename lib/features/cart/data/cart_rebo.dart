import 'package:aycel/core/constant/api_endpoints.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/cart/data/cart_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_exceptions.dart';

class CartRepo {
  ApiService apiService = ApiService();

  Future<CartModel> getCart() async {
    try {
      final response = await apiService.get(ApiEndpoints.cart);
      if ( response['code'] == 200) {
        final list = response['data'] ;
        return CartModel.fromJson(response['data']);
      } else {
        throw ApiError(message: response?['message'] ?? 'Failed to get cart');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  Future<bool> removeCart(int productId) async {
    try {
      final response = await apiService.delete(ApiEndpoints.cart+'/${productId}');
      if ( response['code'] == 200) {
       return true;
      } else {
        throw ApiError(message: response?['message'] ?? 'Failed to get cart');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  Future<CartModel> updateCart(int productId,int quantity) async {
    try {
      final response = await apiService.put(ApiEndpoints.cart+'/${productId}',body: {
        "quantity":quantity
      });
      if ( response['code'] == 200) {
        final list = response['data'] ;
        return CartModel.fromJson(response['data']);
      } else {
        throw ApiError(message: response?['message'] ?? 'Failed to get cart');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }


}