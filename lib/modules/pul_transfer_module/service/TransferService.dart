import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/tranfer_request.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/transfer_response.dart';

class TransferService {
  final ApiClient client;
  TransferService({required this.client});

  Future<List<TransferResponse>> fetchTransfers(int dbKey) async {
    final endpoint = '/api/pul-transfer?dbKey=$dbKey';
    try {
      final response = await client.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map(
              (json) => TransferResponse.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to load transfers');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e, stack) {
      // Any other unexpected exception
      print('⚠️ Unexpected error: $e');
      print(stack);
      throw Exception('Unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> updateTransfer(
    int dbKey,
    TransferRequest requestDto,
  ) async {
    final endpoint = '/api/pul-transfer?dbKey=$dbKey';

    final response = await client.put(endpoint, body: requestDto.toJson());
    print('updateTransferServive...${response.statusCode}');
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load partnyor');
    }
  }

  Future<Map<String, dynamic>> newTransfer(
    int dbKey,
    TransferRequest requestDto,
  ) async {
    final endpoint = '/api/pul-transfer?dbKey=$dbKey';
    debugPrint('transferServiceNew... ${requestDto.toJson()}');
    final response = await client.post(endpoint, body: (requestDto.toJson()));
    print('newTransfer???...${response.statusCode}');
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load partnyor');
    }
  }
}
