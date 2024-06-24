// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/user_model.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/first_screen.dart';
import 'package:pricesense/screens/splash_screen.dart';
import 'package:pricesense/utils/auth_service.dart';
import 'package:pricesense/utils/colors.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
     // theme: ThemeData(primarySwatch: Colors.blue),
      title: 'PriceIntel',
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends ConsumerStatefulWidget {
  const InitialScreen({super.key});

  @override
  ConsumerState<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<InitialScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final authService = AuthService();
    final userProviderNotifier = ref.read(userProvider.notifier);
    final userData = await authService.getUserData();
    final isLoggedIn = userData['token'] != null && await authService.isTokenValid();

    if (isLoggedIn) {
      userProviderNotifier.setUser(UserData(
        token: userData['token']!,
        firstName: userData['firstName']!,
        lastName: userData['lastName']!,
        email: userData['email']!,
        city: userData['city']!,
        coordinator: userData['coordinator']!,
        gender: userData['gender']!,
        username: userData['username']!,
        role: userData['role']!,
        id: userData['id']!,
        phone: userData['phone']!,
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color:mainColor)
            : const Placeholder(),
      ),
    );
  }
}
