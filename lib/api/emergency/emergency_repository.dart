import 'dart:convert';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/emergencyItem.dart';
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

  /// 비상 호출 조회
  Future<List<EmergencyItem>> getEmergencyList(int dependentId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl?dependentId=$dependentId');
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
      if (jsonBody['success']) {
        final List data = jsonBody['data'];
        print(data);
        return data.map((e) => EmergencyItem.fromJson(e)).toList();
      } else {
        throw Exception('비상 호출 데이터 조회 실패: ${jsonBody['message']}');
      }
    } else {
      throw Exception('서버 에러: ${response.statusCode}');
    }
  }

  /// 단일 비상 호출 확인
  Future<String> checkEmergency(int emergencyId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/$emergencyId');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedResponse);
      if (jsonBody['success']) {
        return jsonBody['data']['dependentName'];
      } else {
        throw Exception('비상 호출 확인 실패: ${jsonBody['message']}');
      }
    } else {
      throw Exception('비상 호출 확인 요청 실패: ${response.statusCode}');
    }
  }
}
