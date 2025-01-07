import 'package:pingme/config/interceptor_api.dart';
import 'package:pingme/services/dto/follow_stats.dart';

class FollowStats {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  // API call để lấy thông tin người dùng theo ID
  Future<FollowStatsDTO> followStats() async {
    try {
      final response = await _interceptorAPI.dio.get('/user/follow/stats');

      if (response.statusCode == 200) {
        // Kiểm tra nếu dữ liệu trả về là Map
        if (response.data is Map<String, dynamic>) {
          // Chuyển đổi Map thành FollowStatsDTO
          return FollowStatsDTO.fromJson(response.data);
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
