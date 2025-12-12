import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/BarcodeAddDto.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import '../../common/api_messages.dart';

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
      if (obyektId!=-1)  'obyektId': obyektId.toString(),
      'sn': (id ?? -1).toString(),
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (dynamicOz != null) ...dynamicOz,
    };
    print('params ${queryParams}');
    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '${baseUrl}${uri.isNotEmpty ? '?$uri' : ''}';
    // print('endPoint ${endpoint}');
    final response = await client.get(endpoint);
    // print('response.statusCode1=${response.statusCode}');
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

  Future<Map<String, dynamic>> add(int dbKey, BarcodeAddDto dto) async {
    try {
    final String enpoint = '/api/mal-yoxla?dbKey=$dbKey';
    final response = await client.post(enpoint, body: dto.toJson());
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        print('fetchServive...${result}');
      return result;
      } else {
          final friendlyMessage = getFriendlyMessage(response.statusCode);
      throw HttpException(friendlyMessage);
      }
      } on HttpException catch (e) {
      print('HTTP error: $e');
      rethrow; // Rethrow if you want upstream handling
      } on FormatException catch (e) {
      print('JSON format error: $e');
      throw  FormatException('Invalid JSON format received from API');
      } on Exception catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch herekets: $e');
      }
  }
}
