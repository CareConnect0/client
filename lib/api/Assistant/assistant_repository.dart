import 'dart:convert';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/message.dart';
import 'package:http/http.dart' as http;

class AssistantRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/assistant';

  /// 채팅방 조회
  Future<int> getRoomId() async {
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
      final data = jsonBody['data']['roomId'];
      return data;
    } else {
      throw Exception('채팅방 조회 실패: ${response.statusCode}');
    }
  }

  /// 채팅방 대화내역 조회 (스크롤 기반)
  Future<List<Message>> getMessages({
    required int roomId,
    int? lastMessageId,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/rooms/$roomId?lastMessageId=${lastMessageId ?? ''}',
    );

    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
      final data = jsonBody['data'];
      print('메시지 데이터: $data');
      return (data['responseDtoList'] as List)
          .map((e) => Message.fromJson(e))
          .toList();
    } else {
      throw Exception('메시지 불러오기 실패: ${response.statusCode}');
    }
  }

  Future<bool> hasNextMessages({
    required Map<String, dynamic> data,
  }) async {
    return data['hasNext'];
  }

  /// 사용자 메시지 저장
  Future<Message> sendUserMessage({
    required int roomId,
    required String requestMessage,
  }) async {
    final url = Uri.parse('$_baseUrl/request');
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'roomId': roomId,
        'requestMessage': requestMessage,
      }),
    );

    if (response.statusCode == 201) {
      final jsonBody = jsonDecode(utf8.decode(response.bodyBytes));
      final data = jsonBody['data'];
      print('사용자 메시지 전송 성공: $data');
      return Message.fromJson(data);
    } else {
      throw Exception('사용자 메시지 전송 실패: ${response.statusCode}');
    }
  }
}
