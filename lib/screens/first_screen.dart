import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/category_selection.dart';
import 'package:pricesense/screens/history_screen.dart';
import 'package:pricesense/screens/home_screen.dart';
import 'package:pricesense/utils/sizes.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    CategorySelectionScreen(),
    const HistoryScreen(),
    const AgentDetails(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Popping to first route in case user taps the icon of the current tab
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future<bool> _onWillPop() async {
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
        return false;
      }
    }
    return isFirstRouteInCurrentTab;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages.asMap().map((index, page) {
            return MapEntry(
              index,
              Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => page,
                  );
                },
              ),
            );
          }).values.toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(76, 193, 201, 1),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
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
      ),
    );
  }
}

