import 'package:dio/dio.dart';

import '../utils/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      baseUrl: "http://10.0.2.2:8000/api",
      headers: {"Content-Type": "application/json",
        'Accept': 'image/jpeg,image/png,image/webp,image/*',
        'Connection': 'keep-alive',
        'Cache-Control': 'no-cache',


      },
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await PrefHelper.getToken();

            if (token != null && token.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $token";


            }

            print("========== REQUEST ==========");
            print("${options.method} ${options.uri}");
            print("Headers: ${options.headers}");
            print("Body: ${options.data}");
            print("=============================");

            return handler.next(options);
          } catch (e) {
            return handler.reject(
              DioException(requestOptions: options, error: e),
            );
          }
        },
        onResponse: (response, handler) {
          print("========== RESPONSE =========");
          print("Status: ${response.statusCode}");
          print("Data: ${response.data}");
          print("=============================");

          handler.next(response);
        },
        onError: (e, handler) {
          print("=========== ERROR ===========");
          print("URL: ${e.requestOptions.uri}");
          print("Status: ${e.response?.statusCode}");
          print("Response: ${e.response?.data}");
          print("=============================");

          handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
