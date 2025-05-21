import 'dart:convert';
import 'package:client/model/notificationItem.dart';
import 'package:http/http.dart' as http;
import 'package:client/api/Auth/auth_storage.dart';

class NotificationRepository {
  final String _baseUrl = 'http://3.38.183.170:8080/api/notifications';

  /// 알림 전체 조회
  Future<List<NotificationItem>> fetchNotifications() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl');

    final response = await http.get(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final List data = body['data'];
      return data.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception('알림 조회 실패: ${response.statusCode}');
    }
  }

  /// 알림 개별 삭제
  Future<void> deleteNotification(int notificationId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final url = Uri.parse('$_baseUrl/$notificationId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('알림 삭제 실패: ${response.statusCode}');
    }
  }
}
