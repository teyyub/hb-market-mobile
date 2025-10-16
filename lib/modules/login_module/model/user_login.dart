class UserLogin {
  final String username;
  final String password;

  UserLogin({required this.username, required this.password});

  /// Convert to JSON for API request
  Map<String, dynamic> toJson({int? deviceId, bool forceLogin = false}) {
    return {
      "username": username,
      "password": password,
      "deviceId": deviceId,
      "forceLogin": forceLogin,
    };
  }

  @override
  String toString() {
    return 'UserLogin(username: $username, password: ${'*' * password.length} )';
  }
}
