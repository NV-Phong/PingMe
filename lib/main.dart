import 'package:flutter/material.dart';
import 'package:pingme/routes/home_route.dart';

Future<void> main() async {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PingMe',
      initialRoute: '/',
      routes: {
        ...HomeRoutes.routes,
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Route không tồn tại!')),
        ),
      ),
    );
  }
}
