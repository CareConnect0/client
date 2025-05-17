import 'package:client/api/Assistant/assistant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assistantRepositoryProvider = Provider((ref) => AssistantRepository());

final assistantViewModelProvider =
    StateNotifierProvider<AssistantViewModel, AsyncValue<void>>(
  (ref) => AssistantViewModel(ref),
);

class AssistantViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AssistantViewModel(this.ref) : super(const AsyncData(null));

  /// 채팅방 조회
  Future<void> getRooms() async {
    try {
      final repo = ref.read(assistantRepositoryProvider);
      final roomId = await repo.getRoom();
      return roomId;
    } catch (e) {
      print('채팅방 조회 에러: $e');
    }
  }
}
