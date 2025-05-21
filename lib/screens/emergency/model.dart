class EmergencyNotificationItem {
  final String id;
  final String time;
  final String voice;
  bool isRead;

  EmergencyNotificationItem({
    required this.id,
    required this.time,
    required this.voice,
    this.isRead = false,
  });
}
