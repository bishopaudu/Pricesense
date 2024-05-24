import 'package:flutter/material.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/screens/first_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

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
      MaterialPageRoute(builder: (context) => const FirstScreen()),
    );
    setState(() => isLoading = false);
  }

  Future<void> performLogin() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    navigate();
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
                  color: Color.fromRGBO(76, 194, 201, 1),
                ),
              ),
              const SizedBox(height: 40),
              TextInput(
                text: "Username",
                obsecureText: false,
                controller: usernameController,
                textInputType: TextInputType.name,
                widget: const Icon(Icons.verified_user,
                    color: Color.fromRGBO(76, 194, 201, 1)), onChanged: (value) {  },
              ),
              const SizedBox(height: 20),
              TextInput(
                text: "Password",
                obsecureText: true,
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                widget: const Icon(Icons.password,
                    color: Color.fromRGBO(76, 194, 201, 1)), onChanged: (value) {  },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
                    shadowColor: const Color.fromRGBO(76, 194, 201, 1),
                    elevation: 5,
                  ),
                  onPressed: isLoading ? null : performLogin,
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                            SizedBox(width: 20),
                            Text("Verifying",
                                style: TextStyle(color: Colors.white)),
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
