import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hbmarket/modules/common/api_response.dart';
import 'package:hbmarket/modules/login_module/model/device_login.dart';
import 'package:hbmarket/modules/login_module/model/saved_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../http/api_class.dart';
import '../../common/login_data.dart';


class DeviceService {
   ApiClient client = new ApiClient();


  /// Login function
  Future<ApiResponse<LoginData>> loginV3(DeviceLogin device) async {
    final response = await client.post(
      '/api/auth/v4/login',
      body: device.toJson(deviceId: device.deviceId, password:device.password),
    );
    final json = jsonDecode(response.body);
    return ApiResponse<LoginData>.fromJson(
        json,
            (data) =>LoginData.fromJson(Map<String, dynamic>.from(data)));
  }



  // Future<Map<String, dynamic>> deviceCheck(int deviceId) async {
  //   final response = await client.post(
  //     '/api/auth/v3/device-check',
  //     body: {'deviceId': deviceId}
  //   );
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body); // {'status':'OK','needPassword':true/false}
  //   } else {
  //     return {
  //       "success": false,
  //       "status": response.statusCode,
  //       "error": data["error"],
  //       "message": data["message"],
  //     };
  //     // throw Exception('Device check failed: ${response.body}');
  //   }
  // }


  // Save user object
  Future<void> saveDevice(SavedDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_device", jsonEncode(device.toJson()));
  }

  // Load user object
  Future<SavedDevice?> getSavedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceStr = prefs.getString("saved_device");
    debugPrint('deviceStr...${deviceStr}');
    if (deviceStr == null) return null;
    return SavedDevice.fromJson(jsonDecode(deviceStr));
  }

  // Clear saved user
  Future<void> clearDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("saved_device");
  }


}
