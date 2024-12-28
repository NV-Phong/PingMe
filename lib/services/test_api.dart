import 'package:dio/dio.dart';
import 'package:pingme/config/env_config.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService();

  Future<String> getHello() async {
    try {
      final response = await _dio.get('${EnvConfig.serverURL}/');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
