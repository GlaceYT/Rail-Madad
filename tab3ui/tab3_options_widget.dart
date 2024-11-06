import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tab3ui/personal_info.dart'; // Import PersonalInfoScreen
import '../ui1/login.dart';
import '../main.dart';

class Tab3OptionsWidget extends StatelessWidget {
  const Tab3OptionsWidget({super.key});

  // Sign-out function with confirmation dialog
  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm logout
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // ignore: use_build_context_synchronously
      await _signOut(context);
    }
  }

  // Actual sign-out logic
  Future<void> _signOut(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await secureStorage.delete(key: 'token');

    // Navigate back to login screen and remove all previous routes
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLogin: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Getting the screen height for the layout to adjust accordingly
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenHeight,
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Adding dividers for visual separation
              const Divider(thickness: 1, color: Colors.grey), // Top divider

              // Personal Information tile
              ListTile(
                leading: const Icon(Icons.person, color: Colors.orange, size: 30),
                title: const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                subtitle: const Text('View your account information'),
                onTap: () {
                  // Navigate to PersonalInfoScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                  );
                },
              ),
              const Divider(thickness: 1, color: Colors.grey), // Divider after each ListTile

              // Languages tile
              ListTile(
                leading: const Icon(Icons.language, color: Colors.orange, size: 30),
                title: const Text('Languages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                subtitle: const Text('Change app language'),
                onTap: () {
                  // Add functionality here
                },
              ),
              const Divider(thickness: 1, color: Colors.grey),

              // Settings tile
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.orange, size: 30),
                title: const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                subtitle: const Text('Customize your preferences'),
                onTap: () {
                  // Add functionality here
                },
              ),
              const Divider(thickness: 1, color: Colors.grey),

              // Privacy Policy tile
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.orange, size: 30),
                title: const Text('Privacy Policy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                subtitle: const Text('Read our privacy policies'),
                onTap: () {
                  // Add functionality here
                },
              ),
              const Divider(thickness: 1, color: Colors.grey),

              // Clear Cache tile
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.orange, size: 30),
                title: const Text('Clear Cache', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                subtitle: const Text('Remove temporary data'),
                onTap: () {
                  // Add functionality here
                },
              ),
              const Divider(thickness: 1, color: Colors.grey),

              // Log Out tile with confirmation
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent, size: 30),
                title: const Text('Log Out', style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.w600)),
                subtitle: const Text('End your session'),
                onTap: () => _confirmSignOut(context), // Call the logout confirmation
              ),
              const Divider(thickness: 1, color: Colors.grey), // Bottom divider
            ],
          ),
        ),
      ),
    );
  }
}
