import 'package:flutter/material.dart';
import 'diary.dart'; // supaya bisa akses DiaryEntry dari DiaryPage

class WeekView extends StatelessWidget {
  final VoidCallback onToggleView;
  final int currentNavIndex;
  final Function(int) onNavTap;
  final List<DiaryEntry> entries; // tambahkan entries dari DiaryPage

  const WeekView({
    Key? key,
    required this.onToggleView,
    required this.currentNavIndex,
    required this.onNavTap,
    required this.entries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8D7D5),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Diary',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      _buildToggleButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildWeekSelector(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return _buildDayEntry(entries[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Container(
      height: 36,
      width: 140, // Set a fixed width for the toggle
      decoration: BoxDecoration(
        color: const Color(0xFFB47878).withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onToggleView,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB47878),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Week',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black54),
          onPressed: () {},
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFB47878).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Jan 29 - Feb 05',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.black54),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDayEntry(DiaryEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
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
              const SizedBox(height: 8),
              Text(
                "${entry.date.day}/${entry.date.month}/${entry.date.year}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}