import 'package:aycel/core/constant/api_endpoints.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/home/data/models/category_model.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_exceptions.dart';
import 'models/home_model.dart';
import 'models/home_product_model.dart';
import 'models/slider_model.dart';

class HomeRepo {
  final ApiService apiService = ApiService();

  Future<HomeModel> getHomeData() async {
    try {
      final response = await apiService.get(ApiEndpoints.home);
    if (response["code"] == 200) {


      return HomeModel.fromJson(response);
    }

      throw Exception('Unexpected response format');
    } catch (e) {
      rethrow;
    }
  }
  Future<List<SliderModel>> getSliders() async {
    try {
      final response = await apiService.get(ApiEndpoints.home);

      if (response["code"] == 200) {
        return (response['data']['sliders'] as List)
            .map((e) => SliderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      rethrow;
    }
  }
  Future<List<HomeProductModel>> getproducts() async {
    try {
      final response = await apiService.get(ApiEndpoints.home);

      if (response["code"] == 200) {
        return (response['data']['featured_products'] as List)
            .map((e) => HomeProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unexpected response format');
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }


  Future<List<CategoryModel>> getcats() async {
    try {
      final response = await apiService.get(ApiEndpoints.home);

      if (response["code"] == 200) {
        return (response['data']['categories'] as List)
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unexpected response format');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendFav(int productId) async {
    try {
      final response = await apiService.post(ApiEndpoints.wishlist + "/toggle",body: {
        "product_id" :productId,
      });

      if (response["code"] == 200) {
        return response["data"]["in_wishlist"];
      }
      throw Exception('Unexpected response format');
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  Future<List<HomeProductModel>> getFavorites() async {
    try {
      final response = await apiService.get(ApiEndpoints.wishlist);

      if (response["code"] == 200) {
        return (response['data'] as List)
            .map((e) => HomeProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unexpected response format');
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }


}
