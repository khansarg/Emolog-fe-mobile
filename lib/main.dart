import 'package:flutter/material.dart';
import './features/settings/mainsettings.dart'; // Import halaman yang mau kamu run
import './features/settings/account.dart';
import './features/settings/changepassword.dart';

void main() {
  runApp(const MaterialApp(
    home: SettingsPage(),
  ));
}
