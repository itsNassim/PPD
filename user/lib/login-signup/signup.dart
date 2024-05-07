import 'dart:convert';
import 'package:flutter/material.dart';
import 'http_request.dart' as http_request;
import 'package:projetppd_2/pages/home.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: SignUpScreen(),
    );
  }
}

class Disease {
  final int id;
  final String name;

  Disease({
    required this.id,
    required this.name,
  });
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
  String _email = "";
  String _username = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String? _gender;
  DateTime? _dateOfBirth;
  String _address = "";
  bool dateCheck = true;
  int _currentStep = 0;
  late List<Disease> _diseases;
  late List<MultiSelectItem<Disease>> _items = [];
  late List<Disease> _selectedDiseases = [];

  void initState() {
    super.initState();
    fetchData();
  }

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
              // Regular expression to check for a valid email format
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value!)) {
                return 'Please enter a valid email';
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
              // Check for minimum length
              if (value!.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              // Check for at least one uppercase letter
              if (!value.contains(RegExp(r'[A-Z]'))) {
                return 'Password must contain at least one uppercase letter';
              }
              // Check for at least one lowercase letter
              if (!value.contains(RegExp(r'[a-z]'))) {
                return 'Password must contain at least one lowercase letter';
              }
              // Check for at least one digit
              if (!value.contains(RegExp(r'[0-9]'))) {
                return 'Password must contain at least one digit';
              }
              // Additional criteria, like special characters, can be added similarly
              return null;
            },
            onChanged: (value) => _password = value, // Save password input
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your password';
              }
              // Check for minimum length
              if (value!.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              // Check for at least one uppercase letter
              if (!value.contains(RegExp(r'[A-Z]'))) {
                return 'Password must contain at least one uppercase letter';
              }
              // Check for at least one lowercase letter
              if (!value.contains(RegExp(r'[a-z]'))) {
                return 'Password must contain at least one lowercase letter';
              }
              // Check for at least one digit
              if (!value.contains(RegExp(r'[0-9]'))) {
                return 'Password must contain at least one digit';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              // Additional criteria, like special characters, can be added similarly
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
                // Check if the name contains any numbers
                if (RegExp(r'[0-9]').hasMatch(value!)) {
                  return 'First name cannot contain numbers';
                }
                // Check if the name contains any special characters
                if (RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return 'First name cannot contain special characters';
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
                // Check if the name contains any numbers
                if (RegExp(r'[0-9]').hasMatch(value!)) {
                  return 'Last name cannot contain numbers';
                }
                // Check if the name contains any special characters
                if (RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return 'last name cannot contain special characters';
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
                // Check if the phone number has a length of exactly 10 digits
                if (value!.length != 10) {
                  return 'Please enter a valid phone number';
                }
                // Check if the phone number consists of only digits
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
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
                final age = DateTime.now().difference(pickedDate).inDays ~/ 365;
                if (age >= 13) {
                  setState(() {
                    _dateOfBirthController.text =
                        pickedDate.toString().split(' ')[0];
                    _dateOfBirth = pickedDate;
                    _formKey.currentState?.validate();
                  });
                } else {
                  // Show an error message if the age is less than 13
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Age Requirement'),
                        content: Text(
                            'You must be at least 13 years old to register.'),
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
              if (_dateOfBirthController.text.isEmpty) {
                dateCheck = false;
              } else {
                dateCheck = true;
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
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
                          : Colors.red,
                    ),
                  ),
                ),
                if (_dateOfBirthController.text.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      'You must enter a date of birth',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (_currentStep == 1) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your address';
                }
                // Check if the name contains any special characters
                if (RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(value!)) {
                  return 'Name cannot contain special characters';
                }
              }
              return null;
            },
            onChanged: (value) => _address = value,
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
          multiChoice(),
        ],
      ),
      isActive: _currentStep == 2,
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/authentication/getDiseases/'));

      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          _diseases = list
              .map((model) =>
                  Disease(id: model['disease_id'], name: model['name']))
              .toList();
          _items = _diseases
              .map((disease) => MultiSelectItem<Disease>(disease, disease.name))
              .toList();
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _next() {
    print('Next button pressed');
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid && dateCheck) {
      setState(() {
        if (_currentStep < _buildSteps().length - 1) {
          _currentStep++;
        } else {
          BloodGroup b = _bloodGroupValue!;
          signUp(
              _username,
              _email,
              _password,
              _firstName,
              _lastName,
              _phoneNumber,
              _gender,
              _dateOfBirth,
              _address,
              bloodGroupToString(b));
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
      address,
    );

    if (response.statusCode == 200) {
      final response = await http_request.signUp2(username, bloodGroupValue);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        await http_request.saveToken(token);
        String baseUrl = 'http://10.0.2.2:8000/authentication';
        for (Disease s in _selectedDiseases) {
          Map<String, dynamic> addUserDiseasesData = {
            'disease': s.id,
          };
          await http.post(
            Uri.parse('$baseUrl/addUserDiseases/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Token $token',
            },
            body: jsonEncode(addUserDiseasesData),
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome $username'),
          ),
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => home()),
          );
        });
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
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/background3.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Colored container to reduce opacity
          Container(
            color: Colors.grey
                .withOpacity(0.25), // Adjust the opacity value as needed
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
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
        ],
      ),
    );
  }

  Widget multiChoice() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            _items.isNotEmpty
                ? MultiSelectDialogField(
                    items: _items,
                    title: Text("Diseases"),
                    selectedColor: Colors.blue,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    buttonIcon: Icon(
                      Icons.medical_services_outlined,
                      color: Colors.blue,
                    ),
                    buttonText: Text(
                      "My Diseases",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (results) {
                      setState(() {
                        _selectedDiseases = results.cast<Disease>();
                      });
                    },
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 50),
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
