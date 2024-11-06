import 'package:flutter/material.dart';
import 'cards_container.dart'; // Import the cards container
import 'location_widget.dart';
import '../tab2ui/chat_page.dart'; // Import the chat page
import 'drawer_widget.dart';

class Tab1 extends StatelessWidget {
  const Tab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      body: const SafeArea( // Wrap in SafeArea to avoid content going under the notification bar
        child: Column(
          children: [
            LocationWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0), // Add horizontal padding
                child: CardsContainer(), // Use the CardsContainer component here
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page2()), // Navigate to ChatPage
          );
        },
        tooltip: 'AI Chat',
        backgroundColor: const Color.fromARGB(255, 0, 251, 255), // Vibrant background color
        elevation: 10, // Add more elevation for shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Add custom rounded corners
        ),
        child: const Icon(
          Icons.chat_bubble_outline_rounded, // Stylish chat icon
          size: 28, // Increase the icon size
        ),
      ),
    );
  }
}
