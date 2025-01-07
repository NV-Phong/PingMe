import 'package:flutter/material.dart';
import 'package:pingme/services/dto/user_info_dto.dart';
import 'package:pingme/services/get_user_info.dart';
import 'package:pingme/services/follow_stats.dart';
import 'package:pingme/services/dto/follow_stats.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetUserInfoAPI _userInfoAPI = GetUserInfoAPI();
  final FollowStats _followStatsAPI = FollowStats();
  UserInfoDTO? _user;
  FollowStatsDTO? _followStats;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserInfoDTO user = await _userInfoAPI.searchUserById();
      FollowStatsDTO followStats = await _followStatsAPI.followStats();
      setState(() {
        _user = user;
        _followStats = followStats;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
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
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _user == null || _followStats == null
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
                                      'https://i.pinimg.com/736x/11/53/d3/1153d39b62e596ed21da0cd4c03110a2.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              _user!.avatar ??
                                  'https://i.pinimg.com/736x/e8/81/da/e881da0a63716cbc6cacfd6635dd157f.jpg',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${_followStats!.numberOfFollowers}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Followers'),
                                ],
                              ),
                              const SizedBox(width: 32),
                              Column(
                                children: [
                                  Text(
                                    '${_followStats!.numberOfFollowing}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Following'),
                                ],
                              ),
                            ],
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
