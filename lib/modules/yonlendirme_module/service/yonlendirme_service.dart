import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/temizlenme_module/models/temizle_model.dart';
import 'package:hbmarket/modules/yonlendirme_module/models/yonlendirme_model.dart';
import 'package:http/http.dart';

class YonlendirmeService {
  final ApiClient client;

  YonlendirmeService({required this.client});

  /// Fetch all temizlenme records
  Future<List<YonlendirmeDto>> fetchAll() async {
    final response = await client.get('/api/yonlendirme');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => YonlendirmeDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load yonlendirme records');
    }
  }

  /// Fetch single temizlenme by ID
  Future<YonlendirmeDto> fetchById(int id) async {
    final response = await client.get('/api/yonlendirme/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return YonlendirmeDto.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load temizlenme with id $id');
    }
  }

  /// Update temizlenme date
  Future<void> updateYonlendirme(int id, YonlendirmeDto dto) async {
    final response = await client.put(
      '/api/yonlendirme/$id',
      body: dto.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update yonlendirme');
    }
  }

  Future<void> updateYonlendirmeV1(int dbId, YonlendirmeDto dto) async {
    debugPrint('${dbId}');
    debugPrint('${dto.toJson()}');
    final response = await client.put(
      '/api/v1/yonlendirme?dbKey=$dbId',
      body: dto.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update yonlendirme');
    }
  }


  Future<void> updateKecidOk(int id, bool val) async {
    final response = await client.put(
      '/api/yonlendirme/$id',
      body: {'kecidOk': val},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update Yonlendirme kecidOk');
    }
  }
}
