import 'package:pingme/config/interceptor_api.dart';
import 'package:pingme/services/dto/list_chat_dto.dart';

class GetListChatAPI {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  Future<List<ListChatDTO>> getListChat() async {
    try {
      final response = await _interceptorAPI.dio.get('/chat');

      if (response.statusCode == 200) {
        List<dynamic> users = response.data;
        if (users.isEmpty) {
          return []; // Không tìm thấy người dùng
        }

        // Sử dụng ListChatDTO để chuyển đổi dữ liệu trả về
        return users.map((user) => ListChatDTO.fromJson(user)).toList();
      } else {
        throw Exception('Error fetching users');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to search users');
    }
  }
}
