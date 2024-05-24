/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            icon: FaIcon(Icons.home),
            label: "Home",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(Icons.history),
            label: "History",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(Icons.person),
            label: "Settings",
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/history_screen.dart';
import 'package:pricesense/screens/home_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const HistoryScreen(),
    const AgentDetails(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
           showSelectedLabels: false,
        showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(76, 193, 201, 1),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.person),
              label: 'Agent',
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/history_screen.dart';
import 'package:pricesense/screens/home_screen.dart';

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
  ];

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
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
        body: Stack(
          children: _pages.asMap().map((index, page) {
            return MapEntry(
              index,
              Offstage(
                offstage: _selectedIndex != index,
                child: Navigator(
                  key: _navigatorKeys[index],
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => page,
                    );
                  },
                ),
              ),
            );
          }).values.toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromRGBO(76, 193, 201, 1),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.person),
              label: 'Agent',
            ),
          ],
        ),
      ),
    );
  }
}
