import 'package:dio/dio.dart';

import 'api_exceptions.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dioClient.dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await _dioClient.dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    }
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await _dioClient.dio.put(
        endpoint,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // ✅ مهم جداً
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    }
  }

  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    try {
      final response = await _dioClient.dio.delete(endpoint, data: body);

      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    }
  }
}