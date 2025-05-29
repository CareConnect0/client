class NotificationItem {
  final int notificationId;
  final String notificationType;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool read;
  final int? dependentId;

  NotificationItem({
    required this.notificationId,
    required this.notificationType,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.read,
    this.dependentId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'],
      notificationType: json['notificationType'],
      dependentId: json['targetId'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'],
    );
  }
}
