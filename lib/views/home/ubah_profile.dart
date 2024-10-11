import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEditScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String phone;
  final String twitter;
  final String behance;
  final String facebook;

  const ProfileEditScreen({
    super.key,
    required this.userName,
    required this.email,
    required this.phone,
    required this.twitter,
    required this.behance,
    required this.facebook,
  });

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _twitterController;
  late TextEditingController _behanceController;
  late TextEditingController _facebookController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _twitterController = TextEditingController(text: widget.twitter);
    _behanceController = TextEditingController(text: widget.behance);
    _facebookController = TextEditingController(text: widget.facebook);
  }

  Future<void> _updateProfile() async {
    const String apiUrl = 'https://example.com/update_profile.php'; // Ganti URL API dengan yang sesuai

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': _userNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'twitter': _twitterController.text,
          'behance': _behanceController.text,
          'facebook': _facebookController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _showDialog(true, 'Profil berhasil diperbarui.');
        } else {
          _showDialog(false, 'Gagal memperbarui profil: ${data['message']}');
        }
      } else {
        _showDialog(false, 'Terjadi kesalahan. Silakan coba lagi.');
      }
    } catch (e) {
      _showDialog(false, 'Terjadi kesalahan jaringan. Mohon periksa koneksi internet Anda.');
    }
  }

  void _showDialog(bool isSuccess, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(isSuccess ? 'Berhasil' : 'Gagal'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Nama Pengguna',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _twitterController,
              decoration: InputDecoration(
                labelText: 'Twitter',
                prefixIcon: const Icon(Icons.alternate_email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _behanceController,
              decoration: InputDecoration(
                labelText: 'Behance',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _facebookController,
              decoration: InputDecoration(
                labelText: 'Facebook',
                prefixIcon: const Icon(Icons.facebook),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
