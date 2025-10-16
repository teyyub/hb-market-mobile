import 'package:get/get.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/login_module/login_service/db_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DbService());
    // Controllers

    Get.put(
      DbSelectionController(dbService: Get.find<DbService>()),
      permanent: true,
    ); // DB persistence controller
  }
}
