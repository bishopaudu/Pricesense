// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Handle the feedback submission
      final String name = nameController.text;
      final String email = emailController.text;
      final String feedback = feedbackController.text;

      // Clear the text fields after submission
      nameController.clear();
      emailController.clear();
      feedbackController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
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
                color: Color.fromRGBO(184, 184, 184, 1),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8)
              ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  borderRadius: BorderRadius.circular(8)
                  ),    
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
                color: Color.fromRGBO(184, 184, 184, 1),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8)
              ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  borderRadius: BorderRadius.circular(8)
                  ),    
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
                color: Color.fromRGBO(184, 184, 184, 1),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8)
              ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  borderRadius: BorderRadius.circular(8)
                  ),    
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
                /*ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(76, 194, 201, 1),
                  ),
                  child: Text('Submit Feedback'),
                ),*/
                 ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(150, 45), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                     backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text("Submit FeedBack", style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
