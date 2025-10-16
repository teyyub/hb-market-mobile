import 'package:hbmarket/modules/raport_module/models/report_print.dart';

class ReportPrintGroup {
  final String basliq;
  final List<ReportPrint> rows;

  ReportPrintGroup({required this.basliq, required this.rows});

  factory ReportPrintGroup.fromJson(Map<String, dynamic> json) {
    return ReportPrintGroup(
      basliq: json['basliq'] as String,
      rows: (json['rows'] as List<dynamic>)
          .map((e) => ReportPrint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ReportPrintGroup(basliq: $basliq, rows: $rows)';
  }
}
