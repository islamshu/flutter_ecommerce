import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/features/product/data/product_detail_model.dart';

class ProductRepo {
  ApiService _apiService = ApiService();

  Future<ProductDetailModel> getDetiles(int id) async{
    try {
      final response = await _apiService.get('/products/$id');
      if (response["code"] == 200) {
        return ProductDetailModel.fromJson(response["data"]);
      }
      throw Exception('Unexpected response format');
    } catch (e) {
      rethrow;
    }
  }
}