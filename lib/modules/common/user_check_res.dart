class UserCheckRes {
  final String? note;
  final List<UserDbRes>? userDbResponse;
  final bool passwordValid;
  final String? message;
  final int status;

  UserCheckRes({
    this.note,
    this.userDbResponse,
    required this.passwordValid,
    this.message,
    required this.status,
  });

  factory UserCheckRes.fromJson(Map<String, dynamic> json) {
    return UserCheckRes(
      note: json['note'],
      userDbResponse: json['userDbResponse'] != null
          ? (json['userDbResponse'] as List)
          .map((e) => UserDbRes.fromJson(e))
          .toList()
          : null,
      passwordValid: json['passwordValid'] ?? false,
      message: json['message'],
      status: json['status'] ?? 0,
    );
  }
}

class UserDbRes {
  final int id;
  final String biznes;

  UserDbRes({required this.id, required this.biznes});

  factory UserDbRes.fromJson(Map<String, dynamic> json) {
    return UserDbRes(
      id: json['id'],
      biznes: json['biznes'],
    );
  }
}
