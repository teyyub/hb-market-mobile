import 'dart:convert';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/raport_module/models/report_grouped_print.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_print.dart';
import 'package:http/http.dart' as http;
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';

class ReportService {
  final ApiClient client;
  ReportService({required this.client});

  Future<List<Report>> fetchReports(int dbKey) async {
    // final response = await client.get('/api/raports');
    final endpoint = '/api/v1/raports?dbKey=$dbKey';
    final response = await client.get(endpoint);
    // final response = await client.get('/api/v1/raports', {'dbKey': dbKey});
    print('fetchReport.${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Report.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kassalar');
    }
  }

  Future<List<ReportPrintGroup>> fetchReportPrint(
    int dbKey,
    int? reportId,
    int? objectId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final baseUrl = '/api/report/print';
    final queryParams = <String, String>{};
    queryParams['dbKey'] = dbKey.toString();
    if (reportId != null) queryParams['reportId'] = reportId.toString();
    if (objectId != null) queryParams['objectId'] = objectId.toString();
    if (startDate != null)
      queryParams['startDate'] = startDate.toIso8601String().split('T').first;
    if (endDate != null)
      queryParams['endDate'] = endDate.toIso8601String().split('T').first;

    print('params ${queryParams}');

    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '/api/report/print${uri.isNotEmpty ? '?$uri' : ''}';
    final response = await client.get(endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      // final List<ReportPrint> data = json.decode(response.body);
      return jsonList
          .map((e) => ReportPrintGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kassalar');
    }
  }

  Future<String> fetchReportPrintV1(
    int dbKey,
    int? reportId,
    int? objectId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final baseUrl = '/api/report/print';
    final queryParams = <String, String>{};
    queryParams['dbKey'] = dbKey.toString();
    if (reportId != null) queryParams['reportId'] = reportId.toString();
    if (objectId != null) queryParams['objectId'] = objectId.toString();
    if (startDate != null)
      queryParams['startDate'] = startDate.toIso8601String().split('T').first;
    if (endDate != null)
      queryParams['endDate'] = endDate.toIso8601String().split('T').first;

    print('params ${queryParams}');

    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '/api/report/print${uri.isNotEmpty ? '?$uri' : ''}';
    final response = await client.get(endpoint);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Request failed!');
      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      throw Exception('Failed to load reports');
    }
  }
}
