import 'package:flutter/material.dart';
import 'pages/pages.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Emergency App',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[

              Image.asset('images/AidNow.png'),
              const SizedBox(height: 200),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 212, 27, 34),
                          minimumSize: const Size(200, 70),

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'icons/appel-telephonique.png',
                              fit: BoxFit.cover,
                              height: 24,
                              width: 24,

                            ),
                            const SizedBox(width: 50),
                            const Text('411', style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold,)),
                          ],

                        ),

                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                         Navigator.push(
                         context,
                        MaterialPageRoute(builder: (context) => const Navigation()),
    );
  },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(200, 50),


                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'icons/fleche-de-localisation2.png',
                              fit: BoxFit.cover,
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 25),
                            const Text('Get Started', style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold)),
                          ],

                        ),

                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



}