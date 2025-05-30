import 'package:emolog/features/Home/moodlog.dart';
import 'package:emolog/features/Home/moodmate.dart';
import 'package:flutter/material.dart';
import 'features/login/login.dart';
import 'features/register/register.dart';
import 'features/settings/mainsettings.dart';
import 'features/welcome/welcome.dart';
import 'features/diary/diary.dart'; // Tambahkan import diary
import 'package:intl/date_symbol_data_local.dart'; // Penting untuk tanggal lokal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null); // Inisialisasi locale Bahasa Indonesia
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
        '/diary': (context) => DiaryPage(), // Tidak pakai const karena DiaryPage Stateful
        '/homeML': (context) => const MoodLogScreen(),
        '/homeMM': (context) => const MoodMateScreen()
      },
    );
  }
}
