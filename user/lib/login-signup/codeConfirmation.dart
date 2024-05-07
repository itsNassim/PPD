import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projetppd_2/profile/ChangePasswordPage.dart';
import 'package:projetppd_2/login-signup/emailValidation.dart';

class ConfirmationCodeScreen extends StatefulWidget {
  final String email;

  ConfirmationCodeScreen({required this.email});

  @override
  _ConfirmationCodeScreenState createState() => _ConfirmationCodeScreenState();
}

class _ConfirmationCodeScreenState extends State<ConfirmationCodeScreen>
    with SingleTickerProviderStateMixin {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  late AnimationController _animationController;
  late Timer _timer;
  int _secondsRemaining = 30;
  bool _isCountingDown = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // Use `this` as vsync
      duration: const Duration(seconds: 1),
    );
    // Start the countdown timer
    _startCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose AnimationController
    _timer.cancel(); // Cancel Timer
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _animationController.repeat(
        reverse: true); // Use AnimationController for countdown animation
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        // Stop the timer
        _timer.cancel();
        _isCountingDown = false;
      }
    });
  }

  void _resendConfirmationCode() {
    // Toggle the countdown state
    setState(() {
      _secondsRemaining = 30;
      _isCountingDown = !_isCountingDown;
    });
    // If countdown is active, start the timer
    if (_isCountingDown) {
      _startCountdown();
    } else {
      // If countdown is stopped, cancel the timer
      _timer.cancel();
    }
  }

  void _editEmail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordRecoveryScreen(),
      ),
    );
  }

  void resend() async {
    final String url = 'http://10.0.2.2:8000/authentication/resend/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': widget.email}),
      );

      if (response.statusCode == 200) {
        _resendConfirmationCode();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('unexpected problem happened, please try later'),
          ),
        );
      }
    } catch (error) {
      print('Error sending confirmation code: $error');
    }
  }

  Future<void> confirmCode(String code) async {
    final String url = 'http://10.0.2.2:8000/authentication/confirmcode/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'confirmation_code': code}),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordPage(email: widget.email),
          ),
        );
      } else {
        // Handle other status codes
      }
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Confirmation Code'),
      ),
      body: Center(
        child: SingleChildScrollView(
          primary: false,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A confirmation code has been sent to:',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.left,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '      ${widget.email}. ',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        onPressed: _editEmail,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Please enter the code below:',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                ConfirmationCodeInput(
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    String enteredCode = _controllers
                        .map((controller) => controller.text)
                        .join();
                    if (enteredCode.length == 6) {
                      confirmCode(enteredCode);
                    } else {
                      // Show an error message if the entered code is not valid
                      print('Invalid code');
                    }
                  },
                  child: Text('Verify Code'),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _secondsRemaining == 0 ? resend : null,
                      child: _secondsRemaining == 0
                          ? Text('Resend')
                          : Text('Resend ($_secondsRemaining)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationCodeInput extends StatefulWidget {
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;

  ConfirmationCodeInput({required this.focusNodes, required this.controllers});

  @override
  _ConfirmationCodeInputState createState() => _ConfirmationCodeInputState();
}

class _ConfirmationCodeInputState extends State<ConfirmationCodeInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 50,
          child: TextField(
            controller: widget.controllers[
                index], // Access controller using widget.controllers
            focusNode: widget
                .focusNodes[index], // Access focus node using widget.focusNodes
            textAlign: TextAlign.center,
            keyboardType: TextInputType.visiblePassword,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(widget.focusNodes[
                    index + 1]); // Access focus node using widget.focusNodes
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(widget.focusNodes[
                    index - 1]); // Access focus node using widget.focusNodes
              }
            },
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Customize border radius here
              ),
            ),
          ),
        ),
      ),
    );
  }
}
