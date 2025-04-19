import 'package:flutter/material.dart';
import 'changepassword.dart'; // Pastikan mengimpor halaman ChangePasswordPage

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
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
            _buildInputField('Username', _usernameController),
            const SizedBox(height: 16),
            _buildInputField('Email', _emailController),
            const SizedBox(height: 16),
            _buildInputField('Password', _passwordController),
            const SizedBox(height: 16),
            _buildFieldItem('Password', context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
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
          obscureText: label == 'Password', // Obscure password field
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFF1F1F1),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldItem(String label, BuildContext context) {
    return InkWell(
      onTap: () {
        // Tampilkan dialog untuk mengubah password saat tombol "Change" diklik
        if (label == 'Password') {
          _showChangePasswordDialog(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your username, email, and password',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const Text(
              'Change',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog untuk mengganti password
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 16,
          child: ChangePasswordPage(), // Menampilkan halaman untuk ganti password
        );
      },
    );
  }
}
