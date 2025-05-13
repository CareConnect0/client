import 'package:client/api/Schedule/schedule_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleRepositoryProvider = Provider((ref) => ScheduleRepository());

final scheduleViewModelProvider =
    StateNotifierProvider<ScheduleViewModel, AsyncValue<void>>(
  (ref) => ScheduleViewModel(ref),
);

class ScheduleViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ScheduleViewModel(this.ref) : super(const AsyncData(null));

  /// 일정 등록(피보호자)
  Future<void> enrollSchedule(String content, String startTime) async {
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      await repo.enrollSchedule(content, startTime);
    } catch (e, st) {
      print('연결 실패: $e');
    }
  }
}
