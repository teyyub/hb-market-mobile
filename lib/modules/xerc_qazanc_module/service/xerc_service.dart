import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/update_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';

class XercQazancService {
  final ApiClient client;
  XercQazancService({required this.client});

  Future<List<XercQazanc>> fetchXerc(int dbKey) async {
    final endpoint = '/api/xerc-qazanc?dbKey=$dbKey';
    final response = await client.get(endpoint);
    print('xercQazancServive...${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => XercQazanc.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Xerc qazanc yukleme zamani xeta yarandi');
    }
  }

  Future<int> updateMustBorcKassa(
    int dbKey,
    int mustId,
    int kassaId,
    double amount,
    String tip,
  ) async {
    final endpoint = '/api/partnyors/kassa-borc?dbKey=$dbKey';
    final requestDto = UpdateRequestDto(
      mustId: mustId,
      kassaId: kassaId,
      amount: amount,
      sign: tip,
    );
    final response = await client.put(endpoint, body: requestDto.toJson());
    print('partnyorServive...${response.statusCode}');
    if (response.statusCode == 200) {
      return 200;
      // await fetchPartnyors(dbKey);
      // final List<dynamic> jsonList = json.decode(response.body);
      // return jsonList
      // .map((json) => Partnyor.fromJson(json as Map<String, dynamic>))
      // .toList();
    } else {
      throw Exception('Failed to load partnyor');
    }
  }

  Future<int> xercYeni(int dbKey, XercRequestDto requestDto) async {
    final endpoint = '/api/partnyors/xerc-yeni?dbKey=$dbKey';
    final response = await client.put(endpoint, body: requestDto.toJson());
    print('xercYeni????...${response.statusCode}');
    if (response.statusCode == 200) {
      debugPrint('cavab:${response.body}');
      return 200;
    } else {
      throw Exception('Failed to load partnyor');
    }
  }

  Future<int> xercUpdate(int dbKey, XercRequestDto requestDto) async {
    try {
      final endpoint = '/api/xerc-qazanc?dbKey=$dbKey';
      debugPrint('xercUpdate dbKey...${dbKey}');
      debugPrint('xercUpdate Request...${requestDto.toJson1()}');
      final body = {
        'id': requestDto.id,
        'mus': requestDto.mustId,
        'kassa': requestDto.kassaId,
        'mebleg': requestDto.amount,
        'oden': requestDto.pays,
        'xkat': requestDto.categoryId,
        'xakat': requestDto.subCategoryId,
        'sebeb': requestDto.sebeb,
        'qeyd': requestDto.qeyd,
        'sign': requestDto.sign,
      };
      // final jsonString = jsonEncode(body);
      debugPrint('body...${body}');
      final response = await client.put(endpoint, body: body);
      print('xercUpdate...${response.statusCode}');
      print('xercUpdate...${response.body}');
      if (response.statusCode == 200) {
        return 200;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('xercUpdate exception: $e');
      rethrow;
    }
  }
}
