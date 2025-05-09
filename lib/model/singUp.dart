class SignupData {
  final String username;
  final String password;
  final String userType;
  final String? name;
  final String? phoneNumber;

  SignupData({
    required this.username,
    required this.password,
    required this.userType,
    this.name,
    this.phoneNumber,
  });

  SignupData copyWith({
    String? username,
    String? password,
    String? userType,
    String? name,
    String? phoneNumber,
  }) {
    return SignupData(
      username: username ?? this.username,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'userType': userType,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}
