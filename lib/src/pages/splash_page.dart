import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/lupa_icon.png', width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 20),
            const Text('Forkify', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        )
      )
    );
  }
}