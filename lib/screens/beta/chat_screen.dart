import 'package:flutter/material.dart';
import 'package:pingme/services/create_or_find_chat.dart';
import 'package:pingme/services/dto/chat_dto.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String displayName;
  final ChatDTO chat; // Thêm trường chat để lưu List<ChatDTO>

  const ChatScreen({
    super.key,
    required this.userId,
    required this.displayName,
    required this.chat,
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
  final CreateOrFindChat chatService = CreateOrFindChat();

  @override
  void initState() {
    super.initState();
    roomController = TextEditingController(text: widget.userId);
    initSocket();
    joinRoom();
  }

  void initSocket() {
    socket = IO.io('http://192.168.1.11:3000', <String, dynamic>{
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
              'IDReceiver': data['IDReceiver'] ?? '',
              'message': data['content'] ?? '',
              'createdAt': data['createdAt'] ?? 'Unknown',
            });
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
                bool isCurrentUser = message['IDReceiver'] == widget.userId;
                return {
                  'message': message['Message']?.toString() ?? '',
                  'senderId': message['IDSender']?.toString() ?? '',
                  'IDReceiver': message['IDReceiver']?.toString() ?? '',
                  'createdAt': message['CreateAt'] != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(
                          DateTime.parse(message['CreateAt'].toString()))
                      : 'Unknown',
                  'isCurrentUser': isCurrentUser
                      ? 'true'
                      : 'false', // Đánh dấu tin nhắn của người nhận
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

  Future<void> joinRoom() async {
    // var chat = await chatService.createOrFindChat(widget.userId);
    String room = widget.chat.id.toString();
    print("mã của chat: " + room);
    if (room.isNotEmpty) {
      socket.emit('join-room', {'room': room});
      loadChatHistory();
    }
  }

  void sendMessage() {
    String text = messageController.text.trim();

    String room = widget.chat.id.toString();

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
          'IDReceiver': widget.userId,
          'message': text,
          'createdAt': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        });
        messageController.clear();
      });
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final chat = chatHistory[index];
                bool isCurrentUser = chat['IDReceiver'] ==
                    widget
                        .userId; // Kiểm tra xem tin nhắn của người nhận hiện tại hay không
                return _buildMessageBubble(
                  chat['message'] ?? '',
                  chat['createdAt'] ?? '',
                  isCurrentUser, // Cập nhật lại logic căn lề
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      String message, String timestamp, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCurrentUser ? 'Other' : 'You',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isCurrentUser ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(timestamp)),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Enter message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                sendMessage();
                messageController.clear();
              }
            },
            child: const Icon(Icons.send),
            mini: true,
            backgroundColor: Colors.purple,
          ),
        ],
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
