import 'dart:convert';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/temizlenme_module/models/temizle_model.dart';
import 'package:http/http.dart';

class TemizlenmeService {
  final ApiClient client;

  TemizlenmeService({required this.client});

  /// Fetch all temizlenme records
  Future<List<Temizlenme>> fetchAll() async {
    final response = await client.get('/api/temizlenme');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Temizlenme.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load temizlenme records');
    }
  }

  /// Fetch single temizlenme by ID
  Future<Temizlenme> fetchById(int id) async {
    final response = await client.get('/api/temizlenme/$id');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return Temizlenme.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load temizlenme with id $id');
    }
  }

  /// Update temizlenme date
  Future<void> updateDate(int id, Temizlenme dto) async {
    final response = await client.put(
      '/api/temizlenme/$id',
      body: dto.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update temizlenme date');
    }
  }
}
