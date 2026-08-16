import 'package:aycel/core/constant/api_endpoints.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_exceptions.dart';

class TrackRepo {

  ApiService apiService = ApiService();

  Future<OrderModel>? get_order(order_code) async{
    try{
      final response = await apiService.get(ApiEndpoints.track+"/${order_code}");
      if (response["code"] == 200) {
        return OrderModel.fromJson(response["data"]);
      }
      throw ApiError(message: response?['message'] ?? 'Failed to get order');
    }on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }


}