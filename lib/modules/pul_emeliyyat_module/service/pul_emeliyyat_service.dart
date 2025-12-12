import 'dart:convert';

import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/update_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/pul_emeliyyat_module/models/pul_emeliyyati_model.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';

class PulEmeliyyatService {
  final ApiClient client;
  PulEmeliyyatService({required this.client});

  Future<List<PulEmeliyyati>> fetchPulEmeliyyat(int dbKey) async {
    final endpoint = '/api/pul-emeliyyat?dbKey=$dbKey';
    final response = await client.get(endpoint);
    print('pulEmeliyyatServive...${response.statusCode}');
    if (response.statusCode == 200) {
      print('object ${response.body}');
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => PulEmeliyyati.fromJson(json as Map<String, dynamic>))
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

  Future<int> xercYeni(int dbKey, XercRequestDto requestDto) async {
    final endpoint = '/api/partnyors/xerc-yeni?dbKey=$dbKey';
    // final requestDto = XercRequestDto(
    //   mustId: mustId,
    //   kassaId: kassaId,
    //   amount: amount,
    //   pays: .0,
    //   categoryId: 1,
    //   subCategoryId: 1,
    //   sebeb: '',
    //   qeyd: '',
    //   sign: tip,
    // );
    final response = await client.put(endpoint, body: requestDto.toJson());
    print('xercYeni...${response.statusCode}');
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
