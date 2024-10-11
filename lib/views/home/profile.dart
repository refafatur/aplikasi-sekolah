import 'package:flutter/material.dart';
import 'ubah_profile.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(
                    userName: userName,
                    email: '', // Ganti dengan data yang sesuai
                    phone: '', // Isi dengan data yang sesuai
                    twitter: '', // Isi dengan data yang sesuai
                    behance: '', // Isi dengan data yang sesuai
                    facebook: '', // Isi dengan data yang sesuai
                  ),
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_picture.jpg'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.blueAccent),
              title: Text('james012@gmail.com'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.blueAccent),
              title: Text('1234567891'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.alternate_email, color: Colors.blueAccent),
              title: Text('@james012'),
              subtitle: Text('Twitter'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.link, color: Colors.blueAccent),
              title: Text('www.behance.net/james012'),
              subtitle: Text('Behance'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.facebook, color: Colors.blueAccent),
              title: Text('www.facebook.com/james012'),
              subtitle: Text('Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
