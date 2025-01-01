import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pingme/services/dto/register_dto.dart';
import 'package:pingme/services/register_api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final RegisterAPI _registerAPI = RegisterAPI();

  Future<void> _register() async {
    final fields = {
      'Username': _controllers[0].text,
      'Password': _controllers[1].text,
      'Email': _controllers[2].text,
      'Display Name': _controllers[3].text,
    };

    if (fields.values.any((field) => field.isEmpty)) {
      Fluttertoast.showToast(msg: 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    await _registerAPI.registerUser(
      context,
      RegisterDTO(
        username: fields['Username']!,
        password: fields['Password']!,
        email: fields['Email']!,
        displayName: fields['Display Name']!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['Username', 'Password', 'Email', 'Display Name'];

    return Scaffold(
      appBar: AppBar(title: const Text('RegisterScreen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              4,
              (index) => TextField(
                controller: _controllers[index],
                decoration: InputDecoration(labelText: labels[index]),
                obscureText: labels[index] == 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
