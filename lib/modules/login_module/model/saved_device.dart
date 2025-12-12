class SavedDevice {
  final int deviceId;
  final String password;
  final List<dynamic> dbList;

  SavedDevice({
    required this.deviceId,
    required this.password,
    required this.dbList,
  });

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "password": password,
    "dbList": dbList,
  };

  factory SavedDevice.fromJson(Map<String, dynamic> json) => SavedDevice(
    deviceId: json["deviceId"],
    password: json['password'],
    dbList: json["dbList"] != null ? List<dynamic>.from(json["dbList"]) : [],
    // dbList: List<dynamic>.from(json["dbList"]),
  );
}
