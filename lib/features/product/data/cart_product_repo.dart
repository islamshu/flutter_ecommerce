import 'package:aycel/core/network/api_service.dart';

import '../../../core/constant/api_endpoints.dart';

class CartProductRepo {
  ApiService apiService = ApiService();
  Future<bool> addToCart({
    required int productId,
     int? colorId,
     int? sizeId,
    required int quantity,
  }) async {
    final response = await apiService.post(
      ApiEndpoints.cart,
      body: {
        "product_id": productId,
        "color_id": colorId,
        "size_id": sizeId,
        "quantity": quantity,
      },
    );

    if (response["code"] == 200) {
      return response["data"]["is_added"];
    }

    throw Exception(response["message"]);
  }
}