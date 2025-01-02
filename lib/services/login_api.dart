import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pingme/config/env_config.dart';
import 'package:pingme/config/token_storage.dart';
import 'package:pingme/services/dto/login_dto.dart';

class LoginAPI {
  final Dio _dio = Dio();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> loginUser(BuildContext context, LoginDTO loginDTO) async {
    try {
      final response = await _dio.post('${EnvConfig.serverURL}/auth/login',
          data: loginDTO.toJson());
      if (response.statusCode == 201 && context.mounted) {
        _tokenStorage.saveAccessToken(response.data['access_token']);
        _tokenStorage.saveRefreshToken(response.data['refresh_token']);
        Fluttertoast.showToast(msg: 'Đăng nhập thành công');
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Đã xảy ra lỗi';
      if (context.mounted) Fluttertoast.showToast(msg: message);
    }
  }
}
