class Message {
  final int messageId;
  final String senderType;
  final String content;
  final String sentAt;

  Message({
    required this.messageId,
    required this.senderType,
    required this.content,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      senderType: json['senderType'],
      content: json['content'],
      sentAt: json['sentAt'],
    );
  }
}

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
