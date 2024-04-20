import 'dart:io';

import 'package:flutter/material.dart';

class EnlargedImageScreen extends StatelessWidget {
  final String imagePath;

  const EnlargedImageScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pictures',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        toolbarHeight: 100.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
