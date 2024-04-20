import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:projetppd_2/EnlargedImageScreen.dart';

import 'EnlargedImageScreen.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  int _unreadMessagesCount =
      0; // Variable to keep track of unread messages count
  List<Map<String, dynamic>> _messages = []; // List to store messages
  final _textController = TextEditingController();
  File _imageFile = File(''); // Variable to store image file (initially empty)

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Add initial message from admin when the widget is first created
    final adminMessage = {
      'message': 'Welcome to AIDNOW, how can we help you?',
      'time': DateFormat('hh:mm a').format(DateTime.now()),
      'sender': 'AIDNOW', // Specify sender as 'AIDNOW'
    };
    _messages.add(adminMessage);
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _unreadMessagesCount = 1; // Set unread messages count to 1
      });
    }
  }

  void _sendMessage(String message) async {
    // Implement message sending logic here (e.g., send to server)

    if (message.isNotEmpty || _imageFile.path.isNotEmpty) {
      // Send message or image
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(now);

      if (message.isNotEmpty) {
        setState(() {
          _messages.add({
            'message': message,
            'time': formattedTime,
            'sender': 'You'
          }); // Set sender as 'You' for user messages
          _textController.clear();
        });
      } else if (_imageFile.path.isNotEmpty) {
        // Send image using _imageFile.path
        final response = await sendImage(_imageFile);
        if (response.success) {
          setState(() {
            _messages.add({
              'image': _imageFile.path,
              'sender': 'You'
            }); // Set sender as 'You' for user images
            _imageFile = File(''); // Reset image file after sending
            _unreadMessagesCount =
                0; // Reset unread messages count after sending image
          });
        } else {
          // Handle image sending error (e.g., show a snackbar)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending image: ${response.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<ImageSendingResponse> sendImage(File imageFile) async {
    // Implement your image sending logic here (e.g., upload to server)
    // Replace this with your actual image sending code
    final response = ImageSendingResponse(
        success: true, error: null); // Example successful response
    // You can modify the response object to include error details if needed
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'icons/1976784.png', // Replace 'icon.png' with the path to your image file
              width: 40, // Adjust the width of the image as needed
              height: 40, // Adjust the height of the image as needed
            ),
            const SizedBox(
                width: 10), // Add spacing between the image and the text
            const Text(
              'AIDNOW',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        toolbarHeight: 100.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              // Make message list scrollable
              child: ListView.builder(
                reverse: false, // Display newest messages on top
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index]['message'];
                  final time = _messages[index]['time'];
                  final image = _messages[index]['image'];
                  final sender = _messages[index]['sender'];
                  return Column(
                    crossAxisAlignment: sender == 'AIDNOW'
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment
                            .end, // Align messages to left for admin, right for user
                    children: [
                      Row(
                        mainAxisAlignment: sender == 'You'
                            ? MainAxisAlignment.end
                            : MainAxisAlignment
                                .start, // Align messages to right for user, left for admin
                        children: [
                          if (image != null)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EnlargedImageScreen(imagePath: image),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: Image.file(File(image)),
                              ),
                            ),
                          if (message != null)
                            // Display text message if present
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: sender == 'You'
                                    ? Color.fromARGB(255, 255, 0, 0)
                                    : Colors
                                        .blue, // Different color for admin's messages
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message,
                                    maxLines: null, // Enable line breaks
                                    softWrap:
                                        true, // Wrap text within the container
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: sender == 'AIDNOW'
                                            ? FontWeight.bold
                                            : FontWeight
                                                .normal), // Bold font for admin's messages
                                  ),
                                  const SizedBox(
                                      height:
                                          4.0), // Add spacing between message and time
                                  Text(time,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              12.0)), // Display time with smaller font
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (sender == 'AIDNOW')
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            sender ??
                                'Unknown', // Display sender's name or 'Unknown' if sender is not specified
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      if (sender ==
                          'You') // Display 'You' only when the sender is the user
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'You', // You positioned below the message
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _pickImage(),
                            icon: Icon(Icons.camera_alt),
                          ),
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _sendMessage(_textController.text),
                                icon: Icon(Icons.send),
                              ),
                              if (_unreadMessagesCount > 0)
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 8,
                                    child: Text(
                                      '$_unreadMessagesCount',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onSubmitted: (text) => _sendMessage(
                        text), // Handle message submission on enter press
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSendingResponse {
  final bool success;
  final String? error;

  const ImageSendingResponse({required this.success, this.error});
}
