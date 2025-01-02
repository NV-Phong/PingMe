import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pingme/services/dto/login_dto.dart';
import 'package:pingme/services/login_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final LoginAPI _loginAPI = LoginAPI();

  Future<void> _login() async {
    final fields = {
      'Username': _controllers[0].text,
      'Password': _controllers[1].text,
    };

    if (fields.values.any((field) => field.isEmpty)) {
      Fluttertoast.showToast(msg: 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    await _loginAPI.loginUser(
      context,
      LoginDTO(
        username: fields['Username']!,
        password: fields['Password']!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['Username', 'Password'];

    return Scaffold(
      appBar: AppBar(title: const Text('LoginScreen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              2,
              (index) => TextField(
                controller: _controllers[index],
                decoration: InputDecoration(labelText: labels[index]),
                obscureText: labels[index] == 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
