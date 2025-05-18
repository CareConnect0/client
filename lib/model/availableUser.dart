class AvailableUser {
  final int userId;
  final String name;

  AvailableUser({required this.userId, required this.name});

  factory AvailableUser.fromJson(Map<String, dynamic> json) {
    return AvailableUser(
      userId: json['userId'],
      name: json['name'],
    );
  }
}
