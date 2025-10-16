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

    // Wrap GridView/ListView with SingleChildScrollView if needed
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.blue, // or any contrasting color
    //     foregroundColor: Colors.white,
    //     title: Text(''),
    //     leading: IconButton(
    //       onPressed: () => Get.back(),
    //       icon: const Icon(Icons.arrow_back),
    //     ),
    //     actions: [
    //       IconButton(
    //         icon: const Icon(Icons.logout),
    //         tooltip: 'Logout',
    //         onPressed: () {
    //           print('logout dahsboard');
    //           Get.offAllNamed(RouteHelper.login);
    //         },
    //       ),
    //     ],
    //   ),
    // drawer: isMobile ? AppDrawer() : null,
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
                      child: ElevatedButton.icon(
                        icon: Icon(item['icon']),
                        label: Text(item['titleKey'].toString().tr),
                        onPressed: () =>
                            controller.selectPage(item['titleKey']),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
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
                      child: ElevatedButton.icon(
                        icon: Icon(item['icon']),
                        label: Text(item['titleKey'].toString().tr),
                        onPressed: () =>
                            controller.selectPage(item['titleKey']),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
