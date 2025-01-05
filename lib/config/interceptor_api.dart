import 'package:dio/dio.dart';
import 'package:pingme/config/env_config.dart';
import 'token_storage.dart';

class InterceptorAPI {
  late Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage();

  InterceptorAPI() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.serverURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Thêm Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Lấy access token từ TokenStorage
          String? token = await _tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Tiếp tục request
        },
        onResponse: (response, handler) {
          // Xử lý response nếu cần
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          // Xử lý lỗi, ví dụ: refresh token khi gặp lỗi 401
          if (error.response?.statusCode == 401) {
            // Lấy refresh token từ TokenStorage
            String? refreshToken = await _tokenStorage.getRefreshToken();

            if (refreshToken != null) {
              try {
                // Gửi request làm mới token
                final refreshResponse = await _dio.post(
                  '/auth/refresh', // Endpoint để refresh token
                  data: {'refresh_token': refreshToken},
                );

                // Lưu token mới
                String newAccessToken = refreshResponse.data['access_token'];
                await _tokenStorage.saveAccessToken(newAccessToken);

                // Gửi lại request ban đầu với token mới
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final retryResponse = await _dio.request(
                  error.requestOptions.path,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                  data: error.requestOptions.data,
                );

                return handler.resolve(retryResponse);
              } catch (refreshError) {
                // Xử lý khi refresh token thất bại
                return handler.next(refreshError as DioException);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
