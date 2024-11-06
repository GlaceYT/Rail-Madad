import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tab3ui/profile_widget.dart';
import '../tab3ui/tab3_options_widget.dart'; // Import the options widget

class Tab3 extends StatefulWidget {
  const Tab3({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  String? name;
  String? username;
  String? profilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Loading...';
      username = prefs.getString('username') ?? 'Loading...';
      profilePicture = prefs.getString('profilePicture');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            ProfileWidget(
              name: name ?? 'Loading...',
              username: username ?? 'Loading...',
              profilePicture: profilePicture,
            ), // Pass the data to ProfileWidget
            
            const SizedBox(height: 30),
            
            // This limits the scrollable content for both small and large devices
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // If content is larger than the available space, allow scrolling
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: screenHeight * 0.4, // Minimum height for small devices
                        maxHeight: screenHeight * 0.7, // Max height to limit on large devices
                      ),
                      child: const Tab3OptionsWidget(), // Your options widget goes here
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20), // Spacing before the bottom of the screen
          ],
        ),
      ),
    );
  }
}
