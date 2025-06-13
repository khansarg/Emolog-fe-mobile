import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddDiaryPage extends StatefulWidget {
  final DateTime selectedDate;
  const AddDiaryPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _AddDiaryPageState createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  Future<void> _saveDiaryToBackend() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diary kosong!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');

    if (token == null || username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ditemukan token login.')),
      );
      return;
    }

    final uri = Uri.parse('http://10.0.2.2:8000/api/diary');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'diary_date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diary berhasil disimpan!')),
      );
      Navigator.pop(context, true); // kirim sinyal berhasil
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: ${response.body}')),
      );
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 24),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'My Diary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickDate,
                      ),
                      Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Judul',
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Mulai menulis...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 12,
              top: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  _buildSidebarButton(Icons.close, () => Navigator.pop(context)),
                  const SizedBox(height: 12),
                  _buildSidebarButton(Icons.check, _saveDiaryToBackend),
                  const SizedBox(height: 12),
                  _buildSidebarButton(Icons.emoji_emotions, () {}),
                  const SizedBox(height: 12),
                  _buildSidebarButton(Icons.menu, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 56,
        width: 56,
        child: FloatingActionButton(
          onPressed: _saveDiaryToBackend,
          backgroundColor: const Color(0xFFB47878),
          child: const Icon(Icons.check, color: Colors.white, size: 28),
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  Widget _buildSidebarButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 40,
      width: 40,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        heroTag: null,
        child: Icon(icon, size: 20),
        shape: const CircleBorder(),
      ),
    );
  }
}
