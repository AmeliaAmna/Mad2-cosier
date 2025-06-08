import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; // Laravel API

  /// Login Function
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return {
      'status': response.statusCode,
      'body': response.body.isNotEmpty ? jsonDecode(response.body) : {},
    };
  }

  /// Signup Function
  static Future<Map<String, dynamic>> signup(
    String firstName, String lastName, String email, String password) async {
  final fullName = '$firstName $lastName';

  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': fullName,
      'email': email,
      'password': password,
      'role': 'user', // optional but included to match Laravel expectations
    }),
  );

  return {
    'status': response.statusCode,
    'body': response.body.isNotEmpty ? jsonDecode(response.body) : {},
  };
}


  
}
