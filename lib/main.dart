import 'package:emolog/features/welcome/welcome.dart';
import 'package:flutter/material.dart';
import './features/login/login.dart';
import './features/settings/mainsettings.dart';

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
        '/': (context) => const WelcomePage(),// halaman pertama
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(), // halaman setelah login
      },
    );
  }
}
