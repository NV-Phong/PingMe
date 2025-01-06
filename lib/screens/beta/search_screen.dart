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
      appBar: AppBar(
        title: const Text('SearchScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by username, email, or display name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _searchResults.isEmpty
                ? const Text('No results found.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to FriendProfile when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendProfile(user: user),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 5,
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
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
