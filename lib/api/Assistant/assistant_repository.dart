import 'dart:convert';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:http/http.dart' as http;

class AssistantRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/assistant';

  /// 채팅방 조회
  Future<void> getRoom() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/rooms');

    final response = await http.get(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedResponse);
      final data = jsonBody['data'];
      print(data);
      return data;
    } else {
      throw Exception('채팅방 조회 실패: ${response.statusCode}');
    }
  }
}
