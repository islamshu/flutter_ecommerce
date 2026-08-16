import 'package:aycel/core/constant/api_endpoints.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/categories/data/category_product_model.dart';
import 'package:aycel/features/home/data/models/category_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_exceptions.dart';

class CatsRebo {
  ApiService apiService = ApiService();

  Future<List<CategoryModel>> getCats() async {
    try {
      final response = await apiService.get(ApiEndpoints.categories);
      if (response["code"]  == 200) {
        return (response["data"]["categories"] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<List<CategoryProductModel>> getProducts(int categoryId) async {
    try {
      final response = await apiService.get(
        "${ApiEndpoints.categories}/$categoryId/products",
      );

      final list = response["data"]["products"] as List;
      return list
          .map((e) => CategoryProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }}
