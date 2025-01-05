import 'package:flutter/material.dart';
import 'package:pingme/config/token_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TokenStorage _tokenStorage = TokenStorage();

  // Phương thức để xử lý việc đăng xuất
  Future<void> _logout(BuildContext context) async {
    // Xóa tất cả các token
    await _tokenStorage.clearTokens();
    // Chuyển hướng đến trang đăng nhập
    Navigator.pushReplacementNamed(context, '/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the SettingsScreen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
