import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';

class SignUpContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final Uint8List? imageData; // Image data to display
  final String? errorMessage;
  final bool isLoading;
  final VoidCallback onPickImage;
  final VoidCallback onRegister;

  const SignUpContent({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    this.imageData,
    this.errorMessage,
    required this.isLoading,
    required this.onPickImage,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Circles
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 8, 199, 180), // Top circle color
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 255, 103, 56), // Bottom circle color
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3b3b3b), // Black container color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Title color white
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Create an account to continue.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // Subtitle color white
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: onPickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: imageData != null
                                ? MemoryImage(imageData!)
                                : null,
                            child: imageData == null
                                ? const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: nameController,
                          label: 'Name',
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: usernameController,
                          label: 'Username',
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: emailController,
                          label: 'Email',
                        ),
                          const SizedBox(height: 16),
                        _buildInputField(
                          controller: phoneController,
                          label: 'Phone Number',
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: passwordController,
                          label: 'Password',
                          obscureText: true,
                        ),
                      
                        const SizedBox(height: 20),
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading ? null : onRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF715CF8), // Same color as login button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white), // White text inside input
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFF8F8E8E), // Input box color same as login page
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}