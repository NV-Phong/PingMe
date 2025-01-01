import 'package:flutter/material.dart';
import 'package:pingme/layout/layout.dart';
import 'package:pingme/screens/beta/login_screen.dart';
import 'package:pingme/screens/env_screen.dart';
import 'package:pingme/screens/splash_screen.dart';
import 'package:pingme/screens/test_api_screen.dart';

class HomeRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),
    '/auth/login': (context) => const LoginScreen(),
    '/testAPI': (context) => const Layout(body: TestAPIScreen()),
    '/enviroment-variable': (context) =>
        const Layout(body: EnviromentVariable()),
  };
}
