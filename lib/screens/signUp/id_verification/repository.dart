import 'dart:convert';

import 'package:client/model/singUp.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<void> signup(SignupData data) async {
    final url = Uri.parse('http://3.38.183.170:8080/api/users/signup');

    print('보내는 데이터: ${jsonEncode(data.toJson())}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode != 201) {
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(decodedBody['message'] ?? '회원가입 실패');
    }
  }
}
