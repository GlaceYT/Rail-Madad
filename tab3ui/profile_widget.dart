import 'dart:convert';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final String username;
  final String? profilePicture;

  const ProfileWidget({
    super.key,
    required this.name,
    required this.username,
    this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch screen width to adjust sizes dynamically
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Space around the profile
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image with gradient border similar to Instagram
          Container(
            width: screenWidth * 0.22, // Set width relative to screen size
            height: screenWidth * 0.22, // Set height relative to screen size
            padding: const EdgeInsets.all(3), // Border width
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.orange],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.10, // Adjust size responsively
              backgroundColor: Colors.grey[300], // Placeholder background color
              backgroundImage: profilePicture != null
                  ? MemoryImage(base64Decode(profilePicture!)) // Base64 image
                  : null,
              child: profilePicture == null
                  ? Icon(
                      Icons.person, // Placeholder icon
                      size: screenWidth * 0.10, // Adjust icon size responsively
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 20), // Space between image and text
          // Box around Name and username
          Expanded( // Allows text to adjust based on available space
            child: Container(
              padding: const EdgeInsets.all(10), // Add padding inside the box
              decoration: BoxDecoration(
                color: Colors.white, // White background for the box
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Subtle shadow for depth
                    blurRadius: 6,
                    offset: Offset(2, 4), // Shadow positioning
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name text
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.07, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Handle overflow text gracefully
                  ),
                  const SizedBox(height: 2), // Reduced spacing between name and username
                  // Username text
                  Text(
                    '@$username', // Use "@" before the username
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Responsive font size for username
                      color: Colors.grey[600], // Lighter color for username
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Handle long usernames gracefully
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
