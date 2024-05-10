import 'package:despinterface/loginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DispatcherTest1App());
}

class DispatcherTest1App extends StatelessWidget {
  const DispatcherTest1App({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dispatcher UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Image.asset(
            'image/AidNow8.png', // Replace 'AidNow.png' with your image file path
            width: 450, // Adjust width to make the image bigger
            height: 450, // Adjust height to make the image bigger
          ),
        ),
      ),
    );
  }
}
