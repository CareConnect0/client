class ChatMessage {
  final int messageId;
  final int senderId;
  final String senderName;
  final String content;
  final DateTime sentAt;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'] ?? '',
      sentAt: DateTime.parse(json['sentAt'] ?? json['createdAt']),
    );
  }
}

class ChatMessagesResponse {
  final List<ChatMessage> messages;
  final bool hasNext;

  ChatMessagesResponse({required this.messages, required this.hasNext});

  factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    final list = json['responseDtoList'] as List;
    return ChatMessagesResponse(
      messages: list.map((e) => ChatMessage.fromJson(e)).toList(),
      hasNext: json['hasNext'] as bool,
    );
  }
}
