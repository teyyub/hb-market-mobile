import 'package:get/get.dart';
import 'package:hbmarket/config/menu_items.dart';

class DrawerControllerX extends GetxController {
  List<Map<String, dynamic>> menuItems = [];

  String selectedPage = "";

  @override
  void onInit() {
    super.onInit();
    loadMenu(); // could load from JSON or API
  }

  void selectPage(String page) {
    selectedPage = page;
    // print('page...${selectedPage}');
    Get.toNamed(page);
    update(); // triggers GetBuilder to rebuild UI
  }

  void loadMenu() {
    menuItems = menuItemsConfig;
    update();
  }
}
