import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _email = "";
  String _region = "";
  DateTime _selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
     // builder: (context, child ) => Theme(
      //  data: ThemeData().copyWith(
      //    colorScheme: ColorScheme.light(
      //      surface:Color.fromARGB(255, 255, 223, 223),
      //    ),
      //    dialogBackgroundColor: Color.fromARGB(255, 255, 223, 223),
      //  ),
      //  child: child,
    //  ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 100.0,
        title: const Text('Edit Profile', style: TextStyle(
          fontSize: 30,
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const CircleAvatar(
                radius: 50.0,
                backgroundColor: Color.fromARGB(255, 255, 223, 223),
                backgroundImage: AssetImage('icons/verification-de-lutilisateur.png'),
              ),
              const SizedBox(height: 80), // Add spacing


              TextFormField(
                initialValue: _username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (newValue) => _username = newValue ?? "", // Save value
              ),

              const SizedBox(height: 10),


              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress, // Email keyboard
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (newValue) => _email = newValue ?? "", // Save value
              ),

              const SizedBox(height: 10), // Add spacing


              TextFormField(
                initialValue: _region,
                decoration: const InputDecoration(
                  labelText: 'Wilaya',
                ),
                onSaved: (newValue) => _region = newValue ?? "",
              ),

              const SizedBox(height: 10),


              Row(
                children: [
                  const Text('Birthday: '),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(DateFormat('y MMMM d').format(_selectedDate).toString(),  style: TextStyle(color: const Color.fromARGB(255, 120, 13, 11))),

                  ),
                ],
              ),

              const SizedBox(height: 20),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,



                    ),
                    child: const Text('Cancel' ,style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold)),

                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();



                        debugPrint('Username: $_username, Email: $_email, Region: $_region, Birthday: $_selectedDate');
                      }


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,



                    ),
                    child: const Text('Save Profile',style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold)),

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