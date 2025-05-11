import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api';

  Future<Map<String, String>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final accessToken = response.headers['authorization'] ?? '';
      final refreshToken = response.headers['refreshtoken'] ?? '';
      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }
}
