import 'package:flutter/material.dart';
import 'package:pingme/layout/navigationbar.dart';

class Layout extends StatelessWidget {
  final Widget body;

  const Layout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Engineer'),
      ),
      body: body, // Nội dung của mỗi trang
      bottomNavigationBar: const Navigation(),
    );
  }
}
