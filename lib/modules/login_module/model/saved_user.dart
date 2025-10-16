class SavedUser {
  final String username;
  final String password;
  final String? token;
  final List<dynamic> dbList;

  SavedUser({
    required this.username,
    required this.password,
    required this.token,
    required this.dbList,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    // "token": token,
    "dbList": dbList,
  };

  factory SavedUser.fromJson(Map<String, dynamic> json) => SavedUser(
    username: json["username"],
    password: json['password'],
    token: json["token"],
    dbList: List<dynamic>.from(json["dbList"]),
  );
}
