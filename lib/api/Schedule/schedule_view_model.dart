import 'package:client/api/Schedule/schedule_repository.dart';
import 'package:client/model/YearMonth.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final scheduleRepositoryProvider = Provider((ref) => ScheduleRepository());

final scheduleViewModelProvider =
    StateNotifierProvider<ScheduleViewModel, AsyncValue<void>>(
  (ref) => ScheduleViewModel(ref),
);

/// 월별 일정 조회(피보호자)
final scheduleMonthProvider =
    FutureProvider.family<List<DateTime>, YearMonth>((ref, ym) async {
  ref.keepAlive();
  final repo = ref.read(scheduleRepositoryProvider);
  final dateList = await repo.getScheduleMonthList(ym.year, ym.month);
  return dateList;
});

class ScheduleViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ScheduleViewModel(this.ref) : super(const AsyncData(null));

  /// 일정 등록(피보호자)
  Future<void> enrollSchedule(ScheduleInfo info) async {
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      await repo.enrollSchedule(info);
    } catch (e) {
      print('일정 등록 에러: $e');
    }
  }

  /// 일정 조회(피보호자)
  Future<void> getSchedules(DateTime selectedDate) async {
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      final schedules = await repo.getScheduleList(selectedDate);
      ref.read(scheduleProvider.notifier).setSchedulesFromAPI(schedules);
    } catch (e) {
      print('일정 조회 에러: $e');
    }
  }

  /// 일정 수정(피보호자)
  Future<void> modifySchedule(ScheduleInfo info) async {
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      await repo.modifySchedule(info);
    } catch (e) {
      print('일정 수정 에러: $e');
    }
  }

  /// 일정 삭제(피보호자)
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      await repo.deleteSchedule(scheduleId);
    } catch (e) {
      print('일정 삭제 에러: $e');
    }
  }
}
