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
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index); // Update index di parent (statefull widget)

        // Navigasi sesuai tab
        if (index == 0) {
          Navigator.pushNamed(context, '/'); // Home (sementara ke WelcomePage)
        } else if (index == 1) {
          Navigator.pushNamed(context, '/diary'); // DiaryPage
        } else if (index == 2) {
          Navigator.pushNamed(context, '/settings'); // SettingsPage
        }
      },
      selectedItemColor: Color(0xFFD98B8B),  // Warna ketika icon dipilih
      unselectedItemColor: Colors.grey,      // Warna ketika icon tidak dipilih
      showSelectedLabels: false,             // Tidak menampilkan label
      showUnselectedLabels: false,           // Tidak menampilkan label
      elevation: 8,                          // Memberikan bayangan
      type: BottomNavigationBarType.fixed,   // Tipe fixed agar tidak berubah ukuran
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home, color: Color(0xFFD98B8B)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          activeIcon: Icon(Icons.book, color: Color(0xFFD98B8B)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          activeIcon: Icon(Icons.settings, color: Color(0xFFD98B8B)),
          label: '',
        ),
      ],
    );
  }
}