import 'dart:convert';
import 'package:flutter/material.dart';
import 'http_request.dart' as http_request;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  BloodGroup? _bloodGroupValue;
  int numberOfCities = AlgerianCities.values.length;
  String _email = "";
  String _username = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String? _gender;
  DateTime? _dateOfBirth;
  String _placeOfBirth = "";
  String _address = "";

  int _currentStep = 0;

  List<Step> _buildSteps() {
    return [
      _buildAccountStep(),
      _buildPersonalInfoStep(),
      _buildUserStep(),
    ];
  }

  Step _buildAccountStep() {
    return Step(
      title: Text('Account'),
      content: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              }
              return null;
            },
            onChanged: (value) => _email = value, // Save email input
          ),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your username';
              }
              return null;
            },
            onChanged: (value) => _username = value, // Save username input
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your password';
              }
              return null;
            },
            onChanged: (value) => _password = value, // Save password input
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please confirm your password';
              } else if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
      isActive: _currentStep == 0,
    );
  }

  Step _buildPersonalInfoStep() {
    return Step(
      title: Text('Personal Info'),
      content: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
            validator: (value) {
              if (_currentStep == 1) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your first name';
                }
              }
              return null;
            },
            onChanged: (value) => _firstName = value, // Save first name input
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: (value) {
              if (_currentStep == 1) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your last name';
                }
              }
              return null;
            },
            onChanged: (value) => _lastName = value, // Save last name input
          ),
          TextFormField(
            controller: _phoneNumberController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            validator: (value) {
              if (_currentStep == 1) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your phone number';
                }
              }
              return null;
            },
            onChanged: (value) =>
                _phoneNumber = value, // Save phone number input
          ),
          DropdownButtonFormField<String>(
            value: _gender,
            onChanged: (String? newValue) {
              setState(() {
                _gender = newValue; // Save gender selection
              });
            },
            items: ['Male', 'Female'].map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Gender',
            ),
            validator: (value) {
              if (_currentStep == 1) {
                if (value == null || value.isEmpty) {
                  return 'Please select your gender';
                }
                // Check if there's only one item with the selected value
                if (['Male', 'Female'].contains(value)) {
                  return null;
                } else {
                  return 'Invalid gender selection';
                }
              }
              return null;
            },
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _dateOfBirthController.text = pickedDate
                      .toString()
                      .split(' ')[0]; // Extract only the date part
                  _dateOfBirth = pickedDate; // Save selected date
                  _formKey.currentState
                      ?.validate(); // Validate the form after setting the date
                });
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _dateOfBirthController.text.isNotEmpty
                    ? _dateOfBirthController.text
                    : 'Select Date',
                style: TextStyle(
                  color: _dateOfBirthController.text.isNotEmpty
                      ? Colors.black
                      : Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
          DropdownButtonFormField<AlgerianCities?>(
            onChanged: (AlgerianCities? newValue) {
              setState(() {
                //var _selectedCity = newValue ?? AlgerianCities.Adrar;
                _placeOfBirth = newValue?.toString().split('.').last ?? '';
              });
            },
            items: [
              DropdownMenuItem<AlgerianCities?>(
                value: null,
                child: Text(''),
              ),
              ...AlgerianCities.values.map((city) {
                return DropdownMenuItem<AlgerianCities?>(
                  value: city,
                  child: Text(
                      '${AlgerianCities.values.indexOf(city) + 1}. ${city.toString().split('.').last.replaceAll(' ', ' ')}'),
                );
              }).toList(),
            ],
            decoration: InputDecoration(labelText: 'Place of Birth'),
            validator: (_) {
              // ignore: unnecessary_null_comparison
              if (_currentStep == 1 && _placeOfBirth == null) {
                return 'Please select your place of birth';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (_currentStep == 1) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your address';
                }
              }
              return null;
            },
            onChanged: (value) => _address = value, // Save address input
          ),
        ],
      ),
      isActive: _currentStep == 1,
    );
  }

  Step _buildUserStep() {
    return Step(
      title: Text('User Details'),
      content: Column(
        children: [
          DropdownButtonFormField<BloodGroup>(
            value: _bloodGroupValue,
            onChanged: (BloodGroup? newValue) {
              setState(() {
                _bloodGroupValue = newValue;
              });
            },
            items: BloodGroup.values.map((BloodGroup bloodGroup) {
              return DropdownMenuItem<BloodGroup>(
                value: bloodGroup,
                child: Text(bloodGroupToString(bloodGroup)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Blood Group',
            ),
          ),
        ],
      ),
      isActive: _currentStep == 2, // Adjust the step number accordingly
    );
  }

  void _next() {
    print('Next button pressed');
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      setState(() {
        if (_currentStep < _buildSteps().length - 1) {
          _currentStep++;
        } else {
          signUp(
              _username,
              _email,
              _password,
              _firstName,
              _lastName,
              _phoneNumber,
              _gender,
              _dateOfBirth,
              _placeOfBirth,
              _address,
              _bloodGroupValue.toString());
        }
      });
    }
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> signUp(
    String username,
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String? gender,
    DateTime? dateOfBirth,
    String placeOfBirth,
    String address,
    String bloodGroupValue,
  ) async {
    final response = await http_request.signUp(
      username,
      email,
      password,
      firstName,
      lastName,
      phoneNumber,
      gender,
      dateOfBirth,
      placeOfBirth,
      address,
    );

    if (response.statusCode == 200) {
      final response = await http_request.signUp2(username, bloodGroupValue);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        await http_request.saveToken(token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpSuccessScreen()),
        );
        print('Signup successful $token');
      } else {
        final errorMessage = jsonDecode(response.body)['error'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage ?? 'Signup failed'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage ?? 'Signup failed'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _next,
                  onStepCancel: _previous,
                  steps: _buildSteps(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: const TextSpan(
                    text: "I'm already a member, ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Sign Up Successful!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

enum BloodGroup {
  O_POSITIVE,
  O_NEGATIVE,
  A_POSITIVE,
  A_NEGATIVE,
  B_POSITIVE,
  B_NEGATIVE,
  AB_POSITIVE,
  AB_NEGATIVE,
}

String bloodGroupToString(BloodGroup bloodGroup) {
  switch (bloodGroup) {
    case BloodGroup.O_POSITIVE:
      return 'O+';
    case BloodGroup.O_NEGATIVE:
      return 'O-';
    case BloodGroup.A_POSITIVE:
      return 'A+';
    case BloodGroup.A_NEGATIVE:
      return 'A-';
    case BloodGroup.B_POSITIVE:
      return 'B+';
    case BloodGroup.B_NEGATIVE:
      return 'B-';
    case BloodGroup.AB_POSITIVE:
      return 'AB+';
    case BloodGroup.AB_NEGATIVE:
      return 'AB-';
  }
}

enum AlgerianCities {
  Adrar,
  Chlef,
  Laghouat,
  Oum_El_Bouaghi,
  Batna,
  Bejaia,
  Biskra,
  Bechar,
  Blida,
  Bouira,
  Tamanrasset,
  Tebessa,
  Tlemcen,
  Tiaret,
  Tizi_Ouzou,
  Algiers,
  Djelfa,
  Jijel,
  Setif,
  Saida,
  Skikda,
  Sidi_Bel_Abbes,
  Annaba,
  Guelma,
  Constantine,
  Medea,
  Mostaganem,
  M_Sila,
  Mascara,
  Ouargla,
  Oran,
  El_Bayadh,
  Illizi,
  Bordj_Bou_Arreidj,
  Boumerdes,
  El_Tarf,
  Tindouf,
  Tissemsilt,
  El_Oued,
  Khenchela,
  Souk_Ahras,
  Tipaza,
  Mila,
  Ain_Defla,
  Naama,
  Ain_Temouchent,
  Ghardaia,
  Relizane,
  El_MGhair,
  El_Menia,
  Ouled_Djellal,
  Bordj_Badji_Mokhtar,
  Hassi_Messaoud,
  Bir_El_Ater,
  El_Amria,
  Timimoun,
  Tolga,
  In_Salah,
}
