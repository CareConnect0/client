import 'dart:convert';

import 'package:client/api/Auth/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ScheduleRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api';
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://3.38.183.170:8080'));

  /// 일정 등록(피보호자)
  Future<void> enrollSchedule(String content, String startTime) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/schedule');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
      body: jsonEncode({
        'content': content,
        'startTime': startTime,
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print(responseBody['message']);
      } else {
        throw Exception('일정 등록 성공 : ${responseBody['message']}');
      }
    } else {
      throw Exception('일정 등록 실패 : ${response.statusCode}');
    }
  }
}
