import 'package:client/api/Chatting/chatting_repository.dart';
import 'package:client/model/availableUser.dart';
import 'package:client/model/chatMessage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chattingRepositoryProvider = Provider((ref) => ChattingRepository());

final chattingViewModelProvider =
    StateNotifierProvider<ChattingViewModel, AsyncValue<List<AvailableUser>>>((
      ref,
    ) {
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

  /// 채팅 메시지 불러오기 (스크롤 지원)
  Future<ChatMessagesResponse> getChatMessages({
    required int roomId,
    int? lastMessageId,
    int size = 20,
  }) async {
    try {
      final repo = ref.read(chattingRepositoryProvider);
      final response = await repo.getChatMessages(
        roomId: roomId,
        lastMessageId: lastMessageId,
        size: size,
      );
      return response;
    } catch (e) {
      print('채팅 메시지 조회 실패: $e');
      rethrow;
    }
  }
}

final messengerViewModelProvider = StateNotifierProvider.autoDispose
    .family<MessengerViewModel, AsyncValue<List<ChatMessage>>, int>((
      ref,
      roomId,
    ) {
      return MessengerViewModel(ref, roomId);
    });

class MessengerViewModel extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final Ref ref;
  final int roomId;
  List<ChatMessage> _messages = [];
  bool _hasNext = true;
  bool _isLoading = false;

  MessengerViewModel(this.ref, this.roomId) : super(const AsyncLoading()) {
    loadInitialMessages();
  }

  void addMessage(ChatMessage newMessage) {
    _messages.insert(0, newMessage); // 최신 메시지가 위로 가도록
    state = AsyncValue.data([..._messages]);
  }

  Future<void> loadInitialMessages() async {
    try {
      final repo = ref.read(chattingRepositoryProvider);
      final response = await repo.getChatMessages(roomId: roomId);
      _messages = response.messages;
      _hasNext = response.hasNext;
      state = AsyncValue.data(_messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMoreMessages() async {
    if (!_hasNext || _isLoading || _messages.isEmpty) return;

    _isLoading = true;
    final lastId = _messages.last.messageId;

    try {
      final repo = ref.read(chattingRepositoryProvider);
      final response = await repo.getChatMessages(
        roomId: roomId,
        lastMessageId: lastId,
      );
      _messages.addAll(response.messages);
      _hasNext = response.hasNext;
      state = AsyncValue.data([..._messages]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }
}
