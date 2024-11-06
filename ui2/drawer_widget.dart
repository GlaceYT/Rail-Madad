import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For accessing saved profile picture
import 'dart:convert'; // For base64 decoding
import 'package:url_launcher/url_launcher.dart'; // To launch URLs

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // Function to launch the official website
  void _launchURL() async {
    const url = 'https://www.irctc.co.in/nget/train-search';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Map<String, String?>> _getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profilePicture = prefs.getString('profilePicture');
    String? name = prefs.getString('name'); // Assume name is saved in SharedPreferences
    return {'profilePicture': profilePicture, 'name': name};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header with Profile Picture and Username
          FutureBuilder<Map<String, String?>>(
            future: _getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final profilePicture = snapshot.data?['profilePicture'];
              final name = snapshot.data?['name'] ?? 'User';

              return DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    // Profile Picture on the left
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profilePicture != null
                          ? profilePicture.startsWith('http')
                              ? NetworkImage(profilePicture)
                              : MemoryImage(base64Decode(profilePicture)) as ImageProvider
                          : null,
                      backgroundColor: Colors.white,
                      child: profilePicture == null
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    // Name on the right
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Website Button
          ListTile(
            leading: const Icon(Icons.web, color: Colors.blueAccent),
            title: const Text(
              'Visit our official website',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: _launchURL,
          ),
        ],
      ),
    );
  }
}
