import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/Button/BottomNavigationBar.dart';
import 'switchWeek.dart';
import 'addDiary.dart';
import 'editDiary.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class DiaryEntry {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['diary_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'diary_date': date.toIso8601String().substring(0, 10),
    };
  }
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime selectedDate = DateTime.now();
  bool isDayView = true;
  int currentNavIndex = 1;
  List<DiaryEntry> entries = [];

  @override
  void initState() {
    super.initState();
    fetchDiaryEntriesByDay(selectedDate);
  }

  Future<void> fetchDiaryEntriesByDay([DateTime? date]) async {
    final selected = date ?? selectedDate;

    final url = Uri.parse(
        'http://10.0.2.2:8000/api/diaries/day?date=${selected.toIso8601String().substring(0, 10)}'
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> diaryList = jsonData is List
          ? jsonData
          : (jsonData['diaries'] ?? []);

      setState(() {
        entries = diaryList.map((entry) => DiaryEntry(
          id: entry['id'] ?? '',
          title: entry['title'] ?? '',
          content: entry['content'] ?? '',
          date: DateTime.tryParse(entry['diary_date'] ?? '') ?? DateTime.now(),
        )).toList();
      });
    } else {
      print("Gagal mengambil data diary");
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }




  void _updateEntry(DiaryEntry oldEntry, DiaryEntry newEntry) {
    setState(() {
      final index = entries.indexOf(oldEntry);
      if (index != -1) {
        entries[index] = newEntry;
      }
    });
  }

  void _deleteEntry(DiaryEntry entry) {
    setState(() {
      entries.remove(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DiaryEntry> selectedEntries = entries.where((entry) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      return entryDate == selected;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8D7D5),
      body: isDayView
          ? _buildDayView(selectedEntries)
          : WeekView(
        onToggleView: () {
          setState(() {
            isDayView = true;
          });
        },
        currentNavIndex: currentNavIndex,
        onNavTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        entries: entries,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDiaryPage(selectedDate: selectedDate)),
          );
        },
        backgroundColor: const Color(0xFFB47878),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentNavIndex,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDayView(List<DiaryEntry> dayEntries) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          color: const Color(0xFFF8D7D5),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'My Diary',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, color: Colors.black87, size: 22),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                              fetchDiaryEntriesByDay(pickedDate);
                            }
                          },
                        ),
                      ],
                    ),
                    _buildToggleButton(),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCalendar(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 24, bottom: 100),
              itemCount: dayEntries.length,
              itemBuilder: (context, index) {
                return _buildDayEntry(dayEntries[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayEntry(DiaryEntry entry) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiaryDetailPage(
              entry: entry,
              onUpdate: _updateEntry,
              onDelete: _deleteEntry,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Container(
      height: 44,
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFB47878).withOpacity(0.3),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isDayView = true),
              child: Container(
                decoration: BoxDecoration(
                  color: isDayView ? const Color(0xFFB47878) : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDayView ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isDayView = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isDayView ? const Color(0xFFB47878) : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Week',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !isDayView ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    DateTime weekStart = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    List<DateTime> weekDates = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            return Container(
              width: 36,
              height: 24,
              alignment: Alignment.center,
              child: Text(
                days[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            DateTime date = weekDates[index];
            bool selected = date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
                fetchDiaryEntriesByDay(date);
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFB47878) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}