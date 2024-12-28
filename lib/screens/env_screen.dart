import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnviromentVariable extends StatefulWidget {
  const EnviromentVariable({super.key});

  @override
  State<EnviromentVariable> createState() => _EnviromentVariableState();
}

class _EnviromentVariableState extends State<EnviromentVariable> {
  @override
  Widget build(BuildContext context) {
    String server = dotenv.env['SERVER'] ?? 'Không tìm thấy server!';
    return Scaffold(
      appBar: AppBar(
        title: const Text('EnviromentVariable'),
      ),
      body: Center(
        child: Text('Server: $server'),
      ),
    );
  }
}
