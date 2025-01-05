import 'package:pingme/config/env_config.dart';
import 'package:pingme/config/interceptor_api.dart';

class ApiService {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  ApiService();

  Future<String> getHello() async {
    try {
      final response = await _interceptorAPI.dio.get('${EnvConfig.serverURL}/');

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
