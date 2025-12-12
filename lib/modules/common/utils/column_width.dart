import 'package:shared_preferences/shared_preferences.dart';

class ColumnWidthManager {
  static final ColumnWidthManager _instance = ColumnWidthManager._internal();

  factory ColumnWidthManager() => _instance;

  ColumnWidthManager._internal();

  Future<void> saveWidths(String tableId, Map<String, double> widths) async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in widths.entries) {
      await prefs.setDouble('${tableId}_col_${entry.key}', entry.value);
    }
  }

  Future<Map<String, double>> loadWidths(String tableId, List columns) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, double> loaded = {};
    for (final c in columns) {
      final key = c['key'];
      final width = prefs.getDouble('${tableId}_col_$key');
      if (width != null) loaded[key] = width;
    }
    return loaded;
  }
}
