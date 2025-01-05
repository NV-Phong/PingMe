import 'package:pingme/config/interceptor_api.dart';

class SearchUserAPI {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  Future<List<Map<String, String>>> searchUsersByKeyword(String keyword) async {
    try {
      final response = await _interceptorAPI.dio.get('/user/$keyword');

      if (response.statusCode == 200) {
        // Kiểm tra nếu có dữ liệu
        List<dynamic> users = response.data;
        if (users.isEmpty) {
          return []; // Nếu không tìm thấy người dùng
        }

        // Chuyển đổi dữ liệu trả về thành dạng danh sách các Map
        return users.map((user) {
          return {
            'displayName':
                user['displayName'] as String, // Ép kiểu thành String
            'email': user['email'] as String, // Ép kiểu thành String
            'username': user['username'] as String, // Ép kiểu thành String
            '_id': user['_id'] as String, // Ép kiểu thành String
          };
        }).toList();
      } else {
        throw Exception('Error fetching users');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
      throw Exception('Failed to search users');
    }
  }
}
