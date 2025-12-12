import 'dart:convert';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/partnyor_module/models/category_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/qeyd_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_grouped_print.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:hbmarket/modules/raport_module/models/report_print.dart';
import 'package:http/http.dart' as http;
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';

class KassaService {
  final ApiClient client;
  KassaService({required this.client});

  Future<List<Kassa>> fetchKassa(int dbKey, {String? nameFilter}) async {
    // final response = await client.get('/api/raports');
    String endpoint = '/api/kassa?dbKey=$dbKey';
    if (nameFilter != null && nameFilter.isNotEmpty) {
      endpoint += '&name=${Uri.encodeComponent(nameFilter)}';
    }
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

  Future<List<Kassa>> fetchKassaFiltered(int dbKey, {String? filter}) async {
    // final endpoint = '/api/kassa?dbKey=$dbKey&filter=emelPlus';
    // final response = await client.get(endpoint);
    final queryParams = <String, String>{
      'dbKey': dbKey.toString(),
      if (filter != null) 'filter': filter,
    };
    final uri = Uri(path: '/api/kassa', queryParameters: queryParams);
    final response = await client.get(uri.toString());
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

  Future<List<Category>> fetchCategory(int dbKey, int? parentId) async {
    // final response = await client.get('/api/raports');
    String endpoint = '/api/categories?dbKey=$dbKey';
    if (parentId != null) {
      endpoint += '&parentId=$parentId';
    }
    final response = await client.get(endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('category.....${jsonList}');
      return jsonList
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kassalar');
    }
  }

  Future<List<Qeyd>> fetchQeyd(int dbKey) async {
    // final response = await client.get('/api/raports');
    final endpoint = '/api/notes?dbKey=$dbKey';
    final response = await client.get(endpoint);
    // final response = await client.get('/api/v1/raports', {'dbKey': dbKey});
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      // print('1.....${jsonList}');
      return jsonList
          .map((json) => Qeyd.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kassalar');
    }
  }

  Future<List<Qeyd>> fetchSebeb(int dbKey) async {
    // final response = await client.get('/api/raports');
    final endpoint = '/api/reasons?dbKey=$dbKey';
    final response = await client.get(endpoint);
    // final response = await client.get('/api/v1/raports', {'dbKey': dbKey});
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      // print('1.....${jsonList}');
      return jsonList
          .map((json) => Qeyd.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kassalar');
    }
  }
}
