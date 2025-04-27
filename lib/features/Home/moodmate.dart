import 'package:flutter/material.dart';
import 'moodlog.dart';
import '/Button/BottomNavigationBar.dart'; // Import CustomBottomNavBar

class MoodMateScreen extends StatefulWidget {
  const MoodMateScreen({super.key});

  @override
  _MoodMateScreenState createState() => _MoodMateScreenState();
}

class _MoodMateScreenState extends State<MoodMateScreen> {
  int _currentIndex = 0;
  bool isMoodMateActive = true;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToMoodLog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MoodLogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
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
                  Text(
                    "Hey, Khansa 👍",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Review Your Mood History",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7A7A7A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xFFE4A9B8), width: 1),
                    ),
                    child: Row(
                      children: [
                        // Mood Log Button
                        Expanded(
                          child: GestureDetector(
                            onTap: navigateToMoodLog,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMoodMateActive ? Colors.transparent : const Color(0xFFD48DA2),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Mood log",
                                style: TextStyle(
                                  color: isMoodMateActive ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Mood Mate Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMoodMateActive = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMoodMateActive ? const Color(0xFFD48DA2) : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Mood Mate",
                                style: TextStyle(
                                  color: isMoodMateActive ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Today's Mood:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("😭", style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 20),
                        const Text("😐", style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.all(8.0), // Menambah padding untuk jarak dengan teks
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7D8DE), // Warna background
                            borderRadius: BorderRadius.circular(12), // Membuat sudut membulat
                          ),
                          child: const Text(
                            "😂",
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Quote of the Day:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "CIE HARI INI HAPPY, CAPTURE THIS MOMENT KARENA MOMEN BAHAGIA SEPERTI INI HARUS DIABADIKAN!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
