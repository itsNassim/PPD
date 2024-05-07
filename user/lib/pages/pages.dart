import 'package:flutter/material.dart';
import 'package:projetppd_2/map.dart';
import 'package:projetppd_2/pages/home.dart';
import 'package:projetppd_2/profile/profilePage.dart';
import 'package:projetppd_2/video/main.dart';
import 'package:projetppd_2/pages/demendLogIn.dart';
import 'package:projetppd_2/login-signup/http_request.dart' as http_request;

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: http_request.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData && snapshot.data!) {
                // User is logged in
                return IndexedStack(
                  index: _currentIndex,
                  children: [
                    home(),
                    const MapPage(),
                    VideoInfo(),
                    SettingsScreen(),
                  ],
                );
              } else {
                // User is not logged in
                return IndexedStack(
                  index: _currentIndex,
                  children: [
                    home(),
                    LoginSignUpButtons(),
                    LoginSignUpButtons(),
                    LoginSignUpButtons(),
                  ],
                ); // Replace MyApp with your login page widget
              }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 120, 13, 11),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Column(
              children: <Widget>[
                Image.asset('lib/iconss/domicile.png',
                    height: 25,
                    width: 25,
                    color: const Color.fromRGBO(200, 12, 13, 1)),
                const Text(
                  'Acceuil',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
              label: 'Map',
              icon: Column(
                children: [
                  Image.asset(
                    'lib/iconss/emplacement.png',
                    height: 25,
                    width: 25,
                    color: const Color.fromRGBO(200, 12, 13, 1),
                  ),
                  const Text(
                    'Map',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              )),
          BottomNavigationBarItem(
              label: 'Formation',
              icon: Column(
                children: [
                  Image.asset('lib/iconss/la-gestion.png',
                      height: 25,
                      width: 25,
                      color: const Color.fromRGBO(200, 12, 13, 1)),
                  const Text(
                    'Formation',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )),
          BottomNavigationBarItem(
              label: 'Profile',
              icon: Column(
                children: [
                  Image.asset(
                    'lib/iconss/utilisateur.png',
                    height: 25,
                    width: 25,
                    color: const Color.fromRGBO(206, 13, 13, 1),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
