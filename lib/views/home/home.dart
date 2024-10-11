import 'package:flutter/material.dart';
import 'profile.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  
  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: const Text('email@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 40.0, color: Colors.blue),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Inventaris'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan navigasi ke halaman Inventaris di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: const Text('Cari Mekanik'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan navigasi ke halaman Cari Mekanik di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Permintaan'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan navigasi ke halaman Permintaan di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analitik'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan navigasi ke halaman Analitik di sini
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan navigasi ke halaman Pengaturan di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Bantuan & Umpan Balik'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan navigasi ke halaman Bantuan & Umpan Balik di sini
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Keluar'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text('Apakah Anda ingin keluar dari akun ini?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Tidak'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Ya'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.indigoAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Icon(Icons.person, size: 30, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Selamat datang, $userName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Last Update 25 Feb 2024',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dashboard Grid
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      DashboardItem(
                        icon: Icons.account_circle,
                        label: 'My Account',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(userName: userName),
                            ),
                          );
                        },
                      ),
                      DashboardItem(
                        icon: Icons.inventory_2,
                        label: 'Inventory',
                        color: Colors.orange,
                        onTap: () {
                          // Tambahkan navigasi ke halaman Inventory di sini
                        },
                      ),
                      DashboardItem(
                        icon: Icons.engineering,
                        label: 'Search Mechanic',
                        color: Colors.green,
                        onTap: () {
                          // Tambahkan navigasi ke halaman Search Mechanic di sini
                        },
                      ),
                      DashboardItem(
                        icon: Icons.request_page,
                        label: 'Request',
                        color: Colors.purple,
                        onTap: () {
                          // Tambahkan navigasi ke halaman Request di sini
                        },
                      ),
                      DashboardItem(
                        icon: Icons.analytics,
                        label: 'Analytics',
                        color: Colors.pink,
                        onTap: () {
                          // Tambahkan navigasi ke halaman Analytics di sini
                        },
                      ),
                      DashboardItem(
                        icon: Icons.contact_mail,
                        label: 'Contact Us',
                        color: Colors.teal,
                        onTap: () {
                          // Tambahkan navigasi ke halaman Contact Us di sini
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable widget for dashboard items
class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DashboardItem({
    super.key, 
    required this.icon, 
    required this.label, 
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
