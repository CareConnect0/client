import 'package:client/api/emergency/emergency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emergencyRepositoryProvider = Provider((ref) => EmergencyRepository());

final emergencyViewModelProvider =
    StateNotifierProvider<EmergencyViewModel, AsyncValue<void>>(
  (ref) => EmergencyViewModel(ref),
);

class EmergencyViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  EmergencyViewModel(this.ref) : super(const AsyncData(null));

  /// 비상 호출
  Future<void> enrollEmergency() async {
    try {
      final repo = ref.read(emergencyRepositoryProvider);
      await repo.enrollEmergency();
    } catch (e) {
      print('비상 호출 에러: $e');
    }
  }
}
