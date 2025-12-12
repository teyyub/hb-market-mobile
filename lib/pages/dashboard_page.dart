import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/drawer_controller.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/routes/route_helper.dart';
import 'package:hbmarket/widget/app_drawer.dart';

class DashboardPage extends StatelessWidget {
  final DrawerControllerX controller = Get.put(DrawerControllerX());
  // final Map<String, dynamic> selectedDb;

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    return MainLayout(
      title: 'Dashboard',
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isMobile
              ? Column(
                  children: controller.menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: _buildDashboardButton(
                          icon: item['icon'],
                          label: item['titleKey'].toString().tr,
                          onPressed: () =>
                              controller.selectPage(item['titleKey']),
                        ),
                      ),

                    );
                  }).toList(),
                )
              : Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: controller.menuItems.map((item) {
                    return SizedBox(
                      width: 200,
                      height: 60,
                      child: _buildDashboardButton(
                        icon: item['icon'],
                        label: item['titleKey'].toString().tr,
                        onPressed: () =>
                            controller.selectPage(item['titleKey']),
                      ),
                      // child: ElevatedButton.icon(
                      //   icon: Icon(item['icon']),
                      //   label: Text(item['titleKey'].toString().tr),
                      //   onPressed: () =>
                      //       controller.selectPage(item['titleKey']),
                      // ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  /// Modern Dashboard Button
  Widget _buildDashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style:
          ElevatedButton.styleFrom(
            elevation: 4,
            backgroundColor: Colors.blueAccent, // M3 primary color
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ).copyWith(
            // Hover effect for web/desktop
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered))
                return Colors.blue.shade700;
              if (states.contains(WidgetState.pressed))
                return Colors.blue.shade900;
              return null;
            }),
          ),
    );
  }
}
