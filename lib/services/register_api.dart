import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pingme/config/env_config.dart';
import 'package:pingme/services/dto/register_dto.dart';

class RegisterAPI {
  final Dio _dio = Dio();

  Future<void> registerUser(
      BuildContext context, RegisterDTO registerDTO) async {
    try {
      final response = await _dio.post('${EnvConfig.serverURL}/auth/register',
          data: registerDTO.toJson());
      if (response.statusCode == 201 && context.mounted) {
        Fluttertoast.showToast(msg: 'Đăng ký thành công');
        Navigator.pushNamed(context, '/auth/login');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Đã xảy ra lỗi';
      if (context.mounted) Fluttertoast.showToast(msg: message);
    }
  }
}
