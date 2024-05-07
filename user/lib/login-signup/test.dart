import 'package:flutter/material.dart';
import 'package:projetppd_2/login-signup/codeConfirmation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confirmation Code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConfirmationCodeScreen(
          email: 'example@example.com'), // Replace with the actual email
    );
  }
}
