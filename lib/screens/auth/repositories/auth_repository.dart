import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final http.Client _client;

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, String>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('https://expense-tracker-mean.onrender.com/auth/login');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 200 || responseBody['success'] == false) {
      throw Exception(responseBody['message'] ?? 'Login failed');
    }

    //  Extract token and username
    final token = responseBody['data']['accessToken'];
    final userName = responseBody['data']['user']['userName'];

    return {
      'token': token,
      'userName': userName,
    };
  }

  Future<void> register({
    required String fullName,
    required String userName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('https://expense-tracker-mean.onrender.com/auth/register');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'userName': userName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }
}
