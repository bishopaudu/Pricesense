import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.textInputType,
      required this.text,
      required this.Icon,
      required this.obsecureText,
      required this.controller});
  final bool obsecureText;
  final String text;
  final TextEditingController controller;
  final Widget Icon;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          keyboardType:textInputType,
          controller: controller,
          obscureText: obsecureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: text,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon,
             contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          ),
        ));
  }
}

