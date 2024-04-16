

import 'package:flutter/material.dart';

import 'package:projetppd_2/ProfilPage.dart';
import 'package:projetppd_2/HomePage.dart';
import 'package:projetppd_2/pages/map_page.dart';
import 'package:projetppd_2/AcceuilPage.dart';
import 'package:projetppd_2/pages/video_info.dart';
import 'package:projetppd_2/pages/info.dart';


class Navigation extends StatefulWidget {
  const Navigation({super.key});
@override 
State<Navigation> createState() => _navigation();
}
class _navigation extends State<Navigation>{
  int _currentIndex=0;
  List<Widget> body=[


    const AcceuilPage(),
    //Image.asset('lib/iconss/domicile.png',height: 120,width:60),
    const MapPage(),
    const videoInfo(),
    
     const ProfilPage(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 234, 234),
     body: Center(
      child: body[_currentIndex],
     ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 120, 13, 11),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;

            if (newIndex == 3) {
             // Navigator.push(
             //   context,
                //MaterialPageRoute(builder: (context) => const ProfilPage()),
              //);
            }
          });
        },
        items:[
          BottomNavigationBarItem(
            label: 'Home',
            icon:Column(
              children: <Widget>[
             Image.asset('lib/iconss/domicile.png',
               height: 25,width: 25,color: const Color.fromRGBO(200, 12, 13, 1)
            ),
             const Text(
             'Acceuil',
             style: TextStyle(fontSize: 12),
       
              )
        ], 
          ),
          ),
          BottomNavigationBarItem(
            label: 'map',
            icon: Column(children: [

            Image.asset('lib/iconss/emplacement.png',
            height: 25,width: 25,color: const Color.fromRGBO(200, 12, 13, 1),
            ),
            const Text(
              'Map',
              style: TextStyle(fontSize: 12),

            )
            ],)
            
            ),
            BottomNavigationBarItem(
              label: 'formation',
              icon: Column(children: [ 
             
              Image.asset('lib/iconss/la-gestion.png',height: 25,width: 25,color:  const Color.fromRGBO(200, 12, 13, 1)),
              const Text(
                'Formation',
                style: TextStyle(fontSize: 10),
              )
              ],) 
              
                
            ),
       BottomNavigationBarItem(
        label: 'profil',
        icon:  Column(children: [ 

         Image.asset('lib/iconss/utilisateur.png',height: 25,width: 25,
         color: const Color.fromRGBO(206, 13, 13, 1),),
        const Text(
  'Profile',
  style:TextStyle(fontSize: 10) ,
)
        ],)
        
      ),
        ],
    ),
    );
  }
}