import 'package:dio/dio.dart';

import 'api_error.dart';

class ApiExceptions {
  static ApiError handleException(DioException e) {

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Connection timeout. Please try again.");

      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request send timeout. Please try again.");

      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Server response timeout. Please try again.");

      case DioExceptionType.badCertificate:
        return ApiError(message: "Invalid security certificate.");
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final code = e.response?.statusCode;
        if(code == 302){
          return ApiError(
            message:e.response?.data,
            code: e.response?.statusCode,
          );
        }
          if (e.response != null) {
            final data = e.response!.data;

            if (data["errors"] != null) {
              final errors = data["errors"] as Map<String, dynamic>;
              final message = (errors.values.first as List).first.toString();

              return ApiError(message: message);
            }

            return ApiError(
              message: data["message"] ?? "Unknown error",
            );
          }




        if (data is Map<String, dynamic>) {
          return ApiError(
            message: data["message"] ??
                data["errors"]?.values.first.first ??
                "Server error",
            code: e.response?.statusCode,
          );
        }

        return ApiError(
          message: "Server error",
          code: e.response?.statusCode,
        );

      case DioExceptionType.cancel:
        return ApiError(message: "Request was cancelled.");

      case DioExceptionType.connectionError:
        return ApiError(message: "No internet connection.");

      case DioExceptionType.transformTimeout:
        return ApiError(message: "Data processing timeout.");

      case DioExceptionType.unknown:
        return ApiError(message: "Something went wrong. Please try again.");
      default:
        return ApiError(message: "Something went wrong. Please try again.");
    }
  }

}
