
import 'package:flutter/material.dart';

class GasPage extends StatelessWidget {
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
              height: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 25,
                          color: Color.fromRGBO(255, 223, 223, 1),
                        ),
                      ),
                      Expanded(child: Container()),
                      Icon(
                        Icons.info_outline,
                        size: 28,
                        color: Color.fromRGBO(255, 223, 223, 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gas Leak",
                        style: TextStyle(
                          fontSize: 27,
                          color: Color.fromRGBO(255, 223, 223, 1),
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text(
                        "Videos about how to help",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(255, 223, 223, 1),
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
                            colors: [
                              Color.fromRGBO(253, 181, 181, 1).withOpacity(0.3),
                              Colors.white.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5,),
                            Icon(
                              Icons.timer_outlined,
                              size: 20,
                              color: Color.fromRGBO(255, 223, 223, 1),
                            ),
                            SizedBox(width: 6,),
                            Text(
                              "1 min",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 223, 223, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 60,),
                      Container(
                        width: 180,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(253, 181, 181, 1).withOpacity(0.3),
                              Colors.white.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help,
                              size: 20,
                              color: Color.fromRGBO(223, 181, 181, 1),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "First aid",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 231, 221, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10,),
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
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Row(
                          children: [
                            Text(
                              "Rescue: Gaz leak",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 50,),
                            Row(
                              children: [
                                Icon(
                                  Icons.slow_motion_video_outlined,
                                  size: 24,
                                  color: Color.fromRGBO(160, 21, 62, 1),
                                ),
                                Text(
                                  "3 videos",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                   Expanded(child: ListView.builder(

                     itemCount: 3,
                       itemBuilder: (_,int i){
                         List<Map<String, dynamic>> items = [
                           {
                             'img': "lib/video/pics/gas1.jfif",
                             'title': "helping people"
                           },
                           {
                             'img': "lib/video/pics/gas2.jfif",
                             'title': "stoping the gas"
                           },
                           {
                             'img': "lib/video/pics/call114.jfif",
                             'title': "call 114 "
                           },
                           {
                           },



                         ];
                         String imagePath = items[i]['img'];
                         String title = items[i]['title'];
                       return GestureDetector(
                         onTap: (){
                           debugPrint(i.toString());
                         },
                         child: Container(
                           padding: EdgeInsets.only( left: 10,),
                           height: 135,


                           child: Column(
                             children: [
                               Row(
                            children: [
                              Container(
                                width: 95,
                                height: 95,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                    image: AssetImage(
                                           imagePath,
                                    )
                                  )
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward,color: Colors.transparent,),
                                  onPressed: () {

                                  },
                                ),
                              ),
                            
                             SizedBox(width: 10),
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   title,
                                   style: TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                     SizedBox(height: 10,),
                                 Padding(
                                   padding: EdgeInsets.only(top:3),
                                   child: Text(
                                     '30 secondes',
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
                               SizedBox(height: 18,),
                               Row(
                                 children: [
                                   for(int ii=0;ii<100;ii++)
                                   ii.isEven?Container(
                                     width: 4,
                                     height: 1,
                                     decoration: BoxDecoration(
                                       color: Colors.blueGrey[300],
                                       borderRadius: BorderRadius.circular(2),

                                     ),
                                   ):Container(
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
                   }))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
