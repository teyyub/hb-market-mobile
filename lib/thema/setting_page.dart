import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/thema/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: GetBuilder<ThemeController>(
          builder: (_) => SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeController.isDarkMode,
            onChanged: (val) => themeController.toggleTheme(),
          ),
        ),
      ),
    );
  }
}