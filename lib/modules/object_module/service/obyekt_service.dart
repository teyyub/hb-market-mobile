import 'dart:convert';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:http/http.dart' as http;
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';

class ObyektService {
  final ApiClient client;
  ObyektService({required this.client});

  Future<List<Obyekt>> fetchObjects(int dbKey) async {
    final endpoint = '/api/obyekts?dbKey=$dbKey';
    final response = await client.get(endpoint);
    print('response.statusCode=${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Obyekt.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load obyektler');
    }
  }
}
