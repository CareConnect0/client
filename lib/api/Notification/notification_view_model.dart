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

  Future<void> fetchAllNotifications() async {
    try {
      final repo = ref.read(notificationRepositoryProvider);
      final notifications = await repo.fetchNotifications();
      state = notifications;
    } catch (e) {
      print('알림 불러오기 오류: $e');
    }
  }
}
