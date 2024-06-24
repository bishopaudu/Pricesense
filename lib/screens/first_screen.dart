import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/category_selection.dart';
import 'package:pricesense/screens/recents_screen.dart';
import 'package:pricesense/screens/home_screen.dart';
import 'package:pricesense/utils/bottombar_notifier.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';

class FirstScreen extends ConsumerStatefulWidget {
  const FirstScreen({super.key});

  @override
  ConsumerState<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends ConsumerState<FirstScreen> {
  @override
  Widget build(BuildContext context) {
  final _selectedIndex = ref.watch(bottomNavProvider);
  
    void onItemTapped(int index) {
      ref.read(bottomNavProvider.notifier).setIndex(index);
    }

 //   int _currentIndex = 0;
  final List<Widget> _screens = [
     const HomeScreen(),
      CategorySelectionScreen(),
      const HistoryScreen(),
     const AgentDetails(
      ),
  ];

    return Scaffold(
      body:IndexedStack(
        index: _selectedIndex,
        children:_screens
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap:onItemTapped,
        items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(Icons.home, size: Sizes.iconSize),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.description, size: Sizes.iconSize),
              label: 'Survey',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.history, size: Sizes.iconSize),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.person, size: Sizes.iconSize),
              label: 'Agent',
            ),
          ],
      ),
    );
  }
}





