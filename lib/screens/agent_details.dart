import 'package:flutter/material.dart';

class AgentDetails extends StatelessWidget{
   const AgentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("AgentDetails"),
         backgroundColor: Colors.teal,
         actions: [
           Icon(Icons.more_vert,size:30)
         ],
      ),
      body:Column(
        children: [
          //agent avatar
          //agent details 

        ],
      )
    );
  }

}