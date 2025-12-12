import 'package:hbmarket/modules/common/user_check_res.dart';

class LoginData {
  final String note;
  final List<UserDbRes>? userDbResponse;

  LoginData({required this.note, this.userDbResponse});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    note: json['note'] ?? '',
    userDbResponse: json['userDbResponse'] != null
        ? List<UserDbRes>.from(
        json['userDbResponse'].map((x) => UserDbRes.fromJson(x)))
        : null,
  );
  @override
  String toString() {
    return 'LoginData(note: $note, userDbResponse: $userDbResponse)';
  }
}