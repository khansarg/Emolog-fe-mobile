import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/features/settings/changepassword.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController(text: 'Fill your username here');
  final _emailController = TextEditingController(text: 'Fill your email here');

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _verifyAccount(String field, String newValue) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/check-user');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Accept': 'application/json',},
        body: jsonEncode({
          'username': field == 'Username' ? newValue : _usernameController.text,
          'email': field == 'Email' ? newValue : _emailController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User ditemukan")),
        );
        setState(() {
          if (field == 'Username') {
            _usernameController.text = newValue;
          } else if (field == 'Email') {
            _emailController.text = newValue;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Terjadi kesalahan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal terhubung ke server: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
              'This Is Your Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildInputField('Username', _usernameController, 'Fill your username here'),
            const SizedBox(height: 16),
            _buildInputField('Email', _emailController, 'Fill your email here'),
            const SizedBox(height: 16),
            _buildPasswordButton(context),
          ],
        ),
      ),
    );
  }

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

  void _showConfirmationDialog(BuildContext context, String field, String newValue) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await _verifyAccount(field, newValue);
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

  Widget _buildPasswordButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final username = _usernameController.text;
        final email = _emailController.text;

        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final url = Uri.parse('http://10.0.2.2:8000/api/check-user');
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json',  'Accept': 'application/json',},
            body: jsonEncode({'username': username, 'email': email}),
          );

          Navigator.pop(context); // Close loading

          if (response.statusCode == 200) {
            showDialog(
              context: context,
              builder: (context) => const ChangePasswordPage(),
            );
          } else {
            final data = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'] ?? 'Verifikasi gagal')),
            );
          }
        } catch (e) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal terhubung ke server: $e')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
          color: Colors.red,
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
