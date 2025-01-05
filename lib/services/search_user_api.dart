import 'package:pingme/config/interceptor_api.dart';
import 'package:pingme/services/dto/user_info_dto.dart';

class SearchUserAPI {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  Future<List<UserInfoDTO>> searchUsersByKeyword(String keyword) async {
    try {
      final response = await _interceptorAPI.dio.get('/user/$keyword');

      if (response.statusCode == 200) {
        List<dynamic> users = response.data;
        if (users.isEmpty) {
          return []; // Không tìm thấy người dùng
        }

        // Sử dụng UserInfoDTO để chuyển đổi dữ liệu trả về
        return users.map((user) => UserInfoDTO.fromJson(user)).toList();
      } else {
        throw Exception('Error fetching users');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to search users');
    }
  }
}
