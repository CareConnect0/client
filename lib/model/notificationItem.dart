class NotificationItem {
  final int notificationId;
  final String notificationType;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool read;

  NotificationItem({
    required this.notificationId,
    required this.notificationType,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.read,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'],
      notificationType: json['notificationType'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'],
    );
  }
}
