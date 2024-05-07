import 'package:flutter/material.dart';
import 'dart:async';

import 'package:projetppd_2/Message.dart';
import 'package:projetppd_2/call/call.dart';
import 'package:projetppd_2/login-signup/login.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:projetppd_2/login-signup/http_request.dart' as http_request;

class home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<home> {
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Red Page with Circles',
      home: Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Column(
                children: [
                  Text(
                    'Emergency help needed?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Click this button',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CircleButton(),
              SizedBox(height: 50),
              Text(
                "You can't talk, or don't have internet connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We have the solution",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Message()),
                      );
                    },
                    icon: Icon(Icons.message, color: Colors.white),
                    label:
                        Text("Message", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(150, 50),
                      side: BorderSide(width: 2, color: Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _launchPhoneDialer('tel:411');
                    },
                    icon: Icon(Icons.phone, color: Colors.white),
                    label: Text("411", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(150, 50),
                      side: BorderSide(width: 2, color: Colors.white),
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

  void _launchPhoneDialer(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}

void checkLogin(BuildContext context) async {
  if (await http_request.isLoggedIn()) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => VideoCallScreen(),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Connection Required"),
          content: Text("You must log in to use the call."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => SimpleLoginScreen(),
                  ),
                );
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class CircleButton extends StatefulWidget {
  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  Timer? _timer;
  int _countdown = 3;
  bool _countingDown = false;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          checkLogin(context);
          _countingDown = false;
          _countdown = 3;
        }
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _countingDown = false;
      _countdown = 3;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_countingDown) {
          stopTimer();
        } else {
          setState(() {
            _countingDown = true;
            startTimer();
          });
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.white.withOpacity(0.8)
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Center(
          child: _countingDown
              ? Text(
                  '$_countdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
