import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  String? name;
  String? username;
  String? email;
  String? phoneNumber;
  String? profilePicture;

  bool isEditingName = false;
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingPhoneNumber = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
      profilePicture = prefs.getString('profilePicture');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profilePicture != null
                  ? profilePicture!.startsWith('http')
                      ? NetworkImage(profilePicture!)
                      : MemoryImage(base64Decode(profilePicture!)) as ImageProvider
                  : null,
              backgroundColor: Colors.orange,
              child: profilePicture == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 16),

            // Name field with title
            _buildInfoField(
              context,
              icon: Icons.person,
              title: 'Name',
              value: name ?? 'Not provided',
              isEditing: isEditingName,
              onEditPressed: () => setState(() {
                isEditingName = !isEditingName;
              }),
              controller: nameController,
            ),
            const SizedBox(height: 16),

            // Username field with title
            _buildInfoField(
              context,
              icon: Icons.account_circle,
              title: 'Username',
              value: username ?? 'Not provided',
              isEditing: isEditingUsername,
              onEditPressed: () => setState(() {
                isEditingUsername = !isEditingUsername;
              }),
              controller: usernameController,
            ),
            const SizedBox(height: 16),

            // Email field with title
            _buildInfoField(
              context,
              icon: Icons.email,
              title: 'Email',
              value: email ?? 'Not provided',
              isEditing: isEditingEmail,
              onEditPressed: () => setState(() {
                isEditingEmail = !isEditingEmail;
              }),
              controller: emailController,
            ),
            const SizedBox(height: 16),

            // Phone number field with title
            _buildInfoField(
              context,
              icon: Icons.phone,
              title: 'Phone Number',
              value: phoneNumber ?? 'Not provided',
              isEditing: isEditingPhoneNumber,
              onEditPressed: () => setState(() {
                isEditingPhoneNumber = !isEditingPhoneNumber;
              }),
              controller: phoneNumberController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool isEditing,
    required VoidCallback onEditPressed,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange), // Left icon
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              isEditing
                  ? TextField(
                      controller: controller..text = value,
                      decoration: InputDecoration(
                        hintText: 'Enter $title',
                      ),
                    )
                  : Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.grey), // Change icon to check when editing
          onPressed: onEditPressed, // Toggle between edit and view mode
        ),
      ],
    );
  }
}