import 'dart:convert';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:http/http.dart' as http;

class EmergencyRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/emergency';

  /// 비상 호출
  Future<void> enrollEmergency() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );
    if (response.statusCode == 201) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedResponse);
      if (jsonBody['success']) {
        print(jsonBody['message']);
      } else {
        throw Exception('비상호출 성공 : ${jsonBody['message']}');
      }
    } else {
      throw Exception('비상호출 실패 : ${response.statusCode}');
    }
  }
}
