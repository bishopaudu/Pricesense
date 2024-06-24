 import 'package:flutter/material.dart';

void showErrorDialog(String message,BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Error'),
          content: Container(
            height: 40,
            width: 35,
            child: Center(
                child: Text(
              message,
              style: const TextStyle(fontSize: 16),
            )),
          ),
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