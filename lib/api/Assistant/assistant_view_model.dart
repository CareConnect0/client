import 'package:client/api/Assistant/assistant_repository.dart';
import 'package:client/model/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assistantViewModelProvider =
    StateNotifierProvider<AssistantViewModel, AssistantChatState>(
  (ref) => AssistantViewModel(ref),
);

final assistantRepositoryProvider = Provider((ref) => AssistantRepository());

class AssistantChatState {
  final List<Message> messages;
  final bool hasNext;
  final int? lastMessageId;

  AssistantChatState({
    required this.messages,
    required this.hasNext,
    required this.lastMessageId,
  });

  AssistantChatState.initial()
      : messages = [],
        hasNext = true,
        lastMessageId = null;
}

class AssistantViewModel extends StateNotifier<AssistantChatState> {
  final Ref ref;
  int? _roomId;

  AssistantViewModel(this.ref) : super(AssistantChatState.initial()) {
    loadInitialMessages();
  }

  Future<void> loadInitialMessages() async {
    try {
      final repo = ref.read(assistantRepositoryProvider);
      _roomId = await repo.getRoomId();
      await loadMoreMessages();
    } catch (e) {
      print('초기 메시지 로딩 에러: $e');
    }
  }

  Future<void> loadMoreMessages() async {
    if (_roomId == null || !state.hasNext) return;

    try {
      final repo = ref.read(assistantRepositoryProvider);
      final messages = await repo.getMessages(
        roomId: _roomId!,
        lastMessageId: state.lastMessageId,
      );

      final updatedMessages = [...state.messages, ...messages];
      final lastId = messages.isNotEmpty ? messages.last.messageId : null;

      state = AssistantChatState(
        messages: updatedMessages,
        hasNext: messages.isNotEmpty,
        lastMessageId: lastId,
      );
    } catch (e) {
      print('메시지 불러오기 실패: $e');
    }
  }

  /// 사용자 메시지 저장
  Future<void> sendMessage(String messageContent) async {
    if (_roomId == null) return;

    try {
      final repo = ref.read(assistantRepositoryProvider);
      final userMessage = await repo.sendUserMessage(
        roomId: _roomId!,
        requestMessage: messageContent,
      );

      state = AssistantChatState(
        messages: [userMessage, ...state.messages],
        hasNext: state.hasNext,
        lastMessageId: userMessage.messageId,
      );

      // 여기에 assistant 응답 기다리기 로직이 들어갈 수도 있음
    } catch (e) {
      print('메시지 전송 실패: $e');
    }
  }
}
