import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../ui1/login.dart';
import './ui2/tab1.dart';
import './ui2/tab2.dart';
import './ui2/tab3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAuthenticated = false; // Authentication flag
  bool _isFirstLaunch = false; // Flag for first launch
  final _secureStorage = const FlutterSecureStorage(); // Secure storage instance

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch(); // Check if the app is opened for the first time
  }

  Future<void> _checkFirstLaunch() async {
    // Check if the splash screen has already been shown
    final isFirstLaunch = await _secureStorage.read(key: 'isFirstLaunch');
    final token = await _secureStorage.read(key: 'token');

    if (isFirstLaunch == null) {
      // First time opening the app
      setState(() {
        _isFirstLaunch = true;
      });
    } else {
      // Not first time, check authentication
      setState(() {
        _isAuthenticated = token != null;
        _isFirstLaunch = false;
      });
    }
  }

  Future<void> _onSplashFinished() async {
    await _secureStorage.write(key: 'isFirstLaunch', value: 'false'); // Mark splash as shown
    setState(() {
      _isFirstLaunch = false;
    });
  }

  void _login() {
    setState(() {
      _isAuthenticated = true;
    });
  }

  void _logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'AfacadFlux', // Set global font here
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'AfacadFlux', fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontFamily: 'AfacadFlux', fontWeight: FontWeight.normal),
          headlineLarge: TextStyle(fontFamily: 'AfacadFlux', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'AfacadFlux', fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: 'AfacadFlux', fontWeight: FontWeight.bold),
        ),
      ),
      home: _isFirstLaunch
          ? SplashScreen(onSplashFinished: _onSplashFinished)
          : _isAuthenticated
              ? HomeNavigator(onLogout: _logout)
              : LoginScreen(onLogin: _login),
    );
  }
}

// Splash Screen widget
class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashFinished;

  const SplashScreen({super.key, required this.onSplashFinished});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Show the splash screen for 3 seconds
    Timer(const Duration(seconds: 3), widget.onSplashFinished);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Splash background color
      body: Center(
        child: Image.asset('assets/logo.png'), // Centered PNG image
      ),
    );
  }
}

// HomeNavigator for main tabs after login
// HomeNavigator for main tabs after login
class HomeNavigator extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeNavigator({super.key, required this.onLogout});

  @override
  // ignore: library_private_types_in_public_api
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Tab1(), // Home tab
    Tab2(), // Chat tab
    Tab3(), // Profile tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 243, 88, 77),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Color.fromARGB(255, 57, 220, 35),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Color.fromARGB(255, 219, 92, 241),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}