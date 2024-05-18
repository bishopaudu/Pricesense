// ignore_for_file: must_be_immutable

/*import 'package:flutter/material.dart';
import 'package:pricesense/screens/collection_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
   CategorySelectionScreen({super.key});
  List<String> categoryTypes = ['Staple Foods','Processed Food','Fruits'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category',style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           for(var types in categoryTypes)
            ElevatedButton(
            
            style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
             backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
             elevation: 5, 
              shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), 
        ),
      ),
      child:  Text(types),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CollectionScreen(category:types ),
                  ),
                );
              },
             
            ),
           
          ],
        ),
      ),
    );
  }

 
}*/


