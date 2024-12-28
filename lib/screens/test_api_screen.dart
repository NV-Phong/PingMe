import 'package:flutter/material.dart';
import 'package:pingme/services/test_api.dart';

class TestAPIScreen extends StatefulWidget {
  const TestAPIScreen({super.key});

  @override
  State<TestAPIScreen> createState() => _TestAPIScreenState();
}

class _TestAPIScreenState extends State<TestAPIScreen> {
  String _response = 'Đang tải dữ liệu...';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String result = await ApiService().getHello();
    setState(() {
      _response = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestAPIScreen'),
      ),
      body: Center(
        child: _response == 'Đang tải dữ liệu...'
            ? CircularProgressIndicator()
            : Text(_response),
      ),
    );
  }
}
