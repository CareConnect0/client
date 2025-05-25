import 'dart:convert';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/emergencyItem.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
  Future<Map<String, dynamic>> checkEmergency(int emergencyId) async {
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
        return jsonBody['data'];
      } else {
        throw Exception('비상 호출 확인 실패: ${jsonBody['message']}');
      }
    } else {
      throw Exception('비상 호출 확인 요청 실패: ${response.statusCode}');
    }
  }

  /// 비상 호출 음성 업로드
  Future<String> uploadAudioForEmergencyCall(String audioPath) async {
    final uri = Uri.parse('$_baseUrl/audio');

    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final request =
        http.MultipartRequest('POST', uri)
          ..headers.addAll({
            'Authorization': accessToken ?? '',
            'Refreshtoken': refreshToken ?? '',
          })
          ..files.add(
            await http.MultipartFile.fromPath(
              'audioFile',
              audioPath,
              contentType: MediaType('audio', 'wav'),
            ),
          );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final decoded = response.body;
      print('✅ 비상 호출 음성 업로드 성공: $decoded');
      final decodedJson = jsonDecode(response.body);
      final url = decodedJson['data']['url'];
      print('📝 비상 호출 음성 업로드: $url');
      return url;
    } else {
      print('❌ 비상 호출 음성 업로드 실패: ${response.statusCode}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      throw Exception('비상 호출 음성 업로드 실패');
    }
  }

  /// 비상 호출 생성 (음성 트리거)
  Future<void> createEmergencyFromAudioTrigger({
    required String audioUrl,
    required List<String> keywords,
  }) async {
    final uri = Uri.parse('$_baseUrl/audio-trigger');

    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final response = await http.post(
      uri,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"audioUrl": audioUrl, "keyword": keywords}),
    );

    if (response.statusCode == 200) {
      print("✅ 비상 호출 생성 성공");
      print("응답: ${response.body}");
    } else {
      print("❌ 비상 호출 생성 실패: ${response.statusCode}");
      print("응답: ${response.body}");
      throw Exception('비상 호출 생성 실패');
    }
  }
}
