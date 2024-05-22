// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pricesense/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 5)); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pricesense",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(76, 194, 201, 1),
              ),
            ),
            SizedBox(height: 20), 
            CircularProgressIndicator(
              color: Color.fromRGBO(76, 194, 201, 1)
            ),
          ],
        ),
      ),
    );
  }
}

