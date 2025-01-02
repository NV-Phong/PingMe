import 'package:flutter/material.dart';
import 'package:pingme/config/token_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String accessToken = '';
  String refreshToken = '';

  @override
  void initState() {
    super.initState();
    _loadTokens();
  }

  // Hàm lấy và hiển thị token
  Future<void> _loadTokens() async {
    final tokenStorage = TokenStorage();
    final loadedAccessToken = await tokenStorage.getAccessToken();
    final loadedRefreshToken = await tokenStorage.getRefreshToken();

    setState(() {
      accessToken = loadedAccessToken ?? 'No Access Token Found';
      refreshToken = loadedRefreshToken ?? 'No Refresh Token Found';
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Access Token: $accessToken'),
            const SizedBox(height: 10),
            Text('Refresh Token: $refreshToken'),
          ],
        ),
      ),
    );
  }
}
