class DeviceLogin {
  final int deviceId;
  final String? password;

  DeviceLogin({required this.deviceId, required this.password});

  /// Convert to JSON for API request
  Map<String, dynamic> toJson({int? deviceId, String? password}) {
    return {
      "password": password,
      "deviceId": deviceId,
    };
  }

  @override
  String toString() {
    return 'DeviceLogin(: $deviceId, password: ${'*' * password!.length} )';
  }
}
