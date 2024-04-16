import 'package:flutter/material.dart';
import 'package:projetppd_2/EditProfilPage.dart';
import 'package:projetppd_2/UserInfo.dart';
import 'package:projetppd_2/ChangePasswordPage.dart';
class ProfilPage extends StatelessWidget {
  const ProfilPage({Key key = const Key('default_key')}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(
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
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromARGB(255, 255, 223, 223),
                  backgroundImage: AssetImage('icons/verification-de-lutilisateur.png'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text(
                //  'User Name: ',
                //  style: TextStyle(fontWeight: FontWeight.bold),
               // ),
                Text('khadidjalrkb13',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            //const SizedBox(height: 10),
            //const Divider(thickness: 1),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  <Widget>[
                ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserInfo()),
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
                        'icons/info.png',
                        fit: BoxFit.cover,
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width:5 ),
                      const Text('Information', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size(200, 70),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'icons/bloquer.png',
                        fit: BoxFit.cover,
                        width: 24,
                        height: 24 ,
                      ),
                      const SizedBox(width: 10),
                      const Text('Change Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilPage()),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size(200, 70),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'icons/crayon.png',
                        fit: BoxFit.cover,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text('Edit Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement logout logic
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Logout Confirmation',style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold,)),
                      content: const Text('Are you sure you want to logout?',style: TextStyle( color: Colors.red, fontWeight: FontWeight.bold,)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel',style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold,)),
                        ),
                        TextButton(
                          onPressed: () {

                            Navigator.pop(context);
                          },
                          child: const Text('Logout',style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold,)),
                        ),
                      ],
                    );
                  },
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                minimumSize: const Size(200, 70),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'icons/du-pouvoir.png',
                    fit: BoxFit.cover,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  const Text('Logout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
