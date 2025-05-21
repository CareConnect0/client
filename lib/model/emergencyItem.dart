class EmergencyItem {
  final int emergencyId;
  final DateTime createdAt;
  final bool checked;
  final List<String>? keyword;

  EmergencyItem({
    required this.emergencyId,
    required this.createdAt,
    required this.checked,
    this.keyword,
  });

  factory EmergencyItem.fromJson(Map<String, dynamic> json) {
    return EmergencyItem(
      emergencyId: json['emergencyId'],
      createdAt: DateTime.parse(json['createdAt']), // ← 이 부분 중요!
      checked: json['checked'],
      keyword: List<String>.from(json['keyword'] ?? []),
    );
  }
}
