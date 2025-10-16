import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/saved_user.dart';

class SavedUserService {
  // Save user object
  Future<void> saveUser(SavedUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_user", jsonEncode(user.toJson()));
  }

  // Load user object
  Future<SavedUser?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString("saved_user");
    if (userStr == null) return null;
    return SavedUser.fromJson(jsonDecode(userStr));
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

  static Future<bool> isSessionActive() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActivity = prefs.getInt('lastActivity');

    if (lastActivity == null) return false; // no record, force login

    final now = DateTime.now().millisecondsSinceEpoch;
    final timeout = Duration(minutes: 30).inMilliseconds; // 30 min timeout

    if (now - lastActivity > timeout) {
      // session expired
      return false;
    }

    // session still valid
    return true;
  }
}
