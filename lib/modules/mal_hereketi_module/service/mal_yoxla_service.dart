import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/api_response.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/mal_hereketi.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/mal_odenis_dto.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/odenis_request.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/BarcodeAddDto.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import '../../common/api_messages.dart';
import '../models/pul_hereketi_bax.dart';

class MalHereketiService {
  final ApiClient client;
  MalHereketiService({required this.client});


  Future<List<MalOdenisDto>> fetchMalOdenisi(int dbKey, int id) async {
    String endpoint = '/api/mal-hereketi/odenis?dbKey=$dbKey&id=$id';
    final response = await client.get(endpoint);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('category.....${jsonList}');
      return jsonList
          .map((json) => MalOdenisDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Mal odenisi');
    }
  }

  Future<List<MalYoxla>> fetchMalYoxla(
    int dbKey,
    int obyektId,
    int? id,
    String? name,
    String? barcode,
    Map<String, dynamic>? dynamicOz,
  ) async {
    final baseUrl = '/api/mal-hereketi';

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

  Future<List<MalHereketiDto>> fetchMalHereketi(int dbKey) async {
    final queryParams = <String, String>{'dbKey': dbKey.toString()};
    final baseUrl = '/api/mal-hereketi';
    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '${baseUrl}${uri.isNotEmpty ? '?$uri' : ''}';
    final response = await client.get(endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('response=${response.body}');
      return jsonList
          .map((json) => MalHereketiDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load mal yoxla');
    }
  }

  Future<List<MalHereketiBaxDto>> fetchMalHereketiBax(int dbKey, int id) async {
    final queryParams = <String, String>{
      'dbKey': dbKey.toString(),
      'id':id.toString()
    };
    final baseUrl = '/api/mal-hereketi/bax';
    final uri = Uri(queryParameters: queryParams).query;
    final endpoint = '${baseUrl}${uri.isNotEmpty ? '?$uri' : ''}';
    final response = await client.get(endpoint);
    print('response.statusCode2=${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('response=${response.body}');
      return jsonList
          .map((json) => MalHereketiBaxDto.fromJson(json as Map<String, dynamic>))
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


  Future<ApiResponse<int>> yeniOdenis(int dbKey, OdenisRequestDto dto) async {
    try {
      final String enpoint = '/api/mal-hereketi/odenis?dbKey=$dbKey';
      final response = await client.post(enpoint, body: dto.toJson());
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        print('yeniOdenis...${result}');
        return ApiResponse<int>.fromJson( result,
              (data) => int.parse(data.toString()));
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
