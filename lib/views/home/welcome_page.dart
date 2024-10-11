import 'package:flutter/material.dart';
import 'home.dart';
import 'info.dart';
import 'agenda.dart';
import 'galery.dart';
import 'galeri.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(userName: widget.userName),
      const InfoScreen(),
      const AgendaScreen(),
      const GaleryScreen(),
      const GaleriScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            buildNavItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: _selectedIndex == 0,
              index: 0,
            ),
            // Search Button
            buildNavItem(
              icon: Icons.info,
              label: 'Info',
              isSelected: _selectedIndex == 1,
              index: 1,
            ),
            // Offers Button
            buildNavItem(
              icon: Icons.calendar_month,
              label: 'Agenda',
              isSelected: _selectedIndex == 2,
              index: 2,
            ),
            // Cart Button
            buildNavItem(
              icon: Icons.photo_library,
              label: 'Galery',
              isSelected: _selectedIndex == 3,
              index: 3,
            ),
                        buildNavItem(
              icon: Icons.photo_library,
              label: 'Galeri',
              isSelected: _selectedIndex == 4,
              index: 4,
            ),
            // Profile Button
            // buildNavItem(
            //   icon: Icons.person,
            //   label: 'Profile',
            //   isSelected: _selectedIndex == 4,
            //   index: 4,
            // ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each navigation item
  Widget buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.blue : Colors.white,
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
