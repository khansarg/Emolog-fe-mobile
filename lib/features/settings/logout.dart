import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final Function onLogout;

  // Constructor
  const LogoutDialog({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Menambahkan border radius
      ),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Cancel
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Menutup dialog jika Cancel
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Tombol Logout
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Ganti warna background tombol menjadi merah
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    onLogout(); //aksi logout
                    Navigator.pop(context); // Menutup dialog setelah Logout
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white, // Menjadikan teks berwarna putih
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
