import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/update_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';

import '../models/PartnyorFilter.dart';
import '../models/partnyor_light.dart';

class PartnyorService {
  final ApiClient client;
  PartnyorService({required this.client});

  Future<List<Partnyor>> fetchPartnyors(int dbKey) async {
    final endpoint = '/api/partnyors?dbKey=$dbKey';
    final response = await client.get(endpoint);
    // print('partnyorServive...${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Partnyor.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load partnyor');
    }
  }


  Future<List<PartnyorLight>> fetchPartnyorTypes(int dbKey) async {
    final endpoint = '/api/partnyor-types?dbKey=$dbKey';
    final response = await client.get(endpoint);
    // print('partnyorServive...${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => PartnyorLight.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load partnyor');
    }
  }

  Future<List<Partnyor>> filterPartnyors(int dbKey, PartnyorFilter? filter) async {
    String endpoint = '/api/v1/partnyors?dbKey=$dbKey';

    if (filter != null) {
      final params = filter.toQueryParams();
      if (params.isNotEmpty) {
        final queryString = params.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint += '&$queryString';
      }
    }
    debugPrint('query ...${filter?.tip}');
    final response = await client.get(endpoint);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Partnyor.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load partnyor');
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
    } else {
      throw Exception('Failed to load partnyor');
    }
  }

  Future<int> xercYeni(int dbKey, XercRequestDto requestDto) async {
    final endpoint = '/api/partnyors/xerc-yeni?dbKey=$dbKey';
    final response = await client.put(endpoint, body: requestDto.toJson());
    print('xercYeni???...${response.statusCode}');
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      return 200;
    } else {
      throw Exception('Failed to load partnyor');
    }
  }
}
