import 'package:client/api/Assistant/assistant_repository.dart';
import 'package:client/api/ai/ai_repository.dart';
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
    _init();
  }

  bool _isConnected = false;

  Future<void> _init() async {
    final repo = ref.read(assistantRepositoryProvider);

    await repo.connectSocket(
      onConnected: () async {
        _isConnected = true;

        try {
          _roomId = await repo.getRoomId();
          await loadMoreMessages();

          repo.subscribeToRoom(_roomId!, (msg) {
            final message = Message.fromJson(msg);
            print('msg :$msg');
            state = AssistantChatState(
              messages: [message, ...state.messages],
              hasNext: state.hasNext,
              lastMessageId: message.messageId,
            );
          });
        } catch (e) {
          print('초기 메시지 로딩 에러: $e');
        }
      },
    );
  }

  Future<void> loadInitialMessages() async {
    if (!_isConnected) {
      print('⛔ 소켓 연결 전이라 초기 메시지 로딩 생략');
      return;
    }

    try {
      final repo = ref.read(assistantRepositoryProvider);
      _roomId = await repo.getRoomId();
      await loadMoreMessages();

      repo.subscribeToRoom(_roomId!, (msg) {
        final message = Message.fromJson(msg);
        state = AssistantChatState(
          messages: [message, ...state.messages],
          hasNext: state.hasNext,
          lastMessageId: message.messageId,
        );
      });
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

      // 사용자 메시지 AI에게 전송
      final tts = AIRepository();
      final responseMessage = await tts.getAssistantAnswer(
        _roomId!,
        messageContent,
      );
      // AI 답변 메시지 전송
      await repo.sendAIMessage(
        roomId: _roomId!,
        responseMessage: responseMessage,
      );
    } catch (e) {
      print('메시지 전송 실패: $e');
    }
  }
}
