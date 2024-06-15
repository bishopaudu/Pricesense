import 'package:flutter/material.dart';
import 'package:pricesense/utils/colors.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.labelText,
      required this.textInputType,
      required this.text,
      required this.widget,
      required this.obsecureText,
      required this.controller,
      required this.focusNode,
      this.nextFocusedNode,
      this.suffixIcon,
      required this.enabled,
      required void Function(dynamic value) onChanged});
  final bool obsecureText;
  final String text;
  final TextEditingController controller;
  final Widget widget;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final FocusNode? nextFocusedNode;
  final String labelText;
  final Widget? suffixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 55,
          child: TextField(
            keyboardType: textInputType,
            controller: controller,
            obscureText: obsecureText,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Color.fromRGBO(184, 184, 184, 1),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8)
              ),
              focusedBorder:  OutlineInputBorder(
                  borderSide: const BorderSide(color: mainColor),
                  borderRadius: BorderRadius.circular(8)
                  ),
              fillColor: Colors.grey.shade100,
              filled: true,
              hintText: text,
              hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
              prefixIcon: widget,
              suffixIcon: suffixIcon,
              enabled: enabled,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 27.0, horizontal: 12.0),
            ),
          ),
        ));
  }
}
