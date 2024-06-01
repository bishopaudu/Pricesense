import 'package:flutter/material.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/utils/sizes.dart';

class DateInput extends StatefulWidget {
  const DateInput({Key? key}) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final TextEditingController dateController = TextEditingController();
  final FocusNode dateFocusNode = FocusNode();
  DateTime? dateTime;

  Future<DateTime?> selectDate() async {
    return showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Date Input Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () async {
            final date = await selectDate();
            if (date != null) {
              setState(() {
                dateTime = date;
                dateController.text =
                    '${dateTime!.year}/${dateTime!.month}/${dateTime!.day}';
              });
            }
          },
          child: AbsorbPointer(
            child: TextInput(
              textInputType: TextInputType.none,
              text: "Select Date",
              widget: IconButton(
                onPressed: () async {
                  final date = await selectDate();
                  if (date == null) {
                    return;
                  }
                  setState(() {
                    dateTime = date;
                    dateController.text =
                        '${dateTime!.year}/${dateTime!.month}/${dateTime!.day}';
                  });
                },
                icon: const Icon(
                  Icons.event,
                  size: Sizes.iconSize,
                  color: Color.fromRGBO(76, 194, 201, 1),
                ),
              ),
              obsecureText: false,
              controller: dateController,
              focusNode: dateFocusNode,
              onChanged: (value) {},
              labelText: 'Date',
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DateInput(),
  ));
}
