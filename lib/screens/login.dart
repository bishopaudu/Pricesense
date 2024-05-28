import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/screens/first_screen.dart';
import 'package:pricesense/model/user_model.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool isLoading = false;
  String errorMessage = '';

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstScreen()),
    );
    setState(() => isLoading = false);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    const String loginEndpoint = 'https://priceintel.vercel.app/auth/login';
    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('token')) {
          //final userData = UserData.fromJson(responseData);
          //UserData(id: id, token: token, firstName: firstName, lastName: lastName, coordinator: coordinator)
          navigate();
        } else {
          showErrorDialog(responseData['message'] ?? 'Login failed');
        }
      } else {
        showErrorDialog('Login failed. Please try again.');
      }
    } catch (error) {
      print('Error: $error');
      showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                focusNode: usernameFocusNode,
                nextFocusedNode: passwordFocusNode,
                text: "Username",
                obsecureText: false,
                controller: usernameController,
                textInputType: TextInputType.name,
                widget: const Icon(Icons.verified_user,
                    color: Color.fromRGBO(76, 194, 201, 1)),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              TextInput(
                focusNode: passwordFocusNode,
                text: "Password",
                obsecureText: true,
                controller: passwordController,
                textInputType: TextInputType.visiblePassword,
                widget: const Icon(Icons.password,
                    color: Color.fromRGBO(76, 194, 201, 1)),
                onChanged: (value) {},
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
                  onPressed: isLoading ? null : login,
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


