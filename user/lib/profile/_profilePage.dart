import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:projetppd_2/login-signup/http_request.dart' as http_request;

class InputField extends StatefulWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  final bool readOnly;
  final Icon? icon;
  final bool emailValidation;
  final bool phoneNumberValidation;
  final bool addressValidation;

  const InputField({
    this.labelText,
    this.onChanged,
    this.controller,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.obscureText = false,
    this.readOnly = false,
    this.icon,
    this.emailValidation = false,
    this.phoneNumberValidation = false,
    this.addressValidation = false,
    Key? key,
  }) : super(key: key);

  String? validatePhoneNumber(String value) {
    final phoneRegex = RegExp(r'^\+?0?[0-9]{10}$');
    if (value.isEmpty || !phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? validate() {
    String? errorText;
    if (emailValidation) {
      errorText = validateEmail(controller!.text);
    }
    if (phoneNumberValidation) {
      errorText = validatePhoneNumber(controller!.text);
    }
    if (addressValidation) {
      errorText = validateAddress(controller!.text);
    }
    return errorText;
  }

  @override
  _InputFieldState createState() => _InputFieldState();
}

class Disease {
  final int id;
  final String name;

  Disease({
    required this.id,
    required this.name,
  });
}

class _InputFieldState extends State<InputField> {
  late String? errorText;

  @override
  void initState() {
    super.initState();
    errorText = null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autoFocus,
      onChanged: widget.onChanged != null ? (value) => _onChanged(value) : null,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: widget.icon,
      ),
    );
  }

  void _onChanged(String value) {
    if (widget.emailValidation) {
      setState(() {
        errorText = widget.validateEmail(value);
      });
    }
    if (widget.phoneNumberValidation) {
      setState(() {
        errorText = widget.validatePhoneNumber(value);
      });
    }
    if (widget.addressValidation) {
      setState(() {
        errorText = widget.validateAddress(value);
      });
    }
    widget.onChanged?.call(value);
  }
}

class ProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String blood_group;

  ProfileScreen({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.blood_group,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _genderController;
  late bool _isSaveEnabled;
  bool _isAnyFieldChanged = false;
  BloodGroup? _bloodGroupValue;
  late List<InputField> _inputFields;

  late List<Disease> _diseases;
  late List<MultiSelectItem<Disease>> _items = [];
  late List<Disease> _selectedDiseases;
  late List<Disease> _selectedDiseases3 = [];
  late List<Disease> _selectedDiseases2 = [];
  late List<Disease> _AddDiseases = [];
  late List<Disease> _deleteDiseases = [];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _addressController = TextEditingController(text: widget.address);
    _dateOfBirthController = TextEditingController(
        text: widget.dateOfBirth.toString().split(' ')[0]);
    _genderController = TextEditingController(text: widget.gender);
    _bloodGroupValue = stringToBloodGroup(widget.blood_group);
    _isSaveEnabled = false;
    fetchData();
    getUserDiseases();

    _inputFields = [
      InputField(
        labelText: 'First Name',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _firstNameController,
        readOnly: true,
      ),
      InputField(
        labelText: 'Last Name',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _lastNameController,
        readOnly: true,
      ),
      InputField(
        labelText: 'Email',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        emailValidation: true,
        controller: _emailController,
        icon: Icon(Icons.edit),
      ),
      InputField(
        labelText: 'Phone Number',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _phoneNumberController,
        icon: Icon(Icons.edit),
        phoneNumberValidation: true,
      ),
      InputField(
        labelText: 'Address',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _addressController,
        icon: Icon(Icons.edit),
        addressValidation: true,
      ),
      InputField(
        labelText: 'Date of Birth',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _dateOfBirthController,
        readOnly: true,
      ),
      InputField(
        labelText: 'Gender',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _genderController,
        readOnly: true,
      ),
      InputField(
        labelText: 'First Name',
        onChanged: (value) {
          _isAnyFieldChanged = true;
          _validateFields();
        },
        controller: _firstNameController,
        readOnly: true,
      ),
    ];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    super.dispose();
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

  Future<void> getUserDiseases() async {
    String token = (await http_request.getToken())!;
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/authentication/getUserDiseases/'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          _selectedDiseases = list
              .map((model) =>
                  Disease(id: model['disease_id'], name: model['name']))
              .toList();
          for (Disease d in _selectedDiseases) {
            Disease? foundDisease =
                _diseases.firstWhere((element) => element.id == d.id);
            _selectedDiseases3.add(foundDisease);
          }
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _validateFields() {
    bool isValid = true;
    for (var field in _inputFields) {
      if (field.validate() != null) {
        isValid = false;
        break;
      }
    }

    setState(() {
      _isSaveEnabled = isValid && _isAnyFieldChanged;
    });
  }

  void finalList() {
    for (Disease s in _selectedDiseases2) {
      if (!_selectedDiseases3.contains(s)) {
        _AddDiseases.add(s);
      }
    }

    for (Disease s in _selectedDiseases3) {
      if (!_selectedDiseases2.contains(s)) {
        _deleteDiseases.add(s);
      }
    }
  }

  Future<void> _saveChanges() async {
    String baseUrl = 'http://10.0.2.2:8000/authentication';
    String token = (await http_request.getToken())!;
    if (_isSaveEnabled) {
      Map<String, dynamic> userData = {
        'email': _emailController.text,
      };

      Map<String, dynamic> personData = {
        'phone_number': _phoneNumberController.text,
        'address': _addressController.text,
      };
      BloodGroup bg = _bloodGroupValue!;
      Map<String, dynamic> appuserData = {
        'blood_group': bloodGroupToString(bg),
      };

      final responseuser = await http.post(
        Uri.parse('$baseUrl/modifyUserInfo/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(userData),
      );

      final responseperson = await http.post(
        Uri.parse('$baseUrl/modifyPersonInfo/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(personData),
      );

      final responseappuser = await http.post(
        Uri.parse('$baseUrl/modifyAppUserInfo/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(appuserData),
      );

      finalList();

      for (Disease s in _AddDiseases) {
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
      _AddDiseases = [];

      for (Disease s in _deleteDiseases) {
        Map<String, dynamic> deleteUserDiseasesData = {
          'disease_id': s.id,
        };
        await http.post(
          Uri.parse('$baseUrl/deleteUserDiseases/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
          body: jsonEncode(deleteUserDiseasesData),
        );
      }

      _deleteDiseases = [];

      if (responseuser.statusCode == 200 &&
          responseperson.statusCode == 200 &&
          responseappuser.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully.'),
          ),
        );
        setState(() {
          _isAnyFieldChanged = false;
          _isSaveEnabled = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${responseperson.body}'),
          ),
        );
      }
    }
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
                    initialValue: _selectedDiseases3,
                    onConfirm: (results) {
                      setState(() {
                        _selectedDiseases2 = results.cast<Disease>();
                        _isSaveEnabled =
                            !listEquals(_selectedDiseases3, _selectedDiseases2);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isAnyFieldChanged) {
          // Show confirmation dialog if any field has changed
          bool confirm = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Discard Changes?'),
                content: Text('Are you sure you want to discard the changes?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(false); // Return false to cancel pop
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(true); // Return true to proceed with pop
                    },
                    child: Text('Discard'),
                  ),
                ],
              );
            },
          );
          return confirm;
        }
        return true; // If no changes, allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _isSaveEnabled ? _saveChanges : null,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius:
                          60, // Reduced radius for a slightly smaller picture
                      backgroundImage: _genderController.text == "Male"
                          ? AssetImage('lib/assets/maleAvatar.png')
                          : AssetImage('lib/assets/femaleAvatar.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              for (var field in _inputFields) ...[
                field,
                SizedBox(height: 10),
              ],
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
              SizedBox(height: 10),
              multiChoice(),
            ],
          ),
        ),
      ),
    );
  }
}

enum BloodGroup {
  EMPTY,
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
    case BloodGroup.EMPTY:
      return '';
  }
}

BloodGroup stringToBloodGroup(String bloodGroupString) {
  switch (bloodGroupString) {
    case 'O+':
      return BloodGroup.O_POSITIVE;
    case 'O-':
      return BloodGroup.O_NEGATIVE;
    case 'A+':
      return BloodGroup.A_POSITIVE;
    case 'A-':
      return BloodGroup.A_NEGATIVE;
    case 'B+':
      return BloodGroup.B_POSITIVE;
    case 'B-':
      return BloodGroup.B_NEGATIVE;
    case 'AB+':
      return BloodGroup.AB_POSITIVE;
    case 'AB-':
      return BloodGroup.AB_NEGATIVE;
    case '':
      return BloodGroup.EMPTY;
    default:
      throw ArgumentError('Invalid blood group string: $bloodGroupString');
  }
}
