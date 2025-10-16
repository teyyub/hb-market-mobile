import 'package:get/get.dart';
import 'package:hbmarket/modules/login_module/login_service/db_service.dart';
import 'package:hbmarket/modules/login_module/login_service/login_service.dart';
import 'package:hbmarket/modules/login_module/login_service/saved_user_service.dart';
import 'package:hbmarket/modules/login_module/pages/db_selection_page.dart';
import 'package:hbmarket/pages/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbSelectionController extends GetxController {
  static DbSelectionController get to => Get.find();

  final DbService dbService;
  DbSelectionController({required this.dbService});

  List<Map<String, dynamic>> dbList = [];
  Map<String, dynamic>? selectedDb;
  String dbName = '';
  int dbId = 0;

  /// Getter for selected DB ID
  int get getDbId => selectedDb?["dbId"] ?? dbId;

  void setDbList(List<Map<String, dynamic>> list) {
    dbList = list;
  }

  @override
  void onInit() {
    super.onInit();
    // _initController();
  }

  Future<void> _initController() async {
    await loadDbList();
    await loadSelectedDb();
    print('Loaded dbList: $dbList');
    print('Selected DB: $selectedDb');
  }

  Future<void> loadDbList() async {
    dbList = await dbService.getDbList();
  }

  // Future<void> handleDbSelection() async {

  //   if (selectedDb != null) {
  //     // User already has a selected DB → go straight to dashboard
  //     Get.offAll(() => DashboardPage());
  //   } else if (dbList.length == 1) {
  //     // Only one DB → save automatically
  //     await saveDb(dbList.first);
  //     Get.offAll(() => DashboardPage());
  //   } else {
  //     // Multiple DBs → show selection page
  //     Get.to(() => DbSelectionPage());
  //   }
  // }

  Future<void> handleDbSelection() async {
    // Load only once at startup
    await loadSelectedDb();
    print('selectedDb at handleDbSelection: ${selectedDb}');
    if (selectedDb != null) {
      // ✅ User already selected a DB before → skip selection
      Get.offAll(() => DashboardPage());
    } else {
      // If no DB saved → fetch dbList from service
      await loadDbList();

      if (dbList.length == 1) {
        // Only one DB → save automatically
        await saveDb(dbList.first);
        Get.offAll(() => DashboardPage());
      } else {
        // Multiple DBs → show selection page
        Get.to(() => DbSelectionPage());
      }
    }
  }

  Future<void> saveDb(Map<String, dynamic> db) async {
    final prefs = await SharedPreferences.getInstance();
    dbName = db['biznes'];
    dbId = db['id'];
    await prefs.setString('biznes', dbName);
    await prefs.setInt('db_id', dbId);
  }

  Future<void> loadSelectedDb() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDbName = prefs.getString('biznes');
    final savedDbId = prefs.getInt('db_id');

    if (savedDbName != null && savedDbId != null) {
      dbName = savedDbName;
      dbId = savedDbId;
      selectedDb = {'dbName': dbName, 'dbId': dbId};
    } else {
      dbName = '';
      dbId = 0;
      selectedDb = null;
    }
  }
}
