import 'package:flutter/material.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/screens/first_screen.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstScreen()),
    );
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "AGENT LOGIN",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),
              TextInput(
                text: "Username",
                obsecureText: false,
                controller: usernameController,
                Icon: const Icon(Icons.verified_user, color: Colors.teal),
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: 20),
              TextInput(
                text: "Password",
                obsecureText: true,
                controller: passwordController,
                Icon: const Icon(Icons.password, color: Colors.teal),
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.teal.shade200,
                    shadowColor: Colors.teal.withOpacity(0.5),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    if (isLoading) return;
                    setState(() => isLoading = true);
                    await Future.delayed(
                      const Duration(seconds: 2),
                      () => {navigate()},
                    );
                  },
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(width: 20),
                            Text("Verifying",
                                style: TextStyle(color: Colors.white))
                          ],
                        )
                      : const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

