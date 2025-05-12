import 'dart:convert';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api';
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://3.38.183.170:8080'));

  /// 로그인
  Future<Map<String, String>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final accessToken = response.headers['authorization'] ?? '';
      final refreshToken = response.headers['refreshtoken'] ?? '';

      // 토큰 저장
      await AuthStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  }

  /// 토큰 재발급
  Future<void> reissueToken() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/auth/reissue');

    final response = await http.post(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    print('🔁 재발급 응답: ${response.statusCode} / ${response.body}');

    if (response.statusCode == 200) {
      final newAccessToken = response.headers['authorization'] ?? '';
      final newRefreshToken = response.headers['refreshtoken'] ?? '';

      await AuthStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
    } else {
      throw Exception('토큰 재발급 실패: ${response.reasonPhrase}');
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    final accessToken = await AuthStorage.getAccessToken();
    print('🔑 로그아웃 시작 - accessToken: $accessToken');

    try {
      await _dio.patch(
        '/api/auth/logout',
        options: Options(
          headers: {'Authorization': accessToken},
        ),
      );
    } catch (e) {
      print('❌ 로그아웃 API 호출 실패: $e');
    } finally {
      await AuthStorage.clear();
    }
  }

  /// 전화번호 인증 전송
  Future<void> sendVerificationCode(String phoneNumber) async {
    final url = Uri.parse('$_baseUrl/auth/verification-code');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print('✅ ${responseBody['message']}');
      } else {
        throw Exception('휴대폰 인증번호 전송 실패: ${responseBody['message']}');
      }
    } else {
      throw Exception('휴대폰 인증번호 전송 실패: ${response.statusCode}');
    }
  }

  /// 전화번호 인증코드 확인
  Future<void> verifyPhoneVerificationCode(
      String phoneNumber, String code) async {
    final url = Uri.parse('$_baseUrl/auth/verification-code');

    final body = jsonEncode({
      'phoneNumber': phoneNumber,
      'code': code,
    });

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('인증번호 확인 성공: ${responseBody['message']}');
      } else {
        print('인증번호 확인 실패: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('API 호출 실패: $e');
    }
  }
}
