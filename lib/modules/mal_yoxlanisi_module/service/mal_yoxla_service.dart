import 'dart:convert';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:http/http.dart' as http;
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';

class MalYoxlaService {
  final ApiClient client;
  MalYoxlaService({required this.client});

  Future<List<MalYoxla>> fetchMalYoxla(
    int dbKey,
    int obyektId,
    int? id,
    String? name,
    String? barcode,
    Map<String, dynamic>? dynamicOz,
  ) async {
    final baseUrl = '/api/mal-yoxla';

    final queryParams = <String, String>{
      'dbKey': dbKey.toString(),
      'obyektId': obyektId.toString(),
      'sn': (id ?? -1).toString(),
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (dynamicOz != null) ...dynamicOz,
    };
    print('params ${queryParams}');
    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '${baseUrl}${uri.isNotEmpty ? '?$uri' : ''}';
    print('endPoint ${endpoint}');
    final response = await client.get(endpoint);
    print('response.statusCode1=${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => MalYoxla.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load mal yoxla');
    }
  }

  Future<List<SearchItem>> fetchSearchItem(int dbKey) async {
    final queryParams = <String, String>{'dbKey': dbKey.toString()};
    final baseUrl = '/api/mal-yoxla/search-items';
    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '${baseUrl}${uri.isNotEmpty ? '?$uri' : ''}';
    final response = await client.get(endpoint);
    print('response.statusCode2=${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => SearchItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load mal yoxla');
    }
  }
}
