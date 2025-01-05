import 'package:flutter/material.dart';
import 'package:pingme/services/search_user_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];

  // Tạo instance của UserService
  final SearchUserAPI _userService = SearchUserAPI();

  // Phương thức tìm kiếm người dùng
  void _searchUsers() async {
    String keyword = _searchController.text.trim();
    if (keyword.isNotEmpty) {
      try {
        // Gọi phương thức tìm kiếm và cập nhật kết quả
        List<Map<String, String>> users =
            await _userService.searchUsersByKeyword(keyword);
        setState(() {
          _searchResults = users;
        });
      } catch (e) {
        // Xử lý lỗi nếu có
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField để người dùng nhập từ khóa tìm kiếm
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by username, email, or display name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed:
                      _searchUsers, // Gọi hàm tìm kiếm khi nhấn vào nút tìm kiếm
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Hiển thị kết quả tìm kiếm
            _searchResults.isEmpty
                ? const Text('No results found.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return ListTile(
                          title: Text(user['displayName'] ?? 'No Name'),
                          subtitle: Text(user['email'] ?? 'No Email'),
                          trailing: Text(user['username'] ?? 'No Username'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
