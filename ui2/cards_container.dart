import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing JSON
import 'dart:math'; // For generating random numbers
import '../tab1ui/complaints_page.dart';

class CardsContainer extends StatefulWidget {
  const CardsContainer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardsContainerState createState() => _CardsContainerState();
}

class _CardsContainerState extends State<CardsContainer> {
  String? imageUrl; // Variable to store the random image URL
  bool _isLoading = true; // To track if the image is being fetched
  final String fallbackText = "RailEase"; // Fallback text when loading image
  final String unsplashProfile = 'shiva_reddy'; // Your Unsplash username
  final String accessKey = 'qPDG3_ry-OWjCRqvC60khZmd6N1EaGZtLPrUXgiXbqQ'; // Unsplash API key

  @override
  void initState() {
    super.initState();
    fetchRandomUnsplashImage(); // Fetch new random image from Unsplash
  }

  // Fetch a random image from the Unsplash user profile
  Future<void> fetchRandomUnsplashImage() async {
    final String url = 'https://api.unsplash.com/users/$unsplashProfile/photos?client_id=$accessKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // If data contains images, select a random one
        if (data.isNotEmpty) {
          final randomIndex = Random().nextInt(data.length); // Get random image index
          final randomImageUrl = data[randomIndex]['urls']['regular'];

          setState(() {
            imageUrl = randomImageUrl;
            _isLoading = false; // Image is loaded, stop showing loader
          });
        } else {
          throw Exception('No images found in the response');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching image: $e');
      setState(() {
        _isLoading = false; // Stop loader even if error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 1), // Space between top and header

            // Display fallback text first, then image once loaded
            _isLoading
                ? const Text(
                    "RailEase",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : (imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        height: screenWidth * 0.15, // Adjust height relative to screen width
                        width: screenWidth * 0.4, // Adjust width relative to screen width
                        fit: BoxFit.cover,
                      )
                    : const Text(
                        "RailEase", // Show fallback text if image URL is null
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),

            const SizedBox(height: 10), // Space between the image and the first row of cards

            // Expanded GridView for cards
            Expanded(
              child: GridView.count(
                crossAxisCount: screenWidth > 600 ? 3 : 2, // Responsive number of columns
                crossAxisSpacing: 16, // Gap between columns
                mainAxisSpacing: 16, // Gap between rows
                children: <Widget>[
                  _buildGridItem(
                    context,
                    'Complaints',
                    Icons.warning_rounded,
                    'View your registered complaints',
                    color: const Color.fromARGB(255, 255, 103, 56),
                    gradientColors: [Colors.orangeAccent, Colors.redAccent],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ComplaintsPage()),
                      );
                    },
                  ),
                  _buildGridItem(
                    context,
                    'Track Train',
                    Icons.train_rounded,
                    'Keep an eye on your train\'s location',
                    color: const Color.fromARGB(255, 8, 199, 180),
                    gradientColors: [const Color.fromARGB(255, 32, 185, 185), Colors.teal],
                  ),
                  _buildGridItem(
                    context,
                    'Train Booking',
                    Icons.confirmation_num_rounded,
                    'Book your tickets easily and quickly',
                    color: const Color.fromRGBO(56, 107, 245, 1),
                    gradientColors: [Colors.lightBlueAccent, Colors.blueAccent],
                  ),
                  _buildGridItem(
                    context,
                    'Alerts',
                    Icons.notifications_rounded,
                    'Get real-time notifications and alerts',
                    color: Colors.purpleAccent,
                    gradientColors: [Colors.purpleAccent, Colors.deepPurple],
                  ),
                  _buildGridItem(
                    context,
                    'Women Safety',
                    Icons.shield_rounded,
                    'Ensure your safety with us',
                    color: Colors.pinkAccent,
                    gradientColors: [Colors.pinkAccent, Colors.redAccent],
                  ),
                  _buildGridItem(
                    context,
                    'FAQ',
                    Icons.help_rounded,
                    'Frequently Asked Questions',
                    color: const Color.fromARGB(210, 118, 176, 66),
                    gradientColors: [const Color.fromARGB(255, 128, 195, 53), const Color.fromARGB(255, 110, 234, 174)],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5), // Space between the grid and the bottom of the screen
          ],
        ),
      ),
    );
  }

  // Helper function to create grid items with onTap and custom gradient
  Widget _buildGridItem(BuildContext context, String title, IconData icon, String subtitle,
      {VoidCallback? onTap, Color color = Colors.blueAccent, required List<Color> gradientColors}) {
    return GestureDetector(
      onTap: onTap, // Enable tapping to trigger the callback
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors, // Gradient background using provided colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16), // Rounded corners for modern look
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2), // Subtle shadow for elevation
              blurRadius: 8,
              offset: const Offset(2, 4), // Slight offset for shadow effect
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Text
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis, // Ellipsis for long text
                  ),
                  const SizedBox(height: 8),
                  // Subtitle Text
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    maxLines: 2, // Allow up to 2 lines for subtitle
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              // Positioned Icon at the bottom-right
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(icon, size: 48, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
