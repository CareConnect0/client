class Dependent {
  final int dependentId;
  final String username;
  final String name;

  Dependent({
    required this.dependentId,
    required this.username,
    required this.name,
  });

  factory Dependent.fromJson(Map<String, dynamic> json) {
    return Dependent(
      dependentId: json['dependentId'],
      username: json['username'],
      name: json['name'],
    );
  }
}
