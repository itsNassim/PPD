import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projetppd_2/login-signup/http_request.dart' as http_request;
import 'package:projetppd_2/pages/pages.dart';
import 'securityPage.dart';
import 'aboutPage.dart';
import '_profilePage.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              http_request.logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Navigation()),
              );
            },
          ),
        ],
      ),
      body: SettingsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  String baseUrl =
      'http://10.0.2.2:8000/authentication'; // Replace with your actual base URL
  String token = ''; // Initialize with empty string
  Map<String, dynamic> userData = {}; // Initialize userData map
  Map<String, dynamic> personData = {}; // Initialize userData map
  Map<String, dynamic> appuserData = {}; // Initialize userData map

  @override
  void initState() {
    super.initState();
    getTokenAndFetchData(); // Call function to get token and fetch data
  }

  Future<void> getTokenAndFetchData() async {
    // Call the function to obtain the token here
    token = (await http_request
        .getToken())!; // Replace getToken() with your actual method
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final responseuser = await http.get(
        Uri.parse('$baseUrl/getUserInfo/'),
        headers: {'Authorization': 'Token $token'},
      );

      final responseperson = await http.get(
        Uri.parse('$baseUrl/getPersonInfo/'),
        headers: {'Authorization': 'Token $token'},
      );

      final responseappuser = await http.get(
        Uri.parse('$baseUrl/getAppUserInfo/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (responseuser.statusCode == 200 &&
          responseperson.statusCode == 200 &&
          responseappuser.statusCode == 200) {
        setState(() {
          userData = json.decode(responseuser.body);
          personData = json.decode(responseperson.body);
          appuserData = json.decode(responseappuser.body);
        });
      } else {
        throw Exception('Failed to load data: ${responseperson.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius:
                          40, // Reduced radius for a slightly smaller picture
                      backgroundImage: personData['gender'] == "Male"
                          ? AssetImage('lib/assets/maleAvatar.png')
                          : AssetImage('lib/assets/femaleAvatar.png'),
                    ),
                    SizedBox(
                        width: 15), // Added space between the picture and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['username'] ?? 'unknown',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          // Add other details here if needed
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        firstName: personData['first_name'] ?? 'unknown',
                        lastName: personData['last_name'] ?? 'unknown',
                        email: userData['email'] ?? 'unknown',
                        phoneNumber: personData['phone_number'] ?? 'unknown',
                        dateOfBirth: personData['date_of_birth'] != null
                            ? DateTime.tryParse(personData['date_of_birth']) ??
                                DateTime.now()
                            : DateTime.now(),
                        gender: personData['gender'] ?? 'unknown',
                        address: personData['address'] ?? 'unknown',
                        blood_group: appuserData['blood_group'] ?? '',
                      ),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Security'),
                leading: Icon(Icons.security),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SecuritySettingsScreen(email: userData['email']),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Notification'),
                leading: Icon(Icons.notifications),
                onTap: () {
                  // Navigate to notification settings screen
                },
              ),
              Divider(),
              ListTile(
                title: Text('Report Bug'),
                leading: Icon(Icons.bug_report),
                onTap: () {
                  // Navigate to report bug screen
                },
              ),
              Divider(),
              ListTile(
                title: Text('Feedback'),
                leading: Icon(Icons.feedback),
                onTap: () {
                  // Navigate to feedback screen
                },
              ),
              Divider(),
              ListTile(
                title: Text('Get Support'),
                leading: Icon(Icons.support),
                onTap: () {
                  // Navigate to support screen
                },
              ),
              Divider(),
              ListTile(
                title: Text('About'),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
