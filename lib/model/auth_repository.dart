import 'package:client/model/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<void> reissueToken() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('3.38.183.170:8080/api/auth/reissue');
    final response = await http.post(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

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

  final _dio = Dio(BaseOptions(baseUrl: 'http://3.38.183.170:8080'));

  Future<void> logout() async {
    final accessToken = await AuthStorage.getAccessToken();
    print('🔑 로그아웃 함수 진입 - accessToken: $accessToken');

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
}
