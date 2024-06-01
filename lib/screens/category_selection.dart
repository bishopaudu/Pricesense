// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pricesense/screens/collection_screen.dart';
import 'package:pricesense/screens/online_stores.dart'; 
import 'package:pricesense/screens/macroeconomics.dart'; 

class CategorySelectionScreen extends StatelessWidget {
  CategorySelectionScreen({super.key});
  List<String> categoryTypes = ['Market', 'Online Stores', 'Macroeconomic Indicators'];

  void navigateToCategoryScreen(BuildContext context, String category) {
    Widget screen;
    switch (category) {
      case 'Market':
        screen = const CollectionScreen(); 
        break;
      case 'Online Stores':
        screen = const OnlineStores(); 
        break;
      case 'Macroeconomic Indicators':
        screen = const Marcoeconomics(); 
        break;
      default:
        screen = const SizedBox(child:Center(child: Text('Text'))); 
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Collection Type',
          textAlign:TextAlign.center ,
          style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var types in categoryTypes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(60), // Increased button height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(types),
                    onPressed: () => navigateToCategoryScreen(context, types),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:pricesense/screens/collection_screen.dart';
import 'package:pricesense/screens/online_stores.dart';
import 'package:pricesense/screens/macroeconomics.dart';

class CategorySelectionScreen extends StatelessWidget {
  CategorySelectionScreen({super.key});
  List<String> categoryTypes = ['Market', 'Online Stores', 'Macroeconomic Indicators'];

  void navigateToCategoryScreen(BuildContext context, String category) {
    Widget screen;
    switch (category) {
      case 'Market':
        screen = const CollectionScreen();
        break;
      case 'Online Stores':
        screen = const OnlineStores();
        break;
      case 'Macroeconomic Indicators':
        screen = const Marcoeconomics();
        break;
      default:
        screen = const SizedBox(child: Center(child: Text('Text')));
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Collection Type',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
        ),
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var types in categoryTypes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(60), // Increased button height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Slightly more rounded corners
                      ),
                    ),
                    child: Text(
                      types,
                      style: const TextStyle(fontSize: 18), // Increased font size
                    ),
                    onPressed: () => navigateToCategoryScreen(context, types),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}*/




