import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/drawer_controller.dart';

class AppDrawer extends StatelessWidget {
  final DrawerControllerX controller = Get.find<DrawerControllerX>();

  @override
  Widget build(BuildContext context) {
    double drawerWidth = kIsWeb ? 250 : MediaQuery.of(context).size.width * 0.7;
    return Container(
      width: drawerWidth,
      child: Drawer(
        child: ListView(
          shrinkWrap: true, // 👈 important on mobile
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...controller.menuItems.map(
              (item) => ListTile(
                leading: Icon(item['icon']),
                title: Text(item['titleKey'].toString().tr),
                onTap: () {
                  print('item: ${item['titleKey']}');
                  controller.selectPage(item['titleKey']);
                  if (!kIsWeb) Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
