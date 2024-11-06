import 'package:flutter/material.dart';
import './all_complaints_page.dart'; // Import the new detail page
import '../tab2ui/chat_page.dart';
class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // AppBar color
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Padding around the body
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16), // Space between the title and cards
              ChatWithAiCard(), // First card
              SizedBox(height: 16), // Space between cards
              RegisteredComplaintsCard(), // Second card
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100], // Subtle background color
    );
  }
}

class ChatWithAiCard extends StatelessWidget {
  const ChatWithAiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Page2(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
        ),
        elevation: 5.0, // Shadow for depth
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 57, 227, 187), Colors.blueAccent], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 40.0,
                color: Colors.white, // Icon color
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chat with AI Rail Madad',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Talk with our next-gen AI Assistant.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisteredComplaintsCard extends StatelessWidget {
  const RegisteredComplaintsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ComplaintsDetailPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ComplaintsDetailPage(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
        ),
        elevation: 5.0, // Shadow for depth
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepPurple], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Row(
            children: [
              Icon(
                Icons.list_alt_outlined,
                size: 40.0,
                color: Colors.white, // Icon color
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Registered Complaints',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'View and manage your registered complaints.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
