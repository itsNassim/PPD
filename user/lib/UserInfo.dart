import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = 'khadidjalrkb13';
    final String email = 'khadidjalrkb2003@gmail.com';
    final String phoneNumber = '+213 557057900';
    final String wilaya = 'Constantine';
    final DateTime birthday = DateTime(2003, 03, 13);
    final List<String> diseases = ['Diabetes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Information',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        toolbarHeight: 100.0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromARGB(255, 255, 223, 223),
                  backgroundImage:
                      AssetImage('icons/verification-de-lutilisateur.png'),
                ),
              ),
              const SizedBox(height: 20),

              // User Name
              const Text(
                'Name:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(userName),
              const SizedBox(height: 10),

              // Email
              const Text(
                'Email:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(email),
              const SizedBox(height: 10),

              // Phone Number
              const Text(
                'Phone Number:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(phoneNumber),
              const SizedBox(height: 10),

              // Wilaya
              const Text(
                'Wilaya:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(wilaya),
              const SizedBox(height: 10),

              // Birthday
              const Text(
                'Birthday:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(birthday.toIso8601String()),
              const SizedBox(height: 10),

              if (diseases.isNotEmpty) ...[
                const Text(
                  'Diseases:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8.0,
                  children: diseases
                      .map((disease) => Chip(label: Text(disease)))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
