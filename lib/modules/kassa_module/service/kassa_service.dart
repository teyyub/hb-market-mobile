import 'dart:convert';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/raport_module/models/report_grouped_print.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_print.dart';
import 'package:http/http.dart' as http;
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';

class KassaService {
  final ApiClient client;
  KassaService({required this.client});

  Future<List<Kassa>> fetchKassa(int dbKey) async {
    // final response = await client.get('/api/raports');
    final endpoint = '/api/kassa?dbKey=$dbKey';
    final response = await client.get(endpoint);
    // final response = await client.get('/api/v1/raports', {'dbKey': dbKey});
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      // print('1.....${jsonList}');
      return jsonList
          .map((json) => Kassa.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kassalar');
    }
  }

  Future<void> executeProcedure(int dbKey) async {
    // final response = await client.get('/api/raports');
    final endpoint = '/api/call-kassa?dbKey=$dbKey';
    final response = await client.get(endpoint);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load kassalar');
    }
  }
}
