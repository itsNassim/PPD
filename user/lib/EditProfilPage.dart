import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _email = "";
  String _region = "";
  DateTime _selectedDate = DateTime.now();
  late ImagePicker _picker; // ImagePicker instance
  File? _avatarImage; // Variable to hold the selected image

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker(); // Initialize ImagePicker
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // Update the avatar image with the selected image from gallery
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 100.0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Call _pickImage function when tapped
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: const Color.fromARGB(255, 255, 223, 223),
                      // Update the image based on user's selection
                      backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : AssetImage('icons/verification-de-lutilisateur.png') as ImageProvider<Object>,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80), // Add spacing
              TextFormField(
                initialValue: _username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (newValue) => _username = newValue ?? "", // Save value
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress, // Email keyboard
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (newValue) => _email = newValue ?? "", // Save value
              ),
              const SizedBox(height: 10), // Add spacing
              TextFormField(
                initialValue: _region,
                decoration: const InputDecoration(
                  labelText: 'Wilaya',
                ),
                onSaved: (newValue) => _region = newValue ?? "",
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Birthday: '),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      DateFormat('y MMMM d').format(_selectedDate).toString(),
                      style: const TextStyle(color: Color.fromARGB(255, 120, 13, 11)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        debugPrint('Username: $_username, Email: $_email, Region: $_region, Birthday: $_selectedDate');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}