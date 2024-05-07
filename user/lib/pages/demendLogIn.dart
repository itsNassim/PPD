import 'package:flutter/material.dart';
import 'package:projetppd_2/login-signup/login.dart';
import 'package:projetppd_2/login-signup/signup.dart';

class _LoginSignUpButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SimpleLoginScreen()),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Log In',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SignUpScreen()),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              'Join Us',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginSignUpButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/background3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'lib/assets/login.png',
                    width: 600,
                    height: 380,
                  ),
                ),
                SizedBox(height: 140),
                Text(
                  'To access this page you need to ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22, // Adjust font size here
                    color: Colors.white, // Set text color
                    fontFamily: 'YourFontFamily', // Change font family here
                  ),
                ),
                Expanded(
                  child: _LoginSignUpButtons(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
