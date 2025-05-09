import 'package:client/screens/emergency/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationNotifier()
      : super([
          // NotificationItem(
          //     id: '1', time: '2025년 3월 24일\n07시 30분의 알람', voice: '도와주세요'),
          // NotificationItem(
          //     id: '2', time: '2025년 3월 25일\n13시 05분의 알람', voice: '살려주세요'),
          // NotificationItem(
          //     id: '3', time: '2025년 3월 26일\n19시 10분의 알람', voice: '응급상황'),
        ]);

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          NotificationItem(
              id: item.id, time: item.time, voice: item.voice, isRead: true)
        else
          item,
    ];
  }
}
