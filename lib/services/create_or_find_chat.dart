import 'package:pingme/config/interceptor_api.dart';
import 'package:pingme/services/dto/chat_dto.dart';

class CreateOrFindChat {
  final InterceptorAPI _interceptorAPI = InterceptorAPI();

  Future<ChatDTO> createOrFindChat(String idReceived) async {
    try {
      final response =
          await _interceptorAPI.dio.post('/chat/personal/$idReceived');

      if (response.statusCode == 201) {
        final chatData = response.data;

        if (chatData == null || chatData.isEmpty) {
          throw Exception('No chat found or created');
        }

        // Chuyển đổi JSON thành đối tượng ChatDTO
        return ChatDTO.fromJson(chatData);
      } else {
        throw Exception(
            'Failed to fetch or create chat. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch or create chat');
    }
  }
}
