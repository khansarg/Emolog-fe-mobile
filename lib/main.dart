import 'package:flutter/material.dart';
import 'features/login/login.dart';
import 'features/register/register.dart';
import 'features/settings/mainsettings.dart';
import 'features/welcome/welcome.dart';
import 'features/diary/diary.dart'; // Tambahkan import diary

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emolog',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(), // halaman pertama
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(),
        '/diary': (context) => const DiaryPage(), // <-- Tambahkan route diary di sini
      },
    );
  }
}
