import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/routes/route_helper.dart';

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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              print('logout clicked');
              Get.offAllNamed(RouteHelper.login);
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
