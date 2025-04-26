import 'package:emolog/features/register/register.dart';
import 'package:emolog/features/settings/mainsettings.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState()=> _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  String username ='';
  String password ='';
  bool _obscureText = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFDC9B9B),

      body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/logo.png',
                height: 320,
              ),
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Username', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF4f4747), fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value){
                  setState(() {
                    username = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your username...',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.grey[700]
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white, width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white, width: 2)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white, width: 2)
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF4f4747), fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscureText,
                onChanged: (value){
                  setState(() {
                    password = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Enter your password...',
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700]
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white, width: 2)
                    ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white, width: 2)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white, width: 2)
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                    alignment: Alignment.centerRight,
                     child:
                     ElevatedButton(onPressed: () {
                       if (username == 'halo123' && password == 'hi'){
                         Navigator.push(context,
                             MaterialPageRoute(builder: (context) => const SettingsPage()));
                       } else {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username atau Password salah')));
                       }
                     },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFFA16868),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
                         ),
                         elevation: 4,
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       ),
                       child: const Text('Login',
                         style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                       ),
                     ),
                   ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child:
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: RichText(text: const TextSpan(text: "Doesn't have any account yet? Register", style: TextStyle(fontFamily: 'Poppins', color: Color(0xFFA16868), fontSize: 12, decoration: TextDecoration.underline))),
                ),
              ),


            ],
          ),

        ),

      )
      )
    );
  }
}

