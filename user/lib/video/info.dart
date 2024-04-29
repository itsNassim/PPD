import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[

              Color.fromRGBO(160, 21, 62, 1),
              Color.fromRGBO(236, 90, 90, 1),
            ],

          ),
        ),
        child: Column(
          children: [

            Container(

              padding: EdgeInsets.only(top: 70,left: 30,right: 30),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child:
                        Icon(Icons.arrow_back_ios_new,size: 25,color:Color.fromRGBO(255, 223, 223, 1)),
                      ),
                      Expanded(child: Container()),
                      Icon(Icons.info_outline,size: 28,color: Color.fromRGBO(255, 223, 223, 1)),

                    ],
                  ),
                  SizedBox(height: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Crises Cardiaques",
                        style: TextStyle(
                          fontSize: 25,
                          color:  Color.fromRGBO(255, 223, 223, 1),

                        ),
                      ),

                      SizedBox(height: 6,),

                      Text(
                        "Gestes de secours et aides",
                        style: TextStyle(
                          fontSize: 26,
                          color:  Color.fromRGBO(255, 223, 223, 1),
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(

                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 90,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                                colors:[
                                  Color.fromRGBO(253, 181, 181, 1).withOpacity(0.3),
                                  Colors.white.withOpacity(0.4),
                                ] )
                        ),
                        child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Icon(Icons.timer_outlined,size: 20,color:  Color.fromRGBO(255, 223, 223, 1),),
                              SizedBox(width: 6,),
                              Text(
                                "10 min",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:  Color.fromRGBO(255, 223, 223, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]
                        ),



                      ),
                      SizedBox(width: 60,),
                      Container(
                        width: 180,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(253, 181, 181, 1).withOpacity(0.3),
                              Colors.white.withOpacity(0.4),
                            ])
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Icon(Icons.help,size: 20,color: Color.fromRGBO(223, 181, 181, 1),),
                            SizedBox(width: 5,),
                            Text(
                              "Premier secours",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 231, 221, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],),
                      )
                    ],

                  ),
                  SizedBox(width: 10,),








                ],
              ),
            ),
            Expanded(child: Container(
              decoration: BoxDecoration(
                  color:  Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  )

              ),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Row(
                        children: [
                          Text(
                            "Secours: Crises Cardiaques",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 50,),
                          Row(

                            children: [
                              Icon(Icons.slow_motion_video_outlined,size:24,color: Color.fromRGBO(160, 21, 62, 1),),
                              Text(
                                "3 videos",
                                style: TextStyle(

                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],),
            ))

          ],
        ),
      ),
    );
  }
}