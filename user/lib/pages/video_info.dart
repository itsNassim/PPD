import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:projetppd_2/pages/info.dart';

class videoInfo extends StatefulWidget {
  const videoInfo({super.key});

  @override
  State<videoInfo> createState() => _videoInfoState();
}
class _videoInfoState extends State<videoInfo>{
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(250, 255, 243, 248),
  body: Container(
    padding: const EdgeInsets.only(top :70,left: 30,right :30),
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
         const Icon(Icons.arrow_back_ios,
         size : 20,
           color: Colors.black87,
         ),
         const SizedBox(width: 10,),
         const Icon(Icons.medical_services_outlined,
             size :20,
           color: Colors.black87,),
         const SizedBox(width: 10,),
         const Icon(Icons.arrow_forward_ios,
         size : 20,
           color: Colors.black87,
         ),
         const SizedBox(width: 10),

       ],
       ),
        const SizedBox(height: 30,),
        Row(
          children: [
            const Text(
              "Votre formation",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
Expanded(child: Container()),
            const Text(
              "Details",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(89, 206, 70, 1),
                fontWeight: FontWeight.bold,

              ),
            ),
            const SizedBox(width: 5,),
            InkWell(
              onTap: (){
                Get.to(()=>const Info());
              },
              child: const Icon(Icons.arrow_forward,
              size: 20,
                color: Colors.black,
                ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Container(
          width: MediaQuery.of(context).size.width,
           height: 230,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade900,
                Colors.red.shade300.withOpacity(0.9),
              ]
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(75),
            ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 10),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.3)
                )
              ]
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20,top: 25,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                "Prochaine video ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  "Crises Cardiaques",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,

                  ),
                ),
                const SizedBox(height: 6,),
                const Text(
                  "Gestes de secours et aides",
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,

                  ),
                ),
                const SizedBox(height: 25,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined,size: 20, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text(
                          " 10 min",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,

                          ),
                        ),


                      ],
                    ),
                    Expanded(child: Container()),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 15,
                            offset: Offset(4,8)
                          )
                        ]
                      ),

                    child: const Icon(Icons.play_circle_fill,size: 60,color: Colors.white,),
                    ),
                      ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                       image: AssetImage(
                         "lib/assets/emergency.jpg"
                       ),
                        fit:BoxFit.fill
                      ),
                       boxShadow: [
                         BoxShadow(
                           blurRadius: 40,
                           offset: const Offset(8,10),
                           color: Colors.black.withOpacity(0.3),
                         )
                       ]
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30,),
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
            Expanded(child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, i){
                  List<Map<String,dynamic>> items=[
                     {
                      'img':"lib/assets/car-accident2.png",
                        'title':"accident"
                     },
                     {
                      'img':"lib/assets/feux.png",
                      'title':"incident"
                     },
                     {
                      'img':"lib/assets/gas.png",
                      'title':"gaz "
                     },
                     {
                      'img':"lib/assets/natural-disaster.png",
                      'title':"catastrophe naturelle",
                     },
                     {
                      'img':"lib/assets/crises-cardiaque.png",
                      'title':"crises cardiaques",
                     },
                     {
                      'img':"lib/assets/noyade.png",
                      'title':"Noyade",
                     },

                  ];
                  String imagePath=items[i]['img'];
                  String title=items[i]['title'];
                  return Column(
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          
                            
                              Container(
                                
                                height: 190,
                                width: 200,
                                padding: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                 color: const Color.fromARGB(250, 255, 243, 248),
                                  borderRadius: BorderRadius.circular(15),
                                                  
                                  image: DecorationImage(
                                                  
                                    image: AssetImage(
                                     imagePath
                                                  
                                    ),
                                    
                                    
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(5,5),
                                      color:Color.fromARGB(256, 255, 243, 248),
                                    ),
                                                  
                                BoxShadow(
                                  blurRadius: 3,
                                  offset: Offset(-5,-5),
                                  color: Color.fromARGB(256, 255, 243, 248),
                                ),
                                  ],
                                ),
                              
                                
                                  
                                
                                child: Center(
                                  
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                   child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      
                                      fontSize: 20,
                                      color: Color.fromRGBO(17, 66, 50, 1),
                                    ),
                                  ),
                                  
                      ),  
                  ), 
            )  
                              
                            ],
                      ),
                        ],
                      );
                    
                  
                },),
            )
      ],
    ),
  )
    );
  }
}
