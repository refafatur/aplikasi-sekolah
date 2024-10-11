import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    const String apiUrl =
        'https://hayy.my.id/API-Refa/login.php'; // URL API login

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          String userName = data['nama'] ?? _usernameController.text;
          _showNotification(true, 'Login berhasil');
          await Future.delayed(const Duration(
              seconds: 2)); // Menunggu 2 detik sebelum berpindah halaman
          Navigator.pushReplacementNamed(
            context,
            '/welcome',
            arguments: {'userName': userName},
          );
        } else {
          _showNotification(false, 'Login gagal. ${data['message']}');
        }
      } else {
        _showNotification(false, 'Terjadi kesalahan. Silakan coba lagi.');
      }
    } catch (e) {
      _showNotification(false,
          'Terjadi kesalahan jaringan. Mohon periksa koneksi internet Anda dan coba lagi.');
    }
  }

  void _showNotification(bool isSuccess, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                color: isSuccess ? Colors.green : Colors.red,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
    );

    // Menutup dialog setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.lightBlue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://tse3.mm.bing.net/th?id=OIP.qfeNFpPMMgAzbCrnyRt1BQHaE8&pid=Api&P=0&h=180'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Masuk ke Akun Anda',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Silakan login menggunakan akun yang telah terdaftar',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Belum punya akun?',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.register);
                  },
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.yellowAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
