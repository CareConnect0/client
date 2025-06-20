import 'package:client/model/hasNotification.dart';
import 'package:client/model/notificationItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/api/Notification/notification_repository.dart';

final notificationRepositoryProvider = Provider(
  (ref) => NotificationRepository(),
);

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, List<NotificationItem>>(
      (ref) => NotificationViewModel(ref),
    );

class NotificationViewModel extends StateNotifier<List<NotificationItem>> {
  final Ref ref;

  NotificationViewModel(this.ref) : super([]) {
    fetchAllNotifications();
  }

  /// 알림 전체 조회
  Future<void> fetchAllNotifications() async {
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final notifications = await repo.fetchNotifications();
      state = notifications;
    } catch (e) {
      print('알림 불러오기 오류: $e');
    }
  }

  /// 알림 개별 삭제
  Future<void> deleteNotification(int notificationId) async {
    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.deleteNotification(notificationId);
      state = state.where((n) => n.notificationId != notificationId).toList();
    } catch (e) {
      print('알림 삭제 오류: $e');
    }
  }

  /// 알림 전체 삭제
  Future<void> deleteAllNotification() async {
    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.deleteAllNotification();
      state = [];
    } catch (e) {
      print('알림 전체 삭제 오류: $e');
    }
  }
}

final hasNotificationProvider =
    StateNotifierProvider<HasNotificationViewModel, HasNotification?>(
      (ref) => HasNotificationViewModel(ref),
    );

class HasNotificationViewModel extends StateNotifier<HasNotification?> {
  final Ref ref;

  HasNotificationViewModel(this.ref) : super(null) {
    fetchUnreadStatus();
  }

  Future<void> fetchUnreadStatus() async {
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final result = await repo.fetchUnreadNotifications();
      state = result;
    } catch (e) {
      print('알림 여부 조회 오류: $e');
    }
  }
}
