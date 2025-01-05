import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  // Kiểm tra sự tồn tại của token và chuyển hướng
  Future<void> _checkToken() async {
    String? accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      // Nếu có access token, chuyển hướng đến trang home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Nếu không có token, chuyển hướng đến trang login
      Navigator.pushReplacementNamed(context, '/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the SplashScreen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth/login');
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the new screen!'),
      ),
    );
  }
}
