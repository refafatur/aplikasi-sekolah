import 'package:flutter/material.dart';
import 'routes/app_routes.dart'; // Import file routes yang baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login, // Halaman pertama yang akan dibuka (login)
      routes: AppRoutes.routes, // Menggunakan routes yang ada di app_routes.dart
    );
  }
}
