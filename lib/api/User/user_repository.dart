import 'dart:convert';
import 'dart:io';

import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/dependent.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:client/model/singUp.dart';
import 'package:http_parser/http_parser.dart';

class UserRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/users';
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://3.38.183.170:8080'));

  /// 회원가입
  Future<void> signup(SignupData data) async {
    final url = Uri.parse('$_baseUrl/signup');

    print('📦 보내는 데이터: ${jsonEncode(data.toJson())}');

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

  /// 회원탈퇴
  Future<void> withdraw(String password) async {
    final accessToken = await AuthStorage.getAccessToken();

    print('🔐 탈퇴 시도 - accessToken: $accessToken');
    print('📩 전달할 패스워드: $password');

    try {
      final response = await _dio.patch(
        '/api/users/withdrawal',
        data: {'password': password},
        options: Options(headers: {'Authorization': accessToken}),
      );
      print('✅ 회원탈퇴 성공: ${response.data}');
    } catch (e) {
      print('❌ 회원탈퇴 실패: $e');
      rethrow;
    } finally {
      await AuthStorage.clear();
    }
  }

  /// 피보호자-보호자 연결
  Future<void> linkfamily(String guardianUsername, String guardianName) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();
    print('보내는 토큰: $accessToken');
    print('보내는 데이터: $guardianUsername, $guardianName');

    final url = Uri.parse('$_baseUrl/link');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
      body: jsonEncode({
        'guardianUsername': guardianUsername,
        'guardianName': guardianName,
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print(responseBody['message']);
      } else {
        throw Exception('피보호자-보호자 연결 실패: ${responseBody['message']}');
      }
    } else {
      throw Exception('피보호자-보호자 연결 실패: ${response.statusCode}');
    }
  }

  /// 피보호자 목록 조회
  Future<List<Dependent>> getDependentList() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    print('보내는 토큰: $accessToken');
    final url = Uri.parse('$_baseUrl/dependent-list');
    final response = await http.get(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      // print('피보호자 목록 조회 성공: ${response.body}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedResponse);
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => Dependent.fromJson(e)).toList();
    } else {
      print('피보호자 목록 조회 실패: ${response.body}');
      throw Exception('피보호자 목록 조회 실패: ${response.statusCode}');
    }
  }

  /// 아이디 중복 확인
  Future<bool> checkUsername(String username) async {
    final url = Uri.parse('$_baseUrl/check-username?username=$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('일정 조회 실패: ${response.statusCode}');
    }
  }

  /// 회원 정보 조회
  Future<Map<String, dynamic>> getMine() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();
    final url = Uri.parse('$_baseUrl/me');
    final response = await http.get(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );
    if (response.statusCode == 200) {
      // print('회원 정보 조회 성공: ${response.body}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonBody = jsonDecode(decodedResponse);
      final data = jsonBody['data'];
      return data;
    } else {
      print('회원 정보 조회 실패: ${response.body}');
      throw Exception('회원 정보 조회 실패: ${response.statusCode}');
    }
  }

  /// 비밀번호 변경
  Future<void> getChangePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();
    final url = Uri.parse('$_baseUrl/password');
    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': accessToken ?? '',
          'Refreshtoken': refreshToken ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // 성공 처리
        return;
      } else {
        final jsonBody = jsonDecode(response.body);
        final messageStr = jsonBody['message'];
        final messageJson = jsonDecode(messageStr); // <- 두 번째 파싱

        // 여기서 newPassword 필드가 있는지 확인
        final errorMsg = messageJson['newPassword'] ?? '알 수 없는 오류가 발생했습니다.';

        throw Exception(errorMsg);
      }
    } catch (e) {
      // UI 쪽에서 이 메시지를 catch해서 보여주기
      print('에러: $e');
      rethrow;
    }
  }

  /// 프로필 사진 변경
  Future<void> uploadProfileImage([File? imageFile]) async {
    final uri = Uri.parse('$_baseUrl/profile');
    final request = http.MultipartRequest('PATCH', uri);

    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    request.headers['Authorization'] = accessToken ?? '';
    request.headers['Refreshtoken'] = refreshToken ?? '';

    if (imageFile != null) {
      final fileName = imageFile.path.split('/').last;
      final fileExtension = fileName.split('.').last;

      request.files.add(
        await http.MultipartFile.fromPath(
          'imageFile',
          imageFile.path,
          contentType: MediaType('image', fileExtension),
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print("✅ 프로필 사진 변경 성공");
    } else {
      print("❌ 프로필 사진 변경 실패: ${response.statusCode}");
      final responseBody = await response.stream.bytesToString();
      print("응답 내용: $responseBody");
    }
  }
}
