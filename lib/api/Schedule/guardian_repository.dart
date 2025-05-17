import 'dart:convert';

import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScheduleGuardianRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/guardian/schedules';

  /// 일정 등록(보호자)
  Future<void> enrollGuardianSchedule(ScheduleInfo info) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
      body: jsonEncode(
        {
          "dependentId": info.dependentId,
          "content": info.content,
          "startTime": info.startTime,
        },
      ),
    );

    if (response.statusCode == 201) {
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

  /// 일정 조회(보호자)
  Future<List<ScheduleInfo>> getGuardianScheduleList(
      int dependentId, DateTime selectedDate) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final url =
        Uri.parse('$_baseUrl?dependentId=$dependentId&date=$formattedDate');

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
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => ScheduleInfo.fromJson(e)).toList();
    } else {
      throw Exception('일정 조회 실패: ${response.statusCode}');
    }
  }

  /// 일정 수정(보호자)
  Future<void> modifyGuardianSchedule(ScheduleInfo info) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    if (info.scheduleId == null) {
      throw Exception('수정할 일정의 ID가 없습니다.');
    }

    final url = Uri.parse('$_baseUrl/${info.scheduleId}');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
      body: jsonEncode({
        "dependentId": info.dependentId,
        "content": info.content,
        "startTime": info.startTime,
      }),
    );
    print(info.scheduleId);
    print(info.dependentId);
    print(accessToken);
    print(refreshToken);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print(responseBody['message']);
      } else {
        throw Exception('일정 수정 실패 : ${responseBody['message']}');
      }
    } else {
      throw Exception('일정 수정 실패 : ${response.statusCode}');
    }
  }

  /// 일정 삭제(보호자)
  Future<void> deleteGuardianSchedule(int scheduleId, int dependentId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/$scheduleId?dependentId=$dependentId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print('일정 삭제 성공: ${responseBody['message']}');
      } else {
        throw Exception('일정 삭제 실패: ${responseBody['message']}');
      }
    } else {
      throw Exception('일정 삭제 실패: ${response.statusCode}');
    }
  }
}
