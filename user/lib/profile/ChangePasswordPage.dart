import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetppd_2/pages/pages.dart';

Future<void> changePassword(
    String email, String newPassword, BuildContext context) async {
  final String apiUrl = 'http://10.0.2.2:8000/authentication/restpassword/';

  final response = await http.post(
    Uri.parse(apiUrl),
    body: {
      'email': email,
      'new_password': newPassword,
    },
  );

  if (response.statusCode == 200) {
    // Password reset successful
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password changed successfully'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navigation()),
    );
  } else if (response.statusCode == 404) {
    // User not found
    throw Exception('User not found');
  } else if (response.statusCode == 400) {
    // Invalid password
    throw Exception('Invalid password');
  } else {
    // Handle other status codes
    throw Exception('Failed to change password');
  }
}

class ChangePasswordPage extends StatefulWidget {
  final String email; // Add email parameter to the widget

  const ChangePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String newPassword = '';
  String confirmPassword = '';
  bool _obscureTextConfirm = true;
  bool _isButtonDisabled = true;
  late String email; // Declare email variable

  @override
  void initState() {
    super.initState();
    email = widget.email; // Assign widget.email to email variable in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        toolbarHeight: 50.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('lib/assets/passwordrec.png',
                  height: 150, width: 100),
              const SizedBox(height: 30),
              // Error message for new password
              if (newPassword.isEmpty)
                Text(
                  'Please enter a new password',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),

              // New password field
              TextFormField(
                obscureText: _obscureTextConfirm,
                onChanged: (value) {
                  setState(() {
                    newPassword = value;
                    _isButtonDisabled =
                        newPassword.isEmpty || newPassword != confirmPassword;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirm = !_obscureTextConfirm;
                      });
                    },
                  ),
                ),
              ),
              if (newPassword.isNotEmpty && newPassword != confirmPassword)
                Text(
                  'Passwords do not match',
                  style: TextStyle(color: Colors.red),
                ),
              if (newPassword.length < 8)
                Text(
                  'Password must be at least 8 characters long',
                  style: TextStyle(color: Colors.red),
                ),
              if (!newPassword.contains(RegExp(r'[A-Z]')))
                Text(
                  'Password must contain at least one uppercase letter',
                  style: TextStyle(color: Colors.red),
                ),
              if (!newPassword.contains(RegExp(r'[a-z]')))
                Text(
                  'Password must contain at least one lowercase letter',
                  style: TextStyle(color: Colors.red),
                ),
              if (!newPassword.contains(RegExp(r'[0-9]')))
                Text(
                  'Password must contain at least one digit',
                  style: TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 10),

              // Confirm password field
              TextFormField(
                obscureText: _obscureTextConfirm,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                    _isButtonDisabled =
                        newPassword.isEmpty || newPassword != confirmPassword;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirm = !_obscureTextConfirm;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        setState(() {
                          newPassword = confirmPassword;
                        });
                        changePassword(email, newPassword, context)
                            .catchError((error) {
                          _showMessageDialog(error.toString());
                        });
                      },
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
