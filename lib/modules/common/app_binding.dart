import 'package:get/get.dart';
import 'package:hbmarket/modules/baza_duzelt_module/controller/say_duzelt_controller.dart';
import 'package:hbmarket/modules/hereket_module/controller/apply_controller.dart';
import 'package:hbmarket/modules/hereket_module/controller/hereket_plani_controller.dart';
import 'package:hbmarket/modules/hereket_module/controller/hereket_work_controller.dart';
import 'package:hbmarket/modules/hereket_module/controller/qaime_bax_controller.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/login_module/login_service/db_service.dart';
import 'package:hbmarket/modules/login_module/login_service/device_service.dart';
import 'package:hbmarket/modules/login_module/login_service/login_service.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/pul_emeliyyat_module/controller/pul_emeliyyat_controller.dart';
import 'package:hbmarket/modules/pul_transfer_module/controller/pul_transfer_controller.dart';
import 'package:hbmarket/modules/raport_module/controller/report_controller.dart';
import 'package:hbmarket/modules/temizlenme_module/controller/temizlenme_controller.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/controller/xercqazanc_controller.dart';
import 'package:hbmarket/modules/yonlendirme_module/controller/yonlendirme_controller.dart';
import 'package:hbmarket/thema/theme_controller.dart';

import '../../http/api_class.dart';
import '../hereket_module/controller/f1_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Get.put(ThemeController());
    Get.put(DbService());
    Get.put(DeviceService());
    // Get.put(LoginService(client: new ApiClient()));
    Get.put(
      DbSelectionController(dbService: Get.find<DbService>()),
      permanent: true,
    ); // DB persistence controller
    Get.lazyPut(() => QaimeBaxController(), fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => ObyektController(), fenix: true);
    Get.lazyPut(() => PartnyorController(), fenix: true);
    Get.lazyPut(() => XercQazancController(), fenix: true);
    Get.lazyPut(() => KassaController(), fenix: true);
    Get.lazyPut(() => PulTransferController(), fenix: true);
    Get.lazyPut(() => PulEmeliyyatController(), fenix: true);
    Get.lazyPut(() => SayDuzeltController(), fenix: true);
    Get.lazyPut(() => HereketPlaniController(), fenix: true);
    Get.lazyPut(() => MalYoxlaController(), fenix: true);
    Get.lazyPut(() => HereketWorkController(), fenix: true);
    Get.lazyPut(() => TemizlenmeController(), fenix: true);
    Get.lazyPut(() => YonlendirmeController(), fenix: true);
    Get.lazyPut(() => ApplyController() , fenix: true);
    Get.lazyPut(() => F1Controller() , fenix: true);

  }
}
