import 'dart:io';

import 'package:aycel/core/network/api_error.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/auth/data/user_model.dart';
import 'package:aycel/features/checkout/data/order_model.dart';
import 'package:aycel/features/home/data/models/home_product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constant/api_endpoints.dart';
import '../../../core/network/api_exceptions.dart';

class OrderRepo {
  final ApiService _apiService = ApiService();


  Future<List<OrderModel?>> get_orders() async {
    try {
      final response = await _apiService.get(ApiEndpoints.orders);

      if (response["code"] == 200) {
        return (response['data'] as List)
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];

    } catch (e) {
      rethrow;
    }
  }
}
