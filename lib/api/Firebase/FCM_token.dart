import 'dart:convert';

import 'package:client/api/Auth/auth_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<void> registerFcmToken() async {
  final accessToken = await AuthStorage.getAccessToken();
  final refreshToken = await AuthStorage.getRefreshToken();

  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken == null) {
    print('FCM 토큰을 가져올 수 없음');
    return;
  }
  print(fcmToken);

  final url = Uri.parse('http://3.38.183.170:8080/api/fcm/register');

  final response = await http.post(
    url,
    headers: {
      'Authorization': accessToken ?? '',
      'Refreshtoken': refreshToken ?? '',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'token': fcmToken}),
  );

  print('응답 상태 코드: ${response.statusCode}');
  print('응답 바디: ${response.body}');

  if (response.statusCode == 201) {
    print('FCM 토큰 등록 완료');
  } else {
    print('FCM 토큰 등록 실패: ${response.body}');
  }
}
