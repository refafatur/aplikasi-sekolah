import 'package:flutter/material.dart';
import '../views/auth/login_page.dart';
import '../views/home/welcome_page.dart';
import '../views/auth/register_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String welcome = '/welcome';
  static const String register = '/register';
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    welcome: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final userName = args?['userName'] as String? ?? '';
      return WelcomeScreen(userName: userName);
    },
    register: (context) => const RegisterScreen(),
  };
}
