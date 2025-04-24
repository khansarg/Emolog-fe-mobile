import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // Untuk menentukan tab yang aktif
  final Function(int) onTap; // Untuk menangani perubahan tab

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Menandakan tab yang sedang aktif
      onTap: onTap, // Fungsi untuk menangani perubahan tab
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Color(0xFFA07677)),
          label: '',
        ),
      ],
    );
  }
}
