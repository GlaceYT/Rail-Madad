import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_content.dart'; // Import the content widget
import 'preview.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  XFile? _imageFile;
  Uint8List? _imageData;
  String? _imageBase64;

  // Create secure storage instance
  final _secureStorage = const FlutterSecureStorage();

  Future<void> _saveUserData(String token, Map<String, dynamic> user) async {
    // Save token securely in flutter_secure_storage
    await _secureStorage.write(key: 'token', value: token);

    // Save other user data in shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user['username']);
    await prefs.setString('email', user['email']);
    await prefs.setString('phoneNumber', user['phoneNumber']);
    await prefs.setString('name', user['name']);
    await prefs.setString('profilePicture', user['profilePicture']);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      setState(() {
        _errorMessage = "Please complete all fields and upload a profile picture.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text;
    final username = _usernameController.text;
    final email = _emailController.text;
    final phoneNumber = _phoneController.text;
    final password = _passwordController.text;

    try {
      // Convert image to base64 for mobile if not already done
      if (_imageBase64 == null && _imageFile != null && !kIsWeb) {
        final bytes = await File(_imageFile!.path).readAsBytes();
        _imageBase64 = base64Encode(bytes);
      }

      final response = await http.post(
        Uri.parse('http://utopia.pylex.xyz:10838/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'profilePicture': _imageBase64,  // Send base64-encoded image
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];  // Retrieve the token from the response
        final user = data['user'];    // Retrieve the user details from the response

        // Save user data and token securely
        await _saveUserData(token, user);

        // Navigate to another screen after successful registration
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PreviewScreen()),
        );
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _errorMessage = data['message'];
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error registering user';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });

      if (kIsWeb) {
        // For web, convert the image to base64 and display
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _imageData = bytes;
          _imageBase64 = base64Encode(bytes);
        });
      } else {
        // For mobile, store the image bytes for display
        final fileBytes = await File(pickedImage.path).readAsBytes();
        setState(() {
          _imageData = fileBytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SignUpContent(
        formKey: _formKey,
        nameController: _nameController,
        usernameController: _usernameController,
        emailController: _emailController,
        passwordController: _passwordController,
        phoneController: _phoneController,
        imageData: _imageData,
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        onPickImage: _pickImage,
        onRegister: _register,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}