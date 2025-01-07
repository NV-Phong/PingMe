import 'package:pingme/config/interceptor_api.dart';
import 'package:pingme/services/dto/chat_dto.dart';

class CreateOrFindChat {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  Future<List<ChatDTO>> createOrFindChat(String IDRecived) async {
    try {
      final response =
          await _interceptorAPI.dio.post('/chat/personal/$IDRecived');

      if (response.statusCode == 200) {
        List<dynamic> chat = response.data;
        if (chat.isEmpty) {
          return []; // Không tìm thấy hoặc không tạo được đoạn chat
        }

        // Sử dụng UserInfoDTO để chuyển đổi dữ liệu trả về
        return chat.map((chat) => ChatDTO.fromJson(chat)).toList();
      } else {
        throw Exception('Error fetching users');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to search users');
    }
  }
}
