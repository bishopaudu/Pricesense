import 'package:flutter/material.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/history_screen.dart';
import 'package:pricesense/screens/home_screen.dart';
//import 'package:pricesense/screens/settings_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final pages = [
    const HomeScreen(),
    HistoryScreen(),
    const AgentDetails()
  ];

  int selectedScreenIndex = 0;

  void setIndex(int index) {
    setState(() {
      selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedScreenIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        currentIndex: selectedScreenIndex,
        selectedItemColor: const Color.fromRGBO(76, 193, 201, 1),
        unselectedItemColor: Colors.grey,
        onTap: setIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Settings",
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

