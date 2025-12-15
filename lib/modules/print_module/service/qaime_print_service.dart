import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hbmarket/modules/print_module/models/qaime_detail_dto.dart';
import 'package:hbmarket/modules/print_module/models/qaime_print_dto.dart';

import '../../../http/api_class.dart';
import '../models/qaime_item.dart';

class QaimePrintService {
  final ApiClient client;


  QaimePrintService({required this.client});

  Future<QaimePrintDto> fetchQaimeDetail(int dbKey, int id) async {
    final endpoint = '/api/qaime-print?dbKey=$dbKey&id=$id';
    try {
      final response = await client.get(endpoint);
      print('fetchresponse.statusCode=${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('response: ${response.body}');
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final qaimeDetail = QaimeDetailDto.fromJson(jsonMap['qaimeDetailDto']);
        debugPrint('qaimeDetail:${qaimeDetail.toJson()}');
        final qaimeItems = (jsonMap['qaimeItems'] as List)
            .map((e) => QaimeItem.fromJson(e))
            .toList();

        return QaimePrintDto(
          qaimeDetail: qaimeDetail,
          qaimeItems: qaimeItems,
        );
      } else {
        throw Exception('Failed to load qaime print');
      }
    } on HttpException catch (e) {
      print('HTTP error: $e');
      rethrow; // Rethrow if you want upstream handling
    } on FormatException catch (e) {
      print('JSON format error: $e');
      throw FormatException('Invalid JSON format received from API');
    } on Exception catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch herekets: $e');
    }

  }
}

