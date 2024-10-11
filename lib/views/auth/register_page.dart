import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    const String apiUrl = 'https://hayy.my.id/API-Refa/register.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'nama': _nameController.text,
          'email': _emailController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          _showNotification(true, 'Pendaftaran berhasil!');
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacementNamed(context, '/');
        } else {
          _showNotification(false, 'Pendaftaran gagal: ${data['message']}');
        }
      } else {
        _showNotification(false, 'Terjadi kesalahan. Silakan coba lagi.');
      }
    } catch (e) {
      _showNotification(false, 'Terjadi kesalahan jaringan. Mohon periksa koneksi internet Anda dan coba lagi.');
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

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                  const SizedBox(height: 20),
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Silakan isi data di bawah untuk mendaftar',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nama Lengkap',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline),
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
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Sudah punya akun?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      'Login di sini',
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
      ),
    );
  }
}