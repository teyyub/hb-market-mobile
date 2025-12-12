import 'dart:convert';
import 'package:hbmarket/modules/login_module/model/saved_device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/saved_user.dart';

class SavedDeviceService {
  // Save user object
  Future<void> saveUser(SavedUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_user", jsonEncode(user.toJson()));
  }

  // Load user object
  Future<SavedDevice?> getSavedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString("saved_device");
    if (userStr == null) return null;
    return SavedDevice.fromJson(jsonDecode(userStr));
  }

  // Clear saved user
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("saved_user");
  }

  Future<void> updateLastActivity() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastActivity', DateTime.now().millisecondsSinceEpoch);
  }

}
