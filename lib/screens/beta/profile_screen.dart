import 'package:flutter/material.dart';
import 'package:pingme/services/dto/user_info_dto.dart';
import 'package:pingme/services/get_user_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetUserInfoAPI _userInfoAPI = GetUserInfoAPI();
  UserInfoDTO? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserInfoDTO user = await _userInfoAPI.searchUserById();
      setState(() {
        _user = user;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor:
            Colors.purple, // Adjust background color to match Instagram
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _user == null
                  ? const Center(child: Text('No user found'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  _user!.cover ??
                                      'https://i.pinimg.com/736x/11/53/d3/1153d39b62e596ed21da0cd4c03110a2.jpg', // Avatar image, or a default image if null
                                ), // Show cover image
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CircleAvatar(
                            radius: 50, // Size of avatar
                            backgroundImage: NetworkImage(
                              _user!.avatar ??
                                  'https://i.pinimg.com/736x/e8/81/da/e881da0a63716cbc6cacfd6635dd157f.jpg', // Avatar image, or a default image if null
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _user!.displayName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _user!.username,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: ${_user!.email}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text('ID: ${_user!.id}',
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Edit Profile functionality goes here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
