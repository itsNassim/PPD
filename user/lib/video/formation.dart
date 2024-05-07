import 'package:flutter/material.dart';

import 'accidentPage.dart';
import 'incendiePage.dart';
import 'catastrophePage.dart';
import 'crisesPage.dart';
import 'gazPage.dart';
import 'noyadePage.dart';

class VideoInfo extends StatefulWidget {
  const VideoInfo({Key? key}) : super(key: key);

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 255, 243, 248),
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const Text(
                  "Formation",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black87,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.medical_services_outlined,
                  size: 20,
                  color: Colors.black87,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black87,
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                Text(
                  "Discover Situations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (_, i) {
                    List<Map<String, dynamic>> items = [
                      {
                        'img': "lib/video/pics/Accident.png",
                        'title': "Car Accident"
                      },
                      {'img': "lib/video/pics/feux.jpg", 'title': "Fire"},
                      {'img': "lib/video/pics/GAZ.png", 'title': "Gas leak"},
                      {
                        'img': "lib/video/pics/Naturel.png",
                        'title': "Natural Disaster",
                      },
                      {
                        'img': "lib/video/pics/crises-cardiaque.png",
                        'title': "Heart Attacks",
                      },
                      {
                        'img': "lib/video/pics/noyade.png",
                        'title': "Drowning",
                      },
                    ];
                    String imagePath = items[i]['img'];
                    String title = items[i]['title'];
                    return Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: 190,
                              padding: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(250, 255, 243, 248),
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(imagePath),
                                  fit: BoxFit.contain,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(5, 5),
                                    color: Color.fromARGB(256, 255, 243, 248),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(-5, -5),
                                    color: Color.fromARGB(256, 255, 243, 248),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  //color: Colors.white.withOpacity(0.8),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(17, 66, 50, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.transparent,
                                ),
                                onPressed: () {
                                  navigateToSituationPage(title);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  void navigateToSituationPage(String situationTitle) {
    switch (situationTitle) {
      case 'Car Accident':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccidentPage()));
        break;
      case 'Fire':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => IncendiePage()));
        break;
      case 'Gas leak':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GasPage()));
        break;
      case 'Natural Disaster':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CatastrophePage()));
        break;
      case 'Heart Attacks':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CrisesCardiaquePage()));
        break;
      case 'Drowning':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NoyadePage()));
        break;
    }
  }
}
