import 'package:flutter/material.dart';
import 'package:pingme/services/dto/user_info_dto.dart';
import 'package:pingme/services/search_user_api.dart';
import 'package:pingme/screens/beta/friend_profile.dart'; // Import FriendProfile

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserInfoDTO> _searchResults = [];

  final SearchUserAPI _userService = SearchUserAPI();

  void _searchUsers() async {
    String keyword = _searchController.text.trim();
    if (keyword.isNotEmpty) {
      try {
        List<UserInfoDTO> users =
            await _userService.searchUsersByKeyword(keyword);
        setState(() {
          _searchResults = users;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("People"),
      ),
      body: Column(
        children: [
          // Appbar search
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.fromLTRB(
              16.0,
              0,
              16.0,
              16.0,
            ),
            color: const Color(0xFF00BF6D),
            child: Form(
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  // search
                },
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  hintText: "Search by username, email, or display name",
                  hintStyle: TextStyle(
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0 * 1.5, vertical: 16.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchUsers,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Các kết quả tìm kiếm
                  _searchResults.isEmpty
                      ? const Text('No results found.')
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),
                              ..._searchResults.map((user) {
                                return GestureDetector(
                                  onTap: () {
                                    // Điều hướng đến FriendProfile khi người dùng nhấn vào
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FriendProfile(user: user),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    color: Colors.white, // Màu nền trắng
                                    elevation: 0, // Xóa đổ bóng
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(10),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          user.avatar ??
                                              'https://i.pinimg.com/736x/e8/81/da/e881da0a63716cbc6cacfd6635dd157f.jpg',
                                        ),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      title: Text(user.displayName),
                                      subtitle: Text(user.email),
                                      trailing: Text(user.username),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
