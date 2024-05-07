import 'package:flutter/material.dart';
import 'package:projetppd_2/video/accidentPage.dart';
import 'package:projetppd_2/video/catastrophePage.dart';
import 'package:projetppd_2/video/crisesPage.dart';
import 'package:projetppd_2/video/gazPage.dart';
import 'package:projetppd_2/video/incendiePage.dart';
import 'package:projetppd_2/video/noyadePage.dart';

class VideoInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(160, 21, 62, 1),
              Color.fromRGBO(236, 90, 90, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 70, left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              height: 310,
              child: Column(
                children: [
                  Row(
                    children: [
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
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 150, // Adjust the height as needed
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'lib/assets/medical.png'), // Replace 'assets/your_image.png' with your image path
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (_, int i) {
                          List<Map<String, dynamic>> items = [
                            {
                              'img': "lib/video/pics/Accident.png",
                              'title': "Car Accident"
                            },
                            {'img': "lib/video/pics/feux.jpg", 'title': "Fire"},
                            {
                              'img': "lib/video/pics/GAZ.png",
                              'title': "Gas leak"
                            },
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
                          return Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 135,
                            child: GestureDetector(
                              onTap: () {
                                navigateToSituationPage(context, title);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 95,
                                        height: 95,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          image: DecorationImage(
                                            image: AssetImage(imagePath),
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            navigateToSituationPage(
                                                context, title);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.only(top: 3),
                                            child: Text(
                                              '30 seconds',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 18),
                                  Row(
                                    children: [
                                      for (int ii = 0; ii < 100; ii++)
                                        ii.isEven
                                            ? Container(
                                                width: 4,
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  color: Colors.blueGrey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              )
                                            : Container(
                                                width: 3,
                                                height: 1,
                                                color: Colors.white,
                                              )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSituationPage(BuildContext context, String situationTitle) {
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
