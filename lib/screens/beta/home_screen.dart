import 'package:flutter/material.dart';
import 'package:pingme/services/dto/list_chat_dto.dart';
import 'package:pingme/services/get_list_chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ListChatDTO>> _listChats;

  @override
  void initState() {
    super.initState();
    _listChats =
        GetListChatAPI().getListChat(); // Gọi API để lấy danh sách chat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: FutureBuilder<List<ListChatDTO>>(
        future: _listChats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Đang tải
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Có lỗi
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No chats available')); // Không có dữ liệu
          } else {
            final listChats = snapshot.data!;

            return ListView.builder(
              itemCount: listChats.length,
              itemBuilder: (context, index) {
                final chat = listChats[index];
                return ListTile(
                  leading: chat.avatar != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(chat.avatar!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.chat),
                        ),
                  title: Text(chat.chatName), // Hiển thị tên chat
                  subtitle: Text('ID: ${chat.id}'), // Hiển thị ID của chat
                );
              },
            );
          }
        },
      ),
    );
  }
}
