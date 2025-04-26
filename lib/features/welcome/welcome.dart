import 'package:emolog/features/login/login.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}
class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState(){
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1), )..repeat(reverse: true); //biar ada animasi fade in fade out
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();//fade in logonya bg

    _controller.addStatusListener((status)async{
      if (status == AnimationStatus.completed){
        await Future.delayed(const Duration(seconds: 2));
        await _controller.reverse();
      } else if (status == AnimationStatus.dismissed){
        if (mounted){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
        }
      }
    });
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xFFDC9B9B)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FadeTransition(opacity: _animation, child: Image.asset('assets/images/logo.png')),
        )
      ),
    );
  }
}