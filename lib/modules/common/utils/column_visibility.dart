import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

mixin ColumnVisibilityMixin on GetxController {
  final box = GetStorage();
  late String storageKey;

  List<Map<String, dynamic>> columns = [];
  Map<String, double> columnWidths = {};

  void initColumns(String key, List<Map<String, dynamic>> defaultColumns) {
    storageKey = key;
    columns = defaultColumns;
    _loadColumnVisibility();
    _loadColumnWidths();

    _saveColumnVisibility();
    _loadColumnVisibility();
  }

  void toggleColumnVisibility(String key) {
    int index = columns.indexWhere((c) => c['key'] == key);
    if (index != -1) {
      columns[index]['visible'] = !columns[index]['visible'];
      _saveColumnVisibility();
      update(); // rebuild GetBuilder
    }
  }

  void toggleColumnVisibilityExplicit(String key, bool visible) {
    int index = columns.indexWhere((c) => c['key'] == key);
    if (index != -1) {
      columns[index]['visible'] = visible;
      _saveColumnVisibility();
      update(); // rebuild UI
    }
  }

  void setColumnWidth(String key, double width) {
    columnWidths[key] = width;
    _saveColumnWidths();
    update();
  }

  double getColumnWidth(String key, {double defaultWidth = 150}) {
    return columnWidths[key] ?? defaultWidth;
  }

  void _saveColumnWidths() {
    box.write('${storageKey}_widths', columnWidths);
  }

  void _loadColumnWidths() {
    Map? stored = box.read('${storageKey}_widths');
    if (stored != null) {
      columnWidths = stored.map(
        (key, value) => MapEntry(key.toString(), value as double),
      );
    }
  }

  void _saveColumnVisibility() {
    box.write(storageKey, columns);
  }

  void _loadColumnVisibility() {
    List? stored = box.read<List>(storageKey);
    if (stored != null) {
      for (var col in columns) {
        var storedCol = stored.firstWhere(
          (s) => s['key'] == col['key'],
          orElse: () => <String, dynamic>{},
        );
        if (storedCol != null) {
          col['visible'] = storedCol['visible'] ?? false;
        }
      }
    }
  }
}
