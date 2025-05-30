import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/Button/BottomNavigationBar.dart';
import 'moodlog.dart';

class MoodMateScreen extends StatefulWidget {
  const MoodMateScreen({super.key});

  @override
  _MoodMateScreenState createState() => _MoodMateScreenState();
}

class _MoodMateScreenState extends State<MoodMateScreen> {
  int _currentIndex = 0;
  bool isMoodMateActive = true;
  String todayMood = '';
  String username = '';

  final Map<String, String> moodQuotes = {
    'Happy': 'CIE HARI INI HAPPY, CAPTURE THIS MOMENT KARENA MOMEN BAHAGIA SEPERTI INI HARUS DIABADIKAN!',
    'Sad': 'Sedih itu hal yang wajar kok! tapi jangan sampai berlarut dalam kesedihan yaa, semuanya pasti berlalu kok!',
    'Neutral': 'Hari ini biasa aja ya? gapapa, jadiin hari ini waktu untuk kamu istirahat ya!',
  };

  final Map<String, String> moodEmojis = {
    'Sad': '😭',
    'Neutral': '😐',
    'Happy': '😂',
  };

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToMoodLog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MoodLogScreen()),
    );
  }
  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username') ?? '';
    setState(() {
      username = storedUsername;
    });
  }
  Future<void> fetchTodayMood() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/moods/today'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        todayMood = data['mood'] ?? '';
      });
    } else {
      print('Failed to load mood: ${response.statusCode}');
    }
  }


  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    super.initState();
    fetchTodayMood();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFF7D8DE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hey, ${username.isNotEmpty ? username : 'User'} 👍",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This is your today's mood",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7A7A7A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xFFE4A9B8), width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: navigateToMoodLog,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMoodMateActive ? Colors.transparent : const Color(0xFFD48DA2),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Mood log",
                                style: TextStyle(
                                  color: isMoodMateActive ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMoodMateActive = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMoodMateActive ? const Color(0xFFD48DA2) : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Mood Mate",
                                style: TextStyle(
                                  color: isMoodMateActive ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Today's Mood:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: moodEmojis.entries.map((entry) {
                        final isSelected = entry.key == todayMood;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF7D8DE) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Quote of the Day:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        moodQuotes[todayMood] ??
                            'Belum ada mood hari ini. Yuk ekspresikan perasaanmu!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}