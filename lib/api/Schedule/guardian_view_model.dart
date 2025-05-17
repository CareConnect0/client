import 'package:client/api/Schedule/guardian_repository.dart';
import 'package:client/model/YearMonth.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleGuardianRepositoryProvider =
    Provider((ref) => ScheduleGuardianRepository());

final scheduleGuardianViewModelProvider =
    StateNotifierProvider<ScheduleViewModel, AsyncValue<void>>(
  (ref) => ScheduleViewModel(ref),
);

/// 월별 일정 조회(보호자)
final scheduleMonthGuardianProvider =
    FutureProvider.family<List<DateTime>, YearMonthGuardian>((ref, ym) async {
  ref.keepAlive();
  final repo = ref.read(scheduleGuardianRepositoryProvider);
  final dateList =
      await repo.getScheduleMonthList(ym.dependentId, ym.year, ym.month);
  return dateList;
});

class ScheduleViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ScheduleViewModel(this.ref) : super(const AsyncData(null));

  /// 일정 등록(보호자)
  Future<void> enrollGuardianSchedule(ScheduleInfo info) async {
    try {
      final repo = ref.read(scheduleGuardianRepositoryProvider);
      await repo.enrollGuardianSchedule(info);
    } catch (e) {
      print('일정 등록 에러: $e');
    }
  }

  /// 일정 조회(보호자)
  Future<void> getGuardianSchedules(
      int dependentId, DateTime selectedDate) async {
    try {
      final repo = ref.read(scheduleGuardianRepositoryProvider);
      final schedules =
          await repo.getGuardianScheduleList(dependentId, selectedDate);
      ref.read(scheduleProvider.notifier).setSchedulesFromAPI(schedules);
    } catch (e) {
      print('일정 조회 에러: $e');
    }
  }

  /// 일정 수정(보호자)
  Future<void> modifyGuardianSchedule(ScheduleInfo info) async {
    try {
      final repo = ref.read(scheduleGuardianRepositoryProvider);
      await repo.modifyGuardianSchedule(info);
    } catch (e) {
      print('일정 수정 에러: $e');
    }
  }

  /// 일정 삭제(보호자)
  Future<void> deleteGuardianSchedule(int scheduleId, int dependentId) async {
    try {
      final repo = ref.read(scheduleGuardianRepositoryProvider);
      await repo.deleteGuardianSchedule(scheduleId, dependentId);
    } catch (e) {
      print('일정 삭제 에러: $e');
    }
  }
}
