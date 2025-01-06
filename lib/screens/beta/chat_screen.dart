import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String displayName;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.displayName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, String>> chatHistory = [];
  TextEditingController messageController = TextEditingController();
  late TextEditingController roomController;
  ScrollController scrollController = ScrollController();
  String? clientId;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    roomController = TextEditingController(text: widget.userId);
    initSocket();
    joinRoom();
  }

  void initSocket() {
    socket = IO.io('http://192.168.22.210:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected to server');
      clientId = socket.id;
      print('Your client ID: $clientId');
    });

    socket.on('receive-message', (data) {
      if (mounted) {
        setState(() {
          if (data != null && data is Map<String, dynamic>) {
            chatHistory.add({
              'senderId': data['senderId'] ?? '',
              'message': data['content'] ?? '',
              'createdAt': data['createdAt'] ?? 'Unknown',
            });
            // Cuộn xuống cuối
            scrollToBottom();
          }
        });
      }
    });

    socket.on('chat-history', (data) {
      if (mounted) {
        setState(() {
          isLoading = false;
          if (data != null && data is List) {
            chatHistory = List<Map<String, String>>.from(data.map((message) {
              if (message is Map<String, dynamic>) {
                return {
                  'message': message['Message']?.toString() ?? '',
                  'senderId': message['IDSender']?.toString() ?? '',
                  'createdAt': message['CreateAt'] != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(
                          DateTime.parse(message['CreateAt'].toString()))
                      : 'Unknown',
                };
              } else {
                return {'message': '', 'senderId': '', 'createdAt': 'Unknown'};
              }
            }));
          } else {
            errorMessage = 'No chat history found for this room.';
          }
        });
      }
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  void joinRoom() {
    String room = roomController.text.trim();
    if (room.isNotEmpty) {
      socket.emit('join-room', {'room': room});
      loadChatHistory();
    }
  }

  void sendMessage() {
    String text = messageController.text.trim();
    String room = roomController.text.trim();

    if (text.isNotEmpty && room.isNotEmpty) {
      socket.emit('send-message', {
        'room': room,
        'senderId': clientId,
        'content': text,
        'chatType': 'GROUP',
        'IDReceiver': widget.userId,
      });
      setState(() {
        chatHistory.add({
          'senderId': clientId!,
          'message': text,
          'createdAt': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        });
        messageController.clear();
      });
      // Cuộn xuống cuối
      scrollToBottom();
    }
  }

  void loadChatHistory() {
    String room = roomController.text.trim();
    if (room.isNotEmpty) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      socket.emit('get-messages', room);
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.displayName),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = chatHistory[index];
                  bool isSentByMe = chat['senderId'] == clientId;
                  return Align(
                    alignment: isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSentByMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chat['message'] ?? ''),
                          const SizedBox(height: 5),
                          Text(
                            'Sent at: ${chat['createdAt']}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        sendMessage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    messageController.dispose();
    roomController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
