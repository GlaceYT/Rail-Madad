import 'package:flutter/material.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final String title;
  final String referenceId;
  final String location;
  final String urgency;
  final String status;
  final List<dynamic> media; // List to hold media files
  final String name; // User's name
  final String username; // User's username
  final String email; // User's email
  final String phoneNumber; // User's phone number
  final String pnr; // PNR information
  final String complaint; // Complaint details
  final String complaintType; // Type of the complaint
  final String subCategory; // Sub-category of the complaint
  final String additionalDetails; // Additional details
  final String villageOrCity;
  final String district;
  final String state;
  // Constructor to pass complaint details
  const ComplaintDetailsPage({
    super.key,
    required this.title,
    required this.referenceId,
    required this.location,
    required this.urgency,
    required this.status,
    required this.media,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.pnr,
    required this.complaint,
    required this.complaintType,
    required this.subCategory,
    required this.additionalDetails,
    required this.villageOrCity,
    required this.district,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Complaint type as title
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Top Section with important details in a Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reference ID: $referenceId',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('PNR: $pnr', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Complaint Type: $complaintType', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Sub-Category: $subCategory', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Status: $status', style: const TextStyle(fontSize: 16, color: Colors.green)),
                    const SizedBox(height: 8),
                    Text('Urgency: $urgency', style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
                    const SizedBox(height: 8),
                    Text('Village or City: $villageOrCity', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('District: $district', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('State: $state', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Complaint Details in a Grid-like responsive layout
            screenWidth > 600
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Complaint Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Location: $location'),
                            const SizedBox(height: 4),
                            Text('Complaint: $complaint'),
                            const SizedBox(height: 4),
                            Text('Additional Details: $additionalDetails'), // Moved additional details here
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Complaint Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Location: $location'),
                      const SizedBox(height: 4),
                      Text('Complaint: $complaint'),
                      const SizedBox(height: 4),
                      Text('Additional Details: $additionalDetails'), // Moved additional details here
                    ],
                  ),

            const SizedBox(height: 16),

            // User Information Section
            const Text('User Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $name'),
                    const SizedBox(height: 4),
                    Text('Username: $username'),
                    const SizedBox(height: 4),
                    Text('Email: $email'),
                    const SizedBox(height: 4),
                    Text('Phone Number: $phoneNumber'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Media Section
            const Text('Media Attached:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            media.isEmpty
                ? const Text('No media attached.')
                : Column(
                    children: media.map<Widget>((file) {
                      if (file is Map<String, dynamic>) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (file['type'].startsWith('image/'))
                                    Column(
                                      children: [
                                        Image.network(file['url'], width: 200), // Displaying image
                                        Text('Summary: ${file['summary'] ?? 'No summary available.'}'),
                                      ],
                                    ),
                                  if (file['type'].startsWith('audio/'))
                                    Column(
                                      children: [
                                        AudioPlayerWidget(url: file['url']),
                                        const SizedBox(height: 4),
                                        Text('Transcript: ${file['transcript'] ?? 'No transcript available.'}'),
                                      ],
                                    ),
                                  if (file['type'].startsWith('video/'))
                                    Column(
                                      children: [
                                        VideoPlayerWidget(url: file['url']),
                                        const SizedBox(height: 4),
                                        Text('Transcript: ${file['transcript'] ?? 'No transcript available.'}'),
                                      ],
                                    ),
                                  const SizedBox(height: 4),
                                  TextButton(
                                    onPressed: () {
                                      // Open media in new tab or appropriate action
                                    },
                                    child: const Text('View Media'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(file.toString()), // Convert complex types to string
                        );
                      }
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

// Dummy widgets for audio and video players
class AudioPlayerWidget extends StatelessWidget {
  final String url;
  const AudioPlayerWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Audio Player:'),
        // Replace this with your audio player implementation
        Text('Playing audio from: $url'),
      ],
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Video Player:'),
        // Replace this with your video player implementation
        Text('Playing video from: $url'),
      ],
    );
  }
}
