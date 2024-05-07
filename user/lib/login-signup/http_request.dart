import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

Future<void> saveToken(String token) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getToken() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'auth_token');
}

Future<bool> isLoggedIn() async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  return token != null && token.isNotEmpty;
}

Future<http.Response> signUp(_username, _email, _password, _firstName,
    _lastName, _phoneNumber, _gender, _dateOfBirth, _address) async {
  final url = Uri.parse('http://10.0.2.2:8000/authentication/signup/');

  final response = await http.post(
    url,
    body: jsonEncode({
      "email": _email,
      "username": _username,
      "password": _password,
      "first_name": _firstName,
      "last_name": _lastName,
      "phone_number": _phoneNumber,
      "gender": _gender,
      "date_of_birth": DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
      "address": _address,
      "role": "User"
    }),
    headers: {'Content-Type': 'application/json'},
  );

  return response;
}

Future<http.Response> signUp2(_username, _blood_group) async {
  final url = Uri.parse('http://10.0.2.2:8000/authentication/signup2/');

  final response = await http.post(
    url,
    body: jsonEncode({"username": _username, "blood_group": _blood_group}),
    headers: {'Content-Type': 'application/json'},
  );

  return response;
}

Future<http.Response> login(username, password) async {
  final url = Uri.parse('http://10.0.2.2:8000/authentication/login/');
  final response = await http.post(
    url,
    body: jsonEncode({'username': username, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );
  return response;
}

void logout() async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'auth_token');
}
