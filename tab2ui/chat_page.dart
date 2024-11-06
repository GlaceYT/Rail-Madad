import 'dart:convert';
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  late String _directLineSecret;
  late String _conversationId;
  late String _watermark;
  late String _directLineToken;
  Timer? _pollingTimer;
  late String _name;
  late String _username;
  late String _email;
  late String _phoneNumber;
  late String _villageOrCity;
  late String _district;
  late String _state;
  late String _userId;
  @override
  void initState() {
    super.initState();
    _directLineSecret = 'BZAdvQzILg0.6QqZBdPo_Nt7d2x3nRGL9OlDVvdBgoKBMsRAPOQDk3M';
    _loadUserInfo();
    _generateUserId();
    _generateTokenAndStartConversation();
  }
   void _generateUserId() {
    _userId = 'user_${DateTime.now().millisecondsSinceEpoch}'; // Unique ID for each session
  }
  Future<void> _generateTokenAndStartConversation() async {
    try {
      final response = await http.post(
        Uri.parse('https://directline.botframework.com/v3/directline/tokens/generate'),
        headers: {
          'Authorization': 'Bearer $_directLineSecret',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        _directLineToken = jsonResponse['token'];

        await _startConversationWithToken();
      } else {
        throw Exception('Failed to generate token: ${response.statusCode}');
      }
    } catch (error) {
      _handleError("Error generating token", error);
    }
  }

  Future<void> _startConversationWithToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://directline.botframework.com/v3/directline/conversations'),
        headers: {
          'Authorization': 'Bearer $_directLineToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        _conversationId = jsonResponse['conversationId'];
        _watermark = '';

        setState(() {
          _isLoading = false;
        });

        _startPolling();

        _sendMessage("Connected to the Chat!");
      } else {
        throw Exception('Failed to start conversation: ${response.statusCode}');
      }
    } catch (error) {
      _handleError("Error initializing chat", error);
    }
  }

  Future<void> _sendMessage(String message) async {
    if (_conversationId.isEmpty) {
      Fluttertoast.showToast(msg: "Chat is not initialized");
      return;
    }

    setState(() {
      _messages.add({"sender": "user", "message": message, "isImage": false});
    });

    try {
      final response = await http.post(
        Uri.parse('https://directline.botframework.com/v3/directline/conversations/$_conversationId/activities'),
        headers: {
          'Authorization': 'Bearer $_directLineToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'message',
          'from': {'id': _userId},
          'text': message,
                   'channelData': {
            'name': _name,
            'username': _username,
            'email': _email,
            'phoneNumber': _phoneNumber,
            'villageOrCity': _villageOrCity,
            'district': _district,
            'state': _state,
          },
        }),
      );

      if (response.statusCode != 201) {
        //print('Failed to send message: ${response.reasonPhrase}');
      }
    } catch (error) {
      //print("Error sending message: $error");
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _pollForMessages();
    });
  }

  Future<void> _pollForMessages() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://directline.botframework.com/v3/directline/conversations/$_conversationId/activities?watermark=$_watermark'),
      headers: {
        'Authorization': 'Bearer $_directLineToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final activities = jsonResponse['activities'];

      if (activities != null && activities.isNotEmpty) {
        for (var activity in activities) {
          // Only add bot messages to the list (skip user messages)
          if (activity['from']['id'] != _userId) {  // Ensure it is not the user's message
            setState(() {
              _messages.add({"sender": "bot", "message": activity['text'], "isImage": false});
            });
          }
        }
        _watermark = jsonResponse['watermark'];
      }
    } else {
      // Handle polling failure
    }
  } catch (error) {
    // Handle polling error
  }
}


  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        _uploadToServer(bytes, pickedFile.name);  // Web file upload
      } else {
        final file = io.File(pickedFile.path);
        _uploadToServer(await file.readAsBytes(), file.path);  // Mobile file upload
      }
    }
  }

// Modified _uploadToServer method
Future<void> _uploadToServer(Uint8List imageBytes, String fileName) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:5000/upload'), // Your upload URL
    );
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: fileName,
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var imageUrl = jsonDecode(responseData)['url'];

      // Send the image URL to the bot
      await _sendImageToBot(imageUrl, fileName);
      
      // Store the image in local messages for UI display
      setState(() {
        _messages.add({"sender": "user", "message": imageUrl, "isImage": true});
      });
    } else {
      //print("Failed to upload image: ${response.reasonPhrase}");
    }
  } catch (error) {
    //print("Error uploading image: $error");
  }
}
Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _username = prefs.getString('username') ?? '';
      _email = prefs.getString('email') ?? '';
      _phoneNumber = prefs.getString('phoneNumber') ?? '';
      _villageOrCity = prefs.getString('villageOrCity') ?? 'Unknown Village/Town';
      _district = prefs.getString('district') ?? 'Unknown District';
      _state = prefs.getString('state') ?? 'Unknown State';
      //print(" ✅ Retrieved location: $_villageOrCity, $_district, $_state");
    });
  }
// Modified _sendImageToBot method
Future<void> _sendImageToBot(String imageUrl, String fileName) async {
  try {
    String contentType = 'image/png'; // Default content type

    // Determine the content type based on the file extension
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      contentType = 'image/jpeg';
    } else if (fileName.endsWith('.gif')) {
      contentType = 'image/gif';
    } else if (fileName.endsWith('.bmp')) {
      contentType = 'image/bmp';
    }
    
    final response = await http.post(
      Uri.parse('https://directline.botframework.com/v3/directline/conversations/$_conversationId/activities'),
      headers: {
        'Authorization': 'Bearer $_directLineToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'type': 'message',
       'from': {'id': _userId},
        'text': '[image]',
         'channelData': {
            'name': _name,
            'username': _username,
            'email': _email,
            'phoneNumber': _phoneNumber,
            'villageOrCity': _villageOrCity,
            'district': _district,
            'state': _state,
          },
        'attachments': [
          {
            'contentType': contentType, // Use the dynamic content type
            'contentUrl': imageUrl,      // Flask server URL
          }
        ]
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _messages.add({"sender": "bot", "message": "Image received", "isImage": true});
      });
    } else {
      //print("Failed to send image: ${response.reasonPhrase}");
    }
  } catch (error) {
    //print("Error sending image: $error");
  }
}


  void _handleError(String message, dynamic error) {
    setState(() {
      _isLoading = false;
    });
    //print("$message: $error");
    Fluttertoast.showToast(msg: "$message: $error");
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit Chat"),
        content: const Text("Are you sure you want to close the chat?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Close the screen
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat With AI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _confirmExit, // Confirm before exiting
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      bool isUser = message['sender'] == 'user';
                      bool isImage = message['isImage'] ?? false;
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isUser)
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                    'https://cdn.discordapp.com/emojis/974290321972273212.gif'),
                              ),
                            if (!isUser) const SizedBox(width: 10),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isUser ? Colors.blue[100] : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10),
                                    topRight: const Radius.circular(10),
                                    bottomLeft: isUser ? const Radius.circular(0) : const Radius.circular(10),
                                    bottomRight: isUser ? const Radius.circular(10) : const Radius.circular(0),
                                  ),
                                ),
                                child: isImage
                                      ? Image.network(
                                      Uri.encodeFull(message['message']), // Encode the URL
                                      width: 150,
                                      errorBuilder: (context, error, stackTrace) {
                                      return const Text('Failed to load image', style: TextStyle(color: Colors.red));
                                      },
                                      )
                                    : Text(
                                        message['message'],
                                        style: TextStyle(
                                          color: isUser ? Colors.blue[900] : Colors.black,
                                        ),
                                      ),
                              ),
                            ),
                            if (isUser) const SizedBox(width: 10),
                            if (isUser)
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                    'https://cdn.discordapp.com/emojis/834706988003753994.gif'),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickMedia, 
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
