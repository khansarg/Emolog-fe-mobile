import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'diary.dart';
import 'editDiary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class WeekView extends StatefulWidget {
  final VoidCallback onToggleView;
  final int currentNavIndex;
  final Function(int) onNavTap;
  final List<DiaryEntry> entries;

  const WeekView({
    Key? key,
    required this.onToggleView,
    required this.currentNavIndex,
    required this.onNavTap,
    required this.entries,
  }) : super(key: key);

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  DateTime get startOfWeek =>
      _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));

  void _goToPreviousWeek() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 7));
    });
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final dateFormat = DateFormat('MMM dd');
    final startStr = dateFormat.format(start);
    final endStr = dateFormat.format(end);
    return '$startStr - $endStr';
  }
  Future<void> deleteDiaryEntry(int diaryId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('http://10.0.2.2:8000/api/diaries/$diaryId');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Diary berhasil dihapus');
      // Lakukan sesuatu, misal refresh list atau pop
    } else {
      print('Gagal menghapus diary');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8D7D5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Diary',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      _buildToggleButton(),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                child: widget.entries.isEmpty
                    ? const Center(
                  child: Text(
                    "Belum ada catatan minggu ini",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
                    : _buildWeekEntries(),
              ),
            ),
          ],
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
              onTap: widget.onToggleView,
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
                borderRadius: BorderRadius.circular(22),
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
          onPressed: _goToPreviousWeek,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFB47878).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _formatDateRange(startOfWeek, endOfWeek),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.black54),
          onPressed: _goToNextWeek,
        ),
      ],
    );
  }

  Widget _buildWeekEntries() {
    final grouped = <String, List<DiaryEntry>>{};
    final dateFormatter = DateFormat('EEE, MMM dd');

    for (var entry in widget.entries) {
      final entryDate = entry.date;
      if (entryDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        final key = dateFormatter.format(entryDate);
        grouped.putIfAbsent(key, () => []).add(entry);
      }
    }

    if (grouped.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            "Tidak ada catatan untuk minggu ini.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((e) {
        final day = e.key;
        final entries = e.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.calendar_today,
                        size: 16, color: Colors.green[700]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            ...entries.map((entry) => _buildDayEntry(entry)).toList(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDayEntry(DiaryEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiaryDetailPage(
                entry: entry,
                onUpdate: (oldEntry, updatedEntry) {},
                onDelete: (deletedEntry) {},
              ),
            ),
          );
        },
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
}
class DiaryDetailPage extends StatelessWidget {
  final DiaryEntry entry;
  final Function(DiaryEntry oldEntry, DiaryEntry updatedEntry) onUpdate;
  final Function(DiaryEntry deletedEntry) onDelete;

  const DiaryDetailPage({
    Key? key,
    required this.entry,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Catatan"),
        backgroundColor: const Color(0xFFF8D7D5),
        foregroundColor: const Color(0xFFB47878),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(entry.date),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  entry.content,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final updatedEntry = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDiaryPage(
                            entry: entry,
                            onSave: (updatedEntry) {
                              Navigator.pop(context, updatedEntry); // Kembali dengan entri yang diupdate
                            },
                          ),
                        ),
                      );

                      if (updatedEntry != null) {
                        onUpdate(entry, updatedEntry); // Panggil callback update di parent
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Konfirmasi Hapus"),
                          content: const Text("Yakin ingin menghapus entri ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Hapus"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token') ?? '';

                        final url = Uri.parse('http://10.0.2.2:8000/api/diary/${entry.id}');

                        final response = await http.delete(
                          url,
                          headers: {
                            'Accept': 'application/json',
                            'Authorization': 'Bearer $token',
                          },
                        );

                        if (response.statusCode == 200) {
                          // Misalnya setelah hapus, kamu ingin kembali ke halaman sebelumnya
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Entri berhasil dihapus")),
                            );
                          }
                        } else {
                          print('Gagal menghapus diary');
                          print(response.body);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Gagal menghapus entri")),
                            );
                          }
                        }
                      }
                    },

                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

