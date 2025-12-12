import 'dart:convert';
import 'dart:io';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';

class ObyektService {
  final ApiClient client;
  ObyektService({required this.client});

  Future<List<Obyekt>> fetchObjects(int dbKey) async {
    final endpoint = '/api/obyekts?dbKey=$dbKey';
    try {
      final response = await client.get(endpoint);
      print('fetchObjects response.statusCode=${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => Obyekt.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load obyektler');
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
