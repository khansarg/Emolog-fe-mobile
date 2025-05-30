import 'package:flutter/material.dart';
import 'diary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditDiaryPage extends StatefulWidget {
  final DiaryEntry entry;
  final Function(DiaryEntry) onSave;

  const EditDiaryPage({
    Key? key,
    required this.entry,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditDiaryPage> createState() => _EditDiaryPageState();
}

class _EditDiaryPageState extends State<EditDiaryPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _entryDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _contentController = TextEditingController(text: widget.entry.content);
    _entryDate = widget.entry.date;
  }

  Future<void> _saveChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('http://10.0.2.2:8000/api/diaries/${widget.entry.id}');

    final response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': _titleController.text,
        'content': _contentController.text,
        'diary_date': _entryDate.toIso8601String().substring(0, 10),
      }),
    );

    if (response.statusCode == 200) {
      widget.onSave(DiaryEntry(
        id: widget.entry.id,
        title: _titleController.text,
        content: _contentController.text,
        date: _entryDate,
      ));
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      print('Gagal mengedit diary');
      print(response.body);
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
      backgroundColor: const Color(0xFFF8D7D5), // pink lembut
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8D7D5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Judul',
                      hintStyle: TextStyle(color: Colors.black38),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tuliskan ceritamu di sini...',
                          hintStyle: TextStyle(color: Colors.black38),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 26,
            child: FloatingActionButton(
              onPressed: _saveChanges,
              backgroundColor: const Color(0xFFB47878),
              child: const Icon(Icons.check, color: Colors.white),
              elevation: 6,
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
