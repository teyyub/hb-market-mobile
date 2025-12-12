import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ThemeController extends GetxController {
  bool isDarkMode = false;

  ThemeData get theme => isDarkMode ? darkTheme : lightTheme;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }


  void toggleTheme() async{
    isDarkMode = !isDarkMode;
    debugPrint('mode: ${isDarkMode}');
    update(); // GetBuilder-i yeniləyir
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    update();
  }
}
