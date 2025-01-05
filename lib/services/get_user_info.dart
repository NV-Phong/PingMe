import 'package:pingme/config/interceptor_api.dart';
import 'package:pingme/services/dto/user_info_dto.dart';

class GetUserInfoAPI {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  // API call để lấy thông tin người dùng theo ID
  Future<UserInfoDTO> searchUserById() async {
    try {
      final response = await _interceptorAPI.dio.get('/user/infuser/getById');

      if (response.statusCode == 200) {
        // Kiểm tra nếu dữ liệu trả về là Map
        if (response.data is Map<String, dynamic>) {
          // Chuyển đổi Map thành UserInfoDTO
          return UserInfoDTO.fromJson(response.data);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error fetching user');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch user');
    }
  }
}
