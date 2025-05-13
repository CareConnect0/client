import 'dart:convert';

import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/model/dependent.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:client/model/singUp.dart';

class UserRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api';
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://3.38.183.170:8080'));

  /// 회원가입
  Future<void> signup(SignupData data) async {
    final url = Uri.parse('$_baseUrl/users/signup');

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
        options: Options(
          headers: {
            'Authorization': accessToken,
          },
        ),
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

    final url = Uri.parse('$_baseUrl/users/link');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
      body: jsonEncode(
        {
          'guardianUsername': guardianUsername,
          'guardianName': guardianName,
        },
      ),
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
    final url = Uri.parse('$_baseUrl/users/dependent-list');
    final response = await http.get(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      print('피보호자 목록 조회 성공: ${response.body}');
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((e) => Dependent.fromJson(e)).toList();
    } else {
      print('피보호자 목록 조회 실패: ${response.body}');
      throw Exception('피보호자 목록 조회 실패: ${response.statusCode}');
    }
  }
}
