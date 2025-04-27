import 'package:flutter/material.dart';
import '/Button/BottomNavigationBar.dart';
import 'switchWeek.dart';
import 'addDiary.dart';


class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class DiaryEntry {
  final String title;
  final String content;
  final DateTime date;

  DiaryEntry({
    required this.title,
    required this.content,
    required this.date,
  });
}

class _DiaryPageState extends State<DiaryPage> {
  bool isDayView = true;
  int currentNavIndex = 1;

  List<DiaryEntry> entries = [
    DiaryEntry(
      title: "Menahan Emosi",
      content: "Hari ini, amarahku seperti api kecil yang tersembunyi di balik kabut. Bukan ledakan...",
      date: DateTime.now(),
    ),
    DiaryEntry(
      title: "Pagi yang Cerah",
      content: "Pagi ini ketika matahari bersinar masuk melalui jendela, aku merasa semangat hidup...",
      date: DateTime.now(),
    ),
    DiaryEntry(
      title: "Petang yang Tenang",
      content: "Duduk di teras sambil menikmati petang yang tenang adalah cara favoritku mengakhiri hari...",
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8D7D5),
      body: isDayView ? _buildDayView() : WeekView(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiaryPage()),
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

  Widget _buildDayView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          color: const Color(0xFFF8D7D5),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Diary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                _buildToggleButton(),
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
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entries[index].title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entries[index].content,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Container(
      height: 44,
      width: 200,
      decoration: BoxDecoration(
        color: Color(0xFFB47878).withOpacity(0.3),
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
    List<String> dates = ['29', '30', '01', '02', '03', '04', '05'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((day) => Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          )).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dates.map((date) {
            bool selected = date == '30';
            return Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFB47878) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                date,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}