import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> login(String username, String password) async {
  try {
    final url =
        Uri.parse('http://10.0.2.2:8000/authentication/login/dispatcher/');
    final response = await http.post(
      url,
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  } catch (e) {
    print('Error during login: $e');
    // Handle error (e.g., return a custom error response)
    throw Exception('Failed to login: $e');
  }
}
