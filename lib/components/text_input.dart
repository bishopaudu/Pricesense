import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.textInputType,
      required this.text,
      required this.widget,
      required this.obsecureText,
      required this.controller,
      required this.focusNode,
      this.nextFocusedNode,
      required void Function(dynamic value) onChanged});
  final bool obsecureText;
  final String text;
  final TextEditingController controller;
  final Widget widget;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final FocusNode? nextFocusedNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          keyboardType: textInputType,
          controller: controller,
          obscureText: obsecureText,
          focusNode: focusNode,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1))),
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: text,
            hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
            prefixIcon: widget,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          ),
        ));
  }
}
