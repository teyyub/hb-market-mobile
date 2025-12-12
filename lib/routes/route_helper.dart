import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/baza_duzelt_module/pages/say_duzelt_page.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/customer_module/pages/customer_detail_page.dart';
import 'package:hbmarket/modules/hereket_module/pages/hereket_plani_page.dart';
import 'package:hbmarket/modules/kassa_module/pages/kassa_page.dart';
import 'package:hbmarket/modules/lang_module/language_page.dart';
import 'package:hbmarket/modules/login_module/pages/db_selection_page.dart';
import 'package:hbmarket/modules/login_module/pages/login_page.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/pages/mal_yoxla_page.dart';
import 'package:hbmarket/modules/pul_emeliyyat_module/pages/pul_emeliyyat_page.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/pul_tranfer_model.dart';
import 'package:hbmarket/modules/pul_transfer_module/pages/pul_transfer_page.dart';
import 'package:hbmarket/modules/raport_module/pages/report_page.dart';
import 'package:hbmarket/modules/temizlenme_module/pages/temizle_page.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/controller/xercqazanc_controller.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/pages/xerc_qazanc_page.dart';
import 'package:hbmarket/modules/yonlendirme_module/pages/yonlendirme_page.dart';
import 'package:hbmarket/pages/dashboard_page.dart';
import 'package:hbmarket/pages/home_page.dart';
import 'package:hbmarket/modules/partnyor_module/pages/partnyor_page.dart';

class RouteHelper {
  // Named routes
  static const String home = '/';
  static const String login = '/login';
  static const String customerDetail = '/customer-detail';
  static const String dashboard = '/dashboard';
  static const String user_db = '/user-db';
  static const String raportlar = '/raportlar';
  static const String partnyors = '/partnyorlar';
  static const String kassalar = '/kassalar';
  static const String xerc_qazanc = '/xerc-qazanc';
  static const String pul_transfer = '/pul-transferleri';
  static const String pul_emeliyyat = '/pul-emeliyyatlari';
  static const String hereket_plani = '/hereket-plani';
  static const String mal_yoxlanisi = '/mal-yoxlanisi';
  static const String say_duzelt = '/say-duzelt';
  static const String temizlenme = '/temizlenme';
  static const String yonlendirme = '/yonlendirme';
  static const String language = '/language';

  // Navigation functions
  static void goToCustomerDetail(Customer customer) {
    Get.toNamed(customerDetail, arguments: customer);
  }

  // Register all app routes
  static List<GetPage> routes = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: language, page: () => const LanguagePage()),

    GetPage(
      name: raportlar,
      page: () {
        return ReportPage();
      },
    ),
    GetPage(
      name: partnyors,
      page: () {
        return PartnyorPage();
      },
    ),
    GetPage(
      name: kassalar,
      page: () {
        return KassaPage();
      },
    ),
    GetPage(name: xerc_qazanc, page: () => XercQazancPage()),
    GetPage(name: pul_transfer, page: () => PulTransferPage()),
    GetPage(name: pul_emeliyyat, page: () => PulEmeliyyatPage()),
    GetPage(name: hereket_plani, page: () => HereketPlaniPage()),
    GetPage(name: temizlenme, page: () => TemizlenmePage()),
    GetPage(name: say_duzelt, page: () => SayDuzeltPage()),
    GetPage(
      name: yonlendirme,
      page: () {
        return YonlendirmePage();
      },
    ),
    GetPage(
      name: mal_yoxlanisi,
      page: () {
        return MalYoxlaPage();
      },
    ),
    GetPage(name: user_db, page: () => DbSelectionPage()),
    GetPage(name: dashboard, page: () => DashboardPage()),
  ];
}
