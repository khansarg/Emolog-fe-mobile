import 'package:flutter/material.dart';
import 'moodmate.dart';  // Importing MoodMateScreen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Arial',
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
  // Flag to track which page is currently active
  bool isMoodMateActive = false;

  // Data mood untuk seminggu
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
        body: SafeArea(
            child: Column(
              children: [
                // Header (tidak di-scroll)
                Container(
                  padding: const EdgeInsets.all(20),
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
                      const Text("Hey, Khansa 👍", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text("Review Your Mood History", style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A))),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE4A9B8), width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isMoodMateActive = false; // Switching to Mood Log
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMoodMateActive ? Colors.transparent : const Color(0xFFD48DA2), // Active mood log color
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: Text('Mood log', style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isMoodMateActive = true; // Switching to Mood Mate
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MoodMateScreen(), // Navigating to MoodMateScreen
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMoodMateActive ? const Color(0xFFD48DA2) : Colors.transparent, // Active mood mate color
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('Mood Mate', style: TextStyle(color: Colors.white)),
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
                  child: ListView.builder(
                    itemCount: moodData.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const AlwaysScrollableScrollPhysics(),
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
                                style: const TextStyle(fontSize: 16, color: Color(0xFF7A7A7A)),
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
                                    color: isHighlight ? const Color(0xFFF7D8DE) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(mood, style: const TextStyle(fontSize: 24)),
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
            ),
        );
    }
}
