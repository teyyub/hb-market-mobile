import 'dart:convert';

import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/update_request_dto.dart';

class PartnyorService {
  final ApiClient client;
  PartnyorService({required this.client});

  Future<List<Partnyor>> fetchPartnyors(int dbKey) async {
    final endpoint = '/api/partnyors?dbKey=$dbKey';
    final response = await client.get(endpoint);
    print('partnyorServive...${response.statusCode}');
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
      // await fetchPartnyors(dbKey);
      // final List<dynamic> jsonList = json.decode(response.body);
      // return jsonList
      // .map((json) => Partnyor.fromJson(json as Map<String, dynamic>))
      // .toList();
    } else {
      throw Exception('Failed to load partnyor');
    }
  }
}
