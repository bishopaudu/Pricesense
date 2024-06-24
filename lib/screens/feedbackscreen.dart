// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends ConsumerStatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;

  Future<void> _submitFeedback() async {
    final user = ref.watch(userProvider);
    final connectivityResult = ref.watch(connectivityProvider);
    if (_formKey.currentState!.validate()) {
      final String name = nameController.text;
      final String email = emailController.text;
      final String message = feedbackController.text;
      final data = {'name': name, 'email': email, 'message': message};
       setState(() {
      isUploading = true;
    });
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        final response = await http.post(
          Uri.parse('https://priceintel.vercel.app/user/feedback'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
          body: json.encode(data),
        );
        if (response.statusCode == 200) {
          setState(() {
            isUploading = false;
          });
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')),
          );
          nameController.clear();
          emailController.clear();
          feedbackController.clear();
          print(response.body);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading')),
          );
          setState(() {
            isUploading = false;
          });
          print(response.body);
          print(response.statusCode);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not connected to server')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Feedback"
              : "No Internet Acess",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: internetStatus == ConnectivityResult.mobile ||
                internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'Name',
                    //border: OutlineInputBorder(),
                    labelStyle: const TextStyle(
                      color: mainColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'Email',
                    //border: OutlineInputBorder(),
                    labelStyle: const TextStyle(
                      color: mainColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'FeedBack',
                    //border: OutlineInputBorder(),
                    labelStyle: const TextStyle(
                      color: mainColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    minimumSize: const Size(150, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: mainColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: isUploading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                            SizedBox(width: 20),
                            Text("Submitting",
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      : const Text("Submit Feedback",
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
