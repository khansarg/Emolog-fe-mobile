import 'package:flutter/material.dart';
import '/features/settings/changepassword.dart'; // Pastikan mengimpor halaman ChangePasswordPage

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController(text: 'KhansaResqi');
  final _emailController = TextEditingController(text: 'khansaresqi@mail.com');
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, size: 50, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              'Khansa Resqi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildInputField('Username', _usernameController, 'KhansaResqi'),
            const SizedBox(height: 16),
            _buildInputField('Email', _emailController, 'khansaresqi@mail.com'),
            const SizedBox(height: 16),
            // Tombol untuk menampilkan Change Password sebagai dialog
            _buildPasswordButton(context),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun input field
  Widget _buildInputField(String label, TextEditingController controller, String defaultValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            suffixIcon: controller.text != defaultValue
                ? IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                _showConfirmationDialog(context, label, controller.text);
              },
            )
                : null,
          ),
        ),
      ],
    );
  }

  // Dialog konfirmasi untuk perubahan data
  void _showConfirmationDialog(BuildContext context, String field, String newValue) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to change?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 24),
                Text(
                  'Do you want to change $field to $newValue?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Menutup dialog jika Cancel
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Tombol Save dengan warna merah
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (field == 'Username') {
                            _usernameController.text = newValue;
                          } else if (field == 'Email') {
                            _emailController.text = newValue;
                          }
                        });
                        Navigator.pop(context); // Tutup dialog dan simpan perubahan
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tombol untuk menampilkan popup Change Password sebagai dialog
  Widget _buildPasswordButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Tampilkan dialog ChangePasswordPage sebagai popup
        showDialog(
          context: context,
          builder: (context) => const ChangePasswordPage(),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red), // Warna border merah
          borderRadius: BorderRadius.circular(16),
          color: Colors.red, // Warna latar belakang merah
        ),
        child: const Text(
          'Change Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
