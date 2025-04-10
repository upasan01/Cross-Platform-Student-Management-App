import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> sendSignUpRequest({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3000/api/v1/user/signup');

    final body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response;
  }

}
