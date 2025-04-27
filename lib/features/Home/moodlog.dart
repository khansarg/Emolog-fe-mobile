import 'package:flutter/material.dart';
import 'moodmate.dart';
import '/Button/BottomNavigationBar.dart'; // Importing MoodMateScreen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const MoodLogScreen(),
    );
  }
}

class MoodLogScreen extends StatefulWidget {
  const MoodLogScreen({super.key});

  @override
  _MoodLogScreenState createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  int _currentIndex = 0;
  bool isMoodMateActive = false;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map<String, dynamic>> moodData = const [
    {'day': 'Senin', 'moods': ['😭', '😐', '😂'], 'highlight': 2},
    {'day': 'Selasa', 'moods': ['😭', '😐', '😂'], 'highlight': 1},
    {'day': 'Rabu', 'moods': ['😭', '😐', '😂'], 'highlight': 2},
    {'day': 'Kamis', 'moods': ['😭', '😐', '😂'], 'highlight': 1},
    {'day': 'Jumat', 'moods': ['😭', '😐', '😂'], 'highlight': 0},
    {'day': 'Sabtu', 'moods': ['😭', '😐', '😂'], 'highlight': 1},
    {'day': 'Minggu', 'moods': ['😭', '😐', '😂'], 'highlight': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 30), // Biar ga ada putih atas
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
                const Text(
                  "Hey, Khansa 👍",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Review Your Mood History",
                  style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A), fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color(0xFFE4A9B8), width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isMoodMateActive = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isMoodMateActive
                                  ? Colors.transparent
                                  : const Color(0xFFD48DA2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Mood log',
                                style: TextStyle(
                                  color: isMoodMateActive
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MoodMateScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isMoodMateActive
                                  ? const Color(0xFFD48DA2)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Mood Mate',
                                style: TextStyle(
                                  color: isMoodMateActive
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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

          // Mood Data List
          Expanded(
            child: ListView.builder(
              itemCount: moodData.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final item = moodData[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          item['day'],
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFF7A7A7A)),
                        ),
                      ),
                      ...item['moods'].asMap().entries.map((entry) {
                        final moodIndex = entry.key;
                        final mood = entry.value;
                        final isHighlight = moodIndex == item['highlight'];
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isHighlight
                                  ? const Color(0xFFF7D8DE)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              mood,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
