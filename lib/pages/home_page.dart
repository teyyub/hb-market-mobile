import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/drawer_controller.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/customer_module/pages/customer_page.dart';
import 'package:hbmarket/modules/kassa_module/pages/kassa_page.dart';
import 'package:hbmarket/modules/login_module/pages/db_selection_page.dart';
import 'package:hbmarket/modules/partnyor_module/pages/partnyor_page.dart';
import 'package:hbmarket/modules/raport_module/pages/report_page.dart';
import 'package:hbmarket/modules/temizlenme_module/models/temizle_model.dart';
import 'package:hbmarket/modules/temizlenme_module/pages/temizle_page.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/pages/xerc_qazanc_page.dart';
import 'package:hbmarket/modules/yonlendirme_module/pages/yonlendirme_page.dart';
import 'package:hbmarket/routes/route_helper.dart';
import 'package:hbmarket/widget/app_drawer.dart';

class HomePage extends StatelessWidget {
  final DrawerControllerX controller = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    final bool isMobile = DeviceUtils.isMobile(context);
    final pageContent = GetBuilder<DrawerControllerX>(
      builder: (_) {
        if (controller.selectedPage.isEmpty) {
          return const Center(
            child: Text('Connected to ', style: TextStyle(fontSize: 24)),
          );
        }
        switch (controller.selectedPage) {
          // case 'raportlar':
          // return ReportPage();
          case 'partnyorlar':
            return PartnyorPage();
          case 'kassalar':
            return KassaPage();
          case 'xerc-qazanc':
            return XercQazancPage();
          case 'temizlenme':
            return TemizlenmePage();
          case 'yonlendirme':
            return YonlendirmePage();
          case 'user-db':
            return DbSelectionPage();
          default:
            return const Center(
              child: Text('Welcome ', style: TextStyle(fontSize: 24)),
            );
        }
      },
    );

    final drawerWidget = controller.selectedPage.isEmpty ? null : AppDrawer();

    final appBar = AppBar(
      title: Text(
        controller.selectedPage.isEmpty
            ? 'selectedDb["dbName"]'
            : controller.selectedPage,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            print('logut');
            Get.offAllNamed(RouteHelper.login);
          },
        ),
      ],
    );
    if (!isMobile) {
      return Scaffold(
        appBar: appBar, // ← Now top-level AppBar, gestures work!
        body: Row(
          children: [
            if (drawerWidget != null) SizedBox(width: 250, child: drawerWidget),
            Expanded(child: pageContent),
          ],
        ),
      );
    } else {
      return Scaffold(appBar: appBar, drawer: drawerWidget, body: pageContent);
    }
  }
}
