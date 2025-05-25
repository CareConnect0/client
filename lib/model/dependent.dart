class Dependent {
  final int dependentId;
  final String username;
  final String name;
  final String profileUrl;

  Dependent({
    required this.dependentId,
    required this.username,
    required this.name,
    required this.profileUrl,
  });

  factory Dependent.fromJson(Map<String, dynamic> json) {
    return Dependent(
      dependentId: json['dependentId'],
      username: json['username'],
      name: json['name'],
      profileUrl: json['profileUrl'],
    );
  }
}
