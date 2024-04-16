import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});



  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
  }

  class _ChangePasswordPageState extends State<ChangePasswordPage> {
    static String currentPassword = 'ing22024';
    static String newPassword = '';
    static String confirmPassword = '';
    bool _obscureTextNew = true;
    bool _obscureTextConfirm = true;
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Change Password', style: TextStyle(
    fontSize: 30,
    color: Colors.black87,
    fontWeight: FontWeight.w700,
  ),),
    toolbarHeight: 100.0,
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  ),
  body: Padding(
  padding: const EdgeInsets.all(40.0),
  child: Column(
    children: <Widget>[

      Image.asset('icons/mot-de-passe.png',height: 200,width:100),

  TextFormField(
  initialValue: currentPassword,
  enabled: false,
  decoration: const InputDecoration(
  labelText: 'Current Password',
  ),
  ),
  const SizedBox(height: 10),

  // New password field
      TextFormField(
        obscureText: _obscureTextConfirm, // Use _obscureTextConfirm state
        onChanged: (value) => setState(() => confirmPassword = value),
        decoration: InputDecoration(
          labelText: 'Confirm New Password',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureTextConfirm ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureTextConfirm = !_obscureTextConfirm;
              });
            },
          ),
        ),
      ),
  const SizedBox(height: 10),

  // Confirm password field
      TextFormField(
        obscureText: _obscureTextConfirm, // Use _obscureTextConfirm state
        onChanged: (value) => setState(() => confirmPassword = value),
        decoration: InputDecoration(
          labelText: 'Confirm New Password',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureTextConfirm ? Icons.visibility_off : Icons.visibility,
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
  onPressed: () {
  if (newPassword.isEmpty) {

  print('Please enter a new password');
  } else if (newPassword != confirmPassword) {

  print('Passwords do not match');
  } else {

  currentPassword = newPassword;
  print('Password changed successfully (simulated)');
  }
  },
  child: const Text('Change Password',style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold,)),
  ),
  ],
  ),
  ),
  );
  }
  }
