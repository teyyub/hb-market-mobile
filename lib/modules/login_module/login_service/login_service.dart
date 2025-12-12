import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/user_check_res.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/login_module/login_service/saved_user_service.dart';
import 'package:hbmarket/modules/login_module/model/saved_user.dart';
import 'package:hbmarket/modules/login_module/model/user_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/api_response.dart';
import '../model/device_login.dart';

class LoginService {
  final ApiClient client;
  LoginService({required this.client});


  /// Login function
  // Future<Map<String, dynamic>> login(
  //   UserLogin user, {
  //   bool forceLogin = false,
  // }) async {
  //   final deviceId = await DeviceUtils.getDeviceIdInt();
  //
  //   final response = await client.post(
  //     '/api/auth/v2/login',
  //     body: user.toJson(deviceId: deviceId, forceLogin: forceLogin),
  //   );
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     // if (data["isOtherDeviceLoggedIn"] == true && !forceLogin) {
  //     //   // User needs confirmation before force login
  //     //   return {"conflict": true};
  //     // }
  //
  //     // if (data["jwtToken"] != null) {
  //     // final token = data["jwtToken"];
  //     // await _saveToken(token);
  //
  //     final dbList = data['userDbResponse'];
  //     // await _saveToken(token);
  //     final savedUser = SavedUser(
  //       username: user.username,
  //       password: user.password,
  //       token: null,
  //       dbList: dbList,
  //     );
  //     await saveUser(savedUser);
  //
  //     return {
  //       "success": true,
  //       "token": data["jwtToken"],
  //       "deviceId": deviceId,
  //       "userDbResponse": data["userDbResponse"],
  //     };
  //     // }
  //   } else {
  //     return {
  //       "success": false,
  //       "status": response.statusCode,
  //       "error": data["error"],
  //       "message": data["message"],
  //     };
  //   }
  // }


  /// Login function
  // Future<ApiResponse<void>> loginV1(DeviceLogin device) async {
  //
  //   final response = await client.post(
  //     '/api/auth/v3/login',
  //     body: device.toJson(deviceId: device.deviceId),
  //   );
  //
  // }




  Future<ApiResponse<String?>>  check(DeviceLogin device) async {
    final response = await client.post(
      '/api/auth/v3/check',
      body: device.toJson(deviceId: device.deviceId),
    );
    final json = jsonDecode(response.body);
    return ApiResponse<String?>.fromJson(json,
            (data) => data != null ? data.toString() : null,
    );
  }

  Future<void> saveUser(SavedUser user) async {
    await SavedUserService().saveUser(user);
  }

  Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lang", lang);
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("lang");
  }

  /// Save selected DB name permanently
  Future<void> saveDbName(String dbName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("db_name", dbName);
  }

  /// Get saved DB name
  Future<String?> getDbName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("db_name");
  }

  /// Clear DB name (if needed on logout)
  Future<void> clearDbName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("db_name");
  }

  Future<SavedUser?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString("saved_user");
    if (userStr == null) return null;
    return SavedUser.fromJson(jsonDecode(userStr));
  }
}
