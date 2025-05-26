class AvailableUser {
  final int userId;
  final String name;
  final String profileUrl;

  AvailableUser({
    required this.userId,
    required this.name,
    required this.profileUrl,
  });

  factory AvailableUser.fromJson(Map<String, dynamic> json) {
    return AvailableUser(
      userId: json['userId'],
      name: json['name'],
      profileUrl: json['profileUrl'] ?? '',
    );
  }
}
