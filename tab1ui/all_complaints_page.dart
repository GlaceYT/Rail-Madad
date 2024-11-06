import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'complaints_details_page.dart'; // Import the complaint details page

class ComplaintsDetailPage extends StatefulWidget {
  const ComplaintsDetailPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintsDetailPageState createState() => _ComplaintsDetailPageState();
}

class _ComplaintsDetailPageState extends State<ComplaintsDetailPage> {
  List<Map<String, dynamic>> complaintsList = [];
  String? name;
  String? username;
  String? email;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadPersonalInfo();
  }

  Future<void> _loadPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      username = prefs.getString('username');
      email = prefs.getString('email');
      phoneNumber = prefs.getString('phoneNumber');
    });

    if (username != null && username!.isNotEmpty) {
      await _fetchComplaints();
    }
  }

  Future<void> _fetchComplaints() async {
    if (username == null || username!.isEmpty) {
      return;
    }

    final url = Uri.parse('http://meta.pylex.xyz:10927/api/complaints/user?username=$username');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          complaintsList = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _navigateToComplaintDetails(BuildContext context, Map<String, dynamic> complaint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetailsPage(
          title: complaint['complaint_type'] ?? 'Complaint',
          referenceId: complaint['reference_id']?.toString() ?? 'Reference ID not provided',
          location: complaint['location'] ?? 'Location not provided',
          urgency: complaint['urgency'] ?? 'Urgency not specified',
          status: complaint['status'] ?? 'Unknown',
          media: complaint['media'] ?? [],
          name: complaint['name'] ?? 'Name not provided',
          username: complaint['username'] ?? 'Username not provided',
          email: complaint['email'] ?? 'Email not provided',
          phoneNumber: complaint['phone_number'] ?? 'Phone number not provided',
          pnr: complaint['pnr'] ?? 'PNR not provided',
          complaint: complaint['complaint'] ?? 'No complaint details available',
          complaintType: complaint['complaint_type'] ?? 'Type not specified',
          subCategory: complaint['sub_category'] ?? 'Sub-category not specified',
          additionalDetails: complaint['additional_details'] ?? 'No additional details available',
          villageOrCity: complaint['villageOrCity'] ?? 'Village/City not provided',
          district: complaint['district'] ?? 'District not provided',
          state: complaint['state'] ?? 'State not provided',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Complaints'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Enhanced app bar color
      ),
      body: complaintsList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: complaintsList.length,
              itemBuilder: (context, index) {
                final complaint = complaintsList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      _navigateToComplaintDetails(context, complaint);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6, // Increased elevation for better shadow effect
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color.fromARGB(255, 97, 97, 97), Color.fromARGB(255, 63, 62, 62)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              complaint['complaint_type'] ?? 'Complaint',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              complaint['complaint'] is List
                                  ? complaint['complaint'].join(", ")
                                  : complaint['complaint'] ?? 'No complaint details available',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Status Indicator
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 500),
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: complaint['status'] == 'open' ? Colors.greenAccent : Colors.redAccent,
                                        boxShadow: complaint['status'] == 'open'
                                            ? [const BoxShadow(color: Colors.greenAccent, blurRadius: 10)]
                                            : [const BoxShadow(color: Colors.redAccent, blurRadius: 10)],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Status: ${complaint['status'] ?? "Unknown"}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Reference ID: ${complaint['reference_id'] ?? "N/A"}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
