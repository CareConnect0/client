import 'dart:convert';

import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/availableUser.dart';
import 'package:client/model/chatMessage.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChattingRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/chats';

  /// 채팅 상대 조회
  Future<List<AvailableUser>> getAvailableUsers() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/available-users');

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
      final data = jsonBody['data'] as List;

      return data.map((e) => AvailableUser.fromJson(e)).toList();
    } else {
      throw Exception('채팅 상대 조회 실패: ${response.statusCode}');
    }
  }

  /// 해당 상대와의 채팅방 조회
  Future<int> getRoomId(int targetId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/rooms');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
      body: jsonEncode({'targetId': targetId}),
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedResponse);
      final data = jsonBody['data']['roomId'];
      return data;
    } else {
      throw Exception('해당 상대와의 채팅방 조회 실패: ${response.statusCode}');
    }
  }

  /// 채팅방 대화내역 조회
  Future<ChatMessagesResponse> getChatMessages({
    required int roomId,
    int? lastMessageId,
    int size = 20,
  }) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final queryParams = {
      if (lastMessageId != null) 'lastMessageId': lastMessageId.toString(),
      'size': size.toString(),
    };

    final uri = Uri.http(
      '3.38.183.170:8080',
      '/api/chats/rooms/$roomId',
      queryParams,
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final json = jsonDecode(decoded);
      return ChatMessagesResponse.fromJson(json['data']);
    } else {
      throw Exception('채팅 메시지 조회 실패: ${response.statusCode}');
    }
  }

  late StompClient stompClient;

  /// 소켓 연결
  Future<void> connectSocket() async {
    final accessToken = await AuthStorage.getAccessToken();

    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://3.38.183.170:8080/ws',
        onConnect: onConnectCallback,
        beforeConnect: () async {
          print('📡 웹소켓 연결 준비 중...');
          await Future.delayed(Duration(milliseconds: 200));
        },
        onWebSocketError: (dynamic error) => print('❌ 웹소켓 에러: $error'),
        stompConnectHeaders: {'Authorization': accessToken ?? ''},
        webSocketConnectHeaders: {'Authorization': accessToken ?? ''},
        onDisconnect: (frame) => print('🔌 연결 종료'),
        // Optional
        onDebugMessage: (msg) => print('🐞 STOMP 디버그: $msg'),
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    print('✅ STOMP 연결 완료');
  }
}
