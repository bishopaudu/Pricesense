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
        child: TextFormField(
          keyboardType:textInputType,
          controller: controller,
          obscureText: obsecureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: text,
            hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
            prefixIcon: Icon,
             contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          ),
        ));
  }
}

