import 'package:hbmarket/modules/raport_module/models/field_value.dart';

class ReportPrint {
  final Map<String, FieldValue> fields;

  ReportPrint({required this.fields});

  factory ReportPrint.fromJson(Map<String, dynamic> json) {
    Map<String, FieldValue> map = {};

    json.forEach((key, value) {
      if (key != 'basliq') {
        map[key] = FieldValue.fromJson(value);
      }
    });
    return ReportPrint(fields: map);
  }

  @override
  String toString() {
    return 'ReportPrint(fields: $fields)';
  }
}
