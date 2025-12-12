import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/baza_duzelt_module/models/say_duzelt_request.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/update_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';

class SayDuzeltService {
  final ApiClient client;
  SayDuzeltService({required this.client});

  // Future<List<Partnyor>> fetchPartnyors(int dbKey) async {
  //   final endpoint = '/api/partnyors?dbKey=$dbKey';
  //   final response = await client.get(endpoint);
  //   // print('partnyorServive...${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonList = json.decode(response.body);
  //     return jsonList
  //         .map((json) => Partnyor.fromJson(json as Map<String, dynamic>))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load partnyor');
  //   }
  // }

  // Future<int> updateMustBorcKassa(
  //   int dbKey,
  //   int mustId,
  //   int kassaId,
  //   double amount,
  //   String tip,
  // ) async {
  //   final endpoint = '/api/partnyors/kassa-borc?dbKey=$dbKey';
  //   final requestDto = UpdateRequestDto(
  //     mustId: mustId,
  //     kassaId: kassaId,
  //     amount: amount,
  //     sign: tip,
  //   );
  //   final response = await client.put(endpoint, body: requestDto.toJson());
  //   print('partnyorServive...${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     return 200;
  //   } else {
  //     throw Exception('Failed to load partnyor');
  //   }
  // }

  Future<Map<String, dynamic>> qaliq(
    int dbKey,
    SayDuzeltRequest requestDto,
  ) async {
    final endpoint = '/api/say-duzelt/qaliq?dbKey=$dbKey';
    final response = await client.post(endpoint, body: requestDto.toJson());
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Failed to load qaliq');
    }
  }

  Future<Map<String, dynamic>> duzelt(
    int dbKey,
    SayDuzeltRequest requestDto,
  ) async {
    final endpoint = '/api/say-duzelt/duzelt?dbKey=$dbKey';
    final response = await client.post(endpoint, body: requestDto.toJson());
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load say, status: ${response.statusCode}');
    }
  }
}
