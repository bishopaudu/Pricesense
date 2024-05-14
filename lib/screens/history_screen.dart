import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("History"),
         backgroundColor: Colors.teal.shade200,
         actions: [
           IconButton(onPressed: (){}, icon:Icon(Icons.more_vert_rounded))
         ],
      ),
    );
  }
}