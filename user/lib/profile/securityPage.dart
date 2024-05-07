import 'package:flutter/material.dart';
import 'package:projetppd_2/pages/pages.dart';
import 'ChangePasswordPage.dart';
import 'package:http/http.dart' as http;
import 'package:projetppd_2/login-signup/http_request.dart' as http_request;

class SecuritySettingsScreen extends StatelessWidget {
  final String email; // Declare email variable

  SecuritySettingsScreen({required this.email});
  Future<void> deleteAccount(BuildContext context) async {
    // Your Django server URL
    String baseUrl = 'http://10.0.2.2:8000/authentication';
    String token = (await http_request.getToken())!;

    try {
      // Make a POST request to the deleteAccount endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/deleteUser/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      if (response.statusCode == 204) {
        http_request.logout();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account deleted successfully.'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Navigation()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account. Please try again.'),
          ),
        );
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error deleting user account: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Recover Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangePasswordPage(email: email), // Pass the email here
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content:
                        Text('Are you sure you want to delete your account?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => deleteAccount(context),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
