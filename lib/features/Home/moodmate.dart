import 'package:flutter/material.dart';
import 'moodlog.dart'; // Import MoodLogScreen

class MoodMateScreen extends StatelessWidget {
  const MoodMateScreen({super.key});

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
                  const Text("Based on Your Mood Today", style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A))),
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
                              // Navigasi ke MoodLogScreen saat Mood Log dipilih
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MoodLogScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: const Color(0xFFD48DA2), width: 1),
                              ),
                              child: const Center(
                                child: Text('Mood log', style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD48DA2),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: const Center(
                              child: Text('Mood Mate', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Today mood:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            // Mood Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("😭", style: TextStyle(fontSize: 36)),
                SizedBox(width: 20),
                Text("😐", style: TextStyle(fontSize: 36)),
                SizedBox(width: 20),
                Text("😂", style: TextStyle(fontSize: 36)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Quotes of the day:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "CIE HARI INI HAPPY, CAPTURE THIS MOMENT GATAU APALGI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
