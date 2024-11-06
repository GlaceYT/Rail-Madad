import 'package:flutter/material.dart';
import '../ui2/tab1.dart';
import '../ui2/tab2.dart';
import '../ui2/tab3.dart';

class Routes {
  static const String tab1 = '/tab1';
  static const String tab2 = '/tab2';
  static const String tab3 = '/tab3';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      tab1: (context) => const Tab1(),
      tab2: (context) => const Tab2(),
      tab3: (context) => const Tab3(),
    };
  }
}

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  // List of pages to display in the body of the HomeScreen
  final List<Widget> _pages = [
    const Tab1(),
    const Tab2(),
    const Tab3(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Color.fromARGB(255, 70, 255, 76),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}