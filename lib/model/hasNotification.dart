class HasNotification {
  final bool hasUnreadSchedule;
  final bool hasUnreadChat;
  final bool hasUnreadEmergency;

  HasNotification({
    required this.hasUnreadSchedule,
    required this.hasUnreadChat,
    required this.hasUnreadEmergency,
  });

  factory HasNotification.fromJson(Map<String, dynamic> json) {
    return HasNotification(
      hasUnreadSchedule: json['hasUnreadSchedule'] ?? false,
      hasUnreadChat: json['hasUnreadChat'] ?? false,
      hasUnreadEmergency: json['hasUnreadEmergency'] ?? false,
    );
  }
}
