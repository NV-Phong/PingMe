import 'package:pingme/config/env_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(EnvConfig.serverURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  void sendMessage(String message) {
    socket.emit('message', message);
  }

  void joinRoom(String room) {
    socket.emit('joinRoom', room);
  }

  void leaveRoom(String room) {
    socket.emit('leaveRoom', room);
  }

  void onMessage(void Function(String) callback) {
    socket.on('message', (data) => callback(data));
  }

  void disconnect() {
    socket.disconnect();
  }
}
