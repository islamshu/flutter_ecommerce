import 'dart:io';

import 'package:aycel/core/network/api_error.dart';
import 'package:aycel/core/network/api_service.dart';
import 'package:aycel/core/utils/pref_helper.dart';
import 'package:aycel/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constant/api_endpoints.dart';
import '../../../core/network/api_exceptions.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  Future<void> login(String phone, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        body: {'phone_number': phone, 'password': password},
      );

      if (response["code"] == 200) {
        String token = response["data"]["client"]["token"];
        await PrefHelper.saveToken(token);
      }

    } catch (e) {
      rethrow;
    }
  }
  Future<void> register(
    String name,
    String phone,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        body: {
          'name': name,
          'phone': phone,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );
      if (response["code"] == 200) {
        String token = response["data"]["client"]["token"];
        await PrefHelper.saveToken(token);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> get_user() async {
    try {
      final response = await _apiService.get(ApiEndpoints.profile);

      if (response['data'] != null) {
        return UserModel.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> updateProfile({
    required String name,
    required String phone,
    String? image,
  }) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('name', name),
        MapEntry('phone_number', phone),
      ]);

      if (image != null && image.isNotEmpty) {
        final file = File(image);
        if (await file.exists()) {
          final multipartFile = await MultipartFile.fromFile(
            image,
            filename: 'profile_image.jpg',
          );
          formData.files.add(MapEntry('image', multipartFile));
        }
      }

      final response = await _apiService.post(
        ApiEndpoints.profile,
        body: formData,
      );

      if (response['data'] != null) {
        return UserModel.fromJson(response['data']);
      }

      return null;
    } on DioException catch (e) {
      throw ApiExceptions.handleException(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  Future<void> changePassword(
      String oldPassword,
      String newPassword,
      String confirmNewPassword,
      ) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.chagnePassword,
        body: {
          'current_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmNewPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<void> logout() async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.logout,
      );
      await PrefHelper.removeToken();

    } catch (e) {
      rethrow;
    }
  }
}
