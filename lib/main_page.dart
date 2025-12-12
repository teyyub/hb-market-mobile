import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/routes/route_helper.dart';
import 'package:hbmarket/thema/theme_controller.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBack;

  const MainLayout({
    Key? key,
    required this.title,
    required this.body,
    this.showBack = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(title),
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              )
            : null,
        actions: [
          GetBuilder<ThemeController>(
            builder: (_) => IconButton(
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              tooltip: 'Toggle Theme',
              onPressed: () => themeController.toggleTheme(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              if (kDebugMode) {
                print('logout clicked');
              }
              Get.offAllNamed(RouteHelper.login);
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
