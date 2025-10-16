import 'package:hbmarket/modules/login_module/login_service/saved_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbService {
  final SavedUserService savedUserService = SavedUserService();

  Future<List<Map<String, dynamic>>> getDbList() async {
    final savedUser = await savedUserService.getSavedUser();
    if (savedUser != null && savedUser.dbList.isNotEmpty) {
      return List<Map<String, dynamic>>.from(savedUser.dbList);
    }
    return [];
  }

  Future<void> saveDb(Map<String, dynamic> db) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('db_name', db['dbName']);
    await prefs.setInt('db_id', db['id']);
  }

  Future<Map<String, dynamic>> loadDb() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('db_name') ?? '';
    final id = prefs.getInt('db_id') ?? 0;
    return {'dbName': name, 'id': id};
  }

  Future<void> clearDb() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('db_name');
    await prefs.remove('db_id');
  }
}
