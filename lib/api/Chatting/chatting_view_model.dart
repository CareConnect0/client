import 'package:client/api/Chatting/chatting_repository.dart';
import 'package:client/model/availableUser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chattingRepositoryProvider = Provider((ref) => ChattingRepository());

final chattingViewModelProvider =
    StateNotifierProvider<ChattingViewModel, AsyncValue<List<AvailableUser>>>(
        (ref) {
  return ChattingViewModel(ref)..getAvailableUsers();
});

class ChattingViewModel extends StateNotifier<AsyncValue<List<AvailableUser>>> {
  final Ref ref;

  ChattingViewModel(this.ref) : super(const AsyncLoading());

  Future<void> getAvailableUsers() async {
    try {
      final repo = ref.read(chattingRepositoryProvider);
      final users = await repo.getAvailableUsers();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> getRoomId(int targetId) async {
    try {
      final repo = ref.read(chattingRepositoryProvider);
      final roomId = await repo.getRoomId(targetId);
      return roomId;
    } catch (e) {
      print('메시지 불러오기 실패: $e');
      return 0;
    }
  }
}
