// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pricesense/utils/sizes.dart';

class CustomDropdown extends StatefulWidget {
  CustomDropdown(
      {super.key,
      required this.onChanged,
      required this.dataList,
      required this.value,
      required this.maintitle,
      required this.subtitle});
  final List<String> dataList;
  String? value;
  final String maintitle;
  final String subtitle;
  final ValueChanged<String?> onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: const Color.fromRGBO(
                76,
                194,
                201,
                1,
              ),
              width: 1)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.maintitle,
                style: const TextStyle(
                    fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1)),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(widget.subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
            ],
          ),
          value: widget.value,
          isExpanded: true,
          iconSize: Sizes.iconSize,
          icon: widget.value != null
              ? Icon(
                  Icons.done,
                  color: Colors.green.shade200,
                )
              : Icon(Icons.arrow_drop_down, color: Colors.black),
          items: widget.dataList.map(buildItem).toList(),
          onChanged: (value) {
            setState(() {
              widget.value = value;
            });
            widget.onChanged(value);
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildItem(String data) => DropdownMenuItem(
        value: data,
        child: Text(
          data,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      );
}
