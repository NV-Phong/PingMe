import 'package:pingme/config/env_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(EnvConfig.serverURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      print('Connected to WebSocket');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from WebSocket');
    });
  }

  void sendMessage(String sender, String receiver, String content) {
    socket.emit('sendMessage', {
      'sender': sender,
      'receiver': receiver,
      'content': content,
    });
  }
}
