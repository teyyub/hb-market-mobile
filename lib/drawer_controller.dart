import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/config/menu_items.dart';
import 'package:hbmarket/modules/baza_duzelt_module/controller/say_duzelt_controller.dart';
import 'package:hbmarket/modules/hereket_module/controller/hereket_plani_controller.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/pul_emeliyyat_module/controller/pul_emeliyyat_controller.dart';
import 'package:hbmarket/modules/pul_transfer_module/controller/pul_transfer_controller.dart';
import 'package:hbmarket/modules/raport_module/controller/report_controller.dart';
import 'package:hbmarket/modules/temizlenme_module/controller/temizlenme_controller.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/controller/xercqazanc_controller.dart';
import 'package:hbmarket/modules/yonlendirme_module/controller/yonlendirme_controller.dart';

import 'modules/mal_hereketi_module/controller/mal_hereketi_controller.dart';

class DrawerControllerX extends GetxController {
  List<Map<String, dynamic>> menuItems = [];

  String selectedPage = "";

  final Map<String, Future<void> Function()> preloadMap = {
    'raportlar': () async {
      final c = Get.find<ReportController>();
      await c.fetchReports();
    },

    'partnyorlar': () async {
      final c = Get.find<PartnyorController>();
      await c.fetchPartnors();
    },
    'kassalar': () async {
      final c = Get.find<KassaController>();
      await c.fetchKassa();
    },

    'xerc-qazanc': () async {
      final c = Get.find<XercQazancController>();
      await c.fetchXercQazanc();
    },
    'pul-transferi': () async {
      final c = Get.find<PulTransferController>();
      // await c.fetchP;
    },

    'pul-emeliyyati': () async {
      final c = Get.find<PulEmeliyyatController>();
      await c.fetchPulEmeliyyat();
    },
    'hereket-plani': () async {
      final HereketPlaniController c = Get.find<HereketPlaniController>();
      await c.fetchHereketPlani();
    },
    'say-duzelt': () async {
      final c = Get.find<SayDuzeltController>();
      // await c.fetchReports();
    },
    'mal-hereketi': () async {
      final c = Get.find<MalHereketiController>();
      // await c.fetchReports();
    },
    'mal-yoxla': () async {
      final c = Get.find<MalYoxlaController>();
      // await c.fetchReports();
    },
    'temizlenme': () async {
      final c = Get.find<TemizlenmeController>();
      // await c.fetchReports();
    },
    'yonlendirme': () async {
      final c = Get.find<YonlendirmeController>();
      // await c.fetchReports();
    },
    // Add more pages here if needed
  };

  @override
  void onInit() {
    super.onInit();
    loadMenu(); // could load from JSON or API
  }

  Future<void> selectPage(String page) async {
    debugPrint('selectedPage...${page}');
    selectedPage = page;

    update(); // triggers GetBuilder to rebuild UI
    final preload = preloadMap[page];
    if (preload != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await preload();
      Get.back();
    }
    Get.toNamed(page);
    update();
  }

  void loadMenu() {
    menuItems = menuItemsConfig;
    update();
  }
}
