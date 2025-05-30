import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'moodmate.dart';
import '/Button/BottomNavigationBar.dart';

class MoodLogScreen extends StatefulWidget {
  const MoodLogScreen({super.key});

  @override
  _MoodLogScreenState createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  int _currentIndex = 0;
  bool isMoodMateActive = false;
  String username = '';

  DateTime _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  Map<String, List<String>> _weeklyMoods = {};
  bool _isLoading = false;

  final Map<String, String> moodMap = {
    'Sad': '😭',
    'Neutral': '😐',
    'Happy': '😂',
  };

  @override
  void initState() {
    super.initState();
    _fetchWeeklyMood();
    loadUsername();
  }
  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username') ?? '';
    setState(() {
      username = storedUsername;
    });
  }
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
  Future<void> _fetchWeeklyMood() async {
    setState(() => _isLoading = true);
    final token = await getToken();

    final String formattedDate = DateFormat('yyyy-MM-dd').format(_currentWeekStart);
    final url = Uri.parse('http://10.0.2.2:8000/api/moods/week?start_date=$formattedDate');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          _weeklyMoods = data.map((day, moods) {
            final moodList = List<String>.from(moods);
            return MapEntry(day, moodList);
          });
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() => _isLoading = false);
  }

  void _changeWeek(int offset) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: offset * 7));
    });
    _fetchWeeklyMood();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final String rangeText = "${DateFormat('MMM dd').format(_currentWeekStart)} - ${DateFormat('MMM dd').format(_currentWeekStart.add(const Duration(days: 6)))}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
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
                Text("Hey, ${username.isNotEmpty ? username : 'User'} 👍", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                const SizedBox(height: 8),
                const Text("Review Your Mood History", style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A), fontFamily: 'Poppins')),
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
                          onTap: () => setState(() => isMoodMateActive = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isMoodMateActive ? Colors.transparent : const Color(0xFFD48DA2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text('Mood log', style: TextStyle(color: isMoodMateActive ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => isMoodMateActive = true);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodMateScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isMoodMateActive ? const Color(0xFFD48DA2) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text('Mood Mate', style: TextStyle(color: isMoodMateActive ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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

          // Week navigator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(onTap: () => _changeWeek(-1), child: const Icon(Icons.arrow_back_ios, size: 16)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE4A9B8), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(rangeText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(width: 6),
                GestureDetector(onTap: () => _changeWeek(1), child: const Icon(Icons.arrow_forward_ios, size: 16)),
              ],
            ),
          ),

          // Mood list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                :ListView.builder(
              itemCount: days.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final day = days[index];
                final moodsFromBackend = _weeklyMoods[day] ?? [];
                final latestMood = moodsFromBackend.isNotEmpty ? moodsFromBackend.last : null;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6)],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 70, child: Text(day, style: const TextStyle(fontSize: 16, color: Color(0xFF7A7A7A)))),
                      ...moodMap.entries.map((entry) {
                        final isHighlighted = entry.key == latestMood;
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isHighlighted ? const Color(0xFFF7D8DE) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(entry.value, style: const TextStyle(fontSize: 24)),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            )

          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
