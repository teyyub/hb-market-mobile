import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/baza_duzelt_module/models/say_duzelt_request.dart';
import 'package:hbmarket/modules/hereket_module/models/daime.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dplan.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dto.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_model.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_request.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/update_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:http/src/response.dart';

import '../../common/api_messages.dart';
import '../models/apply_dto.dart';
import '../models/qaime_bax.dart';
import '../models/update_apply.dart';

class HereketService {
  final ApiClient client;
  HereketService({required this.client});

  Future<Map<String, dynamic>> saveNew(
    int dbKey,
    HereketRequest requestDto,
  ) async {
    final endpoint = '/api/hereket-plani?dbKey=$dbKey';
    final response = await client.post(endpoint, body: requestDto.toJson());
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Failed to load qaliq');
    }
  }

  Future<Map<String, dynamic>> updateHereket(
    int dbKey,
    HereketRequest requestDto,
  ) async {
    final endpoint = '/api/hereket-plani?dbKey=$dbKey';
    try {
      final response = await client.put(endpoint, body: requestDto.toJson());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw HttpException('Failed to update hereket: ${response.statusCode}');
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

  Future<List<HereketResponse>> fetchHereketPlani(int dbKey) async {
    final String endpoint = '/api/hereket-plani?dbKey=$dbKey';
    try {
      final Response response = await client.get(endpoint);
      if (response.statusCode == 200) {
        debugPrint('hereketServive...${response.body}');
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map(
              (json) => HereketResponse.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw HttpException(
          'Failed to load herekets. Status code: ${response.statusCode}',
        );
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

  Future<List<HereketDto>> fetchHerekets(int dbKey) async {
    final String endpoint = '/api/hereket-plani/hereket?dbKey=$dbKey';
    // debugPrint('fetchHereket...');
    try {
      final Response response = await client.get(endpoint);
      // print('hereketServive...${response.statusCode}');
      // print('hereketServive...${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => HereketDto.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Failed to load herekets. Status code: ${response.statusCode}',
        );
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

  Future<void> deleteHereket(int dbKey, int selectedId) async {
    final String endpoint = '/api/hereket-plani?dbKey=$dbKey&id=$selectedId';

    try {
      final Response response = await client.delete(endpoint);
      if (response.statusCode == 200) {
      } else {
        throw HttpException(
          'Failed to load herekets. Status code: ${response.statusCode}',
        );
      }
    } on HttpException catch (e) {
      debugPrint('HTTP error: $e');
      rethrow; // Rethrow if you want upstream handling
    } on FormatException catch (e) {
      debugPrint('JSON format error: $e');
      throw FormatException('Invalid JSON format received from API');
    } on Exception catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to fetch herekets: $e');
    }
  }


  Future<Map<String, dynamic>> updateQaime(
      int dbKey,
      QaimeBaxDto dto,
      ) async {
    final endpoint = '/api/hereket-plani/qaime-update?dbKey=$dbKey';
    try {
      final response = await client.post(endpoint, body: dto.toJson());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw HttpException('Failed to update hereket: ${response.statusCode}');
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

  Future<List<QaimeBaxDto>> qaimeBax(
      int dbKey,
      int dPlanId
      ) async {
    final queryParams = {
      'dbKey': dbKey.toString(),
      'dplanId': dPlanId,
    };
    debugPrint('fetchQaimeParams... ${queryParams}');

    // Only keep non-null values and convert to String
    final stringQueryParams = Map.fromEntries(
      queryParams.entries
          .where((entry) => entry.value != null) // filter out nulls
          .map(
            (entry) => MapEntry(entry.key, entry.value.toString()),
      ), // convert to String
    );

    try {

      final response = await client.getWithQuery(
        '/api/hereket-plani/qaime-bax',
        queryParams: stringQueryParams,
      );
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        // print('fetchQaimeServive...${response.body}');
        final List<dynamic> jsonList = json.decode(response.body);
        // print('fetchQaimeServive...${jsonList}');
        return jsonList
            .map((json) => QaimeBaxDto.fromJson(json as Map<String, dynamic>))
            .toList();

      } else {
        throw HttpException(
          'Failed to load qaime bax. Status code: ${response.statusCode}',
        );
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

  Future<List<QaimeDto>> fetchQaime(
    int dbKey,
    int obyektId,
    int? id,
    String? barkod,
    String? name,
    bool? sol,
    bool? sag,
  ) async {
    final queryParams = {
      'dbKey': dbKey.toString(),
      'obyektId': obyektId.toString(),
      'id': id,
      'name': name,
      'barkod': barkod,
      'sol': sol,
      'sag': sag,
    };
    debugPrint('fetchQaimeParams... ${queryParams}');

    // Only keep non-null values and convert to String
    final stringQueryParams = Map.fromEntries(
      queryParams.entries
          .where((entry) => entry.value != null) // filter out nulls
          .map(
            (entry) => MapEntry(entry.key, entry.value.toString()),
          ), // convert to String
    );
    // final stringQueryParams = queryParams.map(
    //   (key, value) => MapEntry(key, value.toString()),
    // );
    // debugPrint('fetchQaime... ${stringQueryParams}');

    // final endpoint = '/api/hereket-plani/qaime?dbKey=$dbKey&obyektId=$obyektId&value=$value';
    // final uri = Uri.parse(
    //   '/api/hereket-plani/qaime',
    // ).replace(queryParameters: queryParams);
    try {
      // final response = await client.get(endpoint);
      final response = await client.getWithQuery(
        '/api/hereket-plani/v4/qaime',
        queryParams: stringQueryParams,
        //  {
        //   'dbKey': dbKey.toString(),
        //   'obyektId': obyektId.toString(),
        //   'value': value,
        // },
      );
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        // print('fetchQaimeServive...${response.body}');
        final List<dynamic> jsonList = json.decode(response.body);
        // print('fetchQaimeServive...${jsonList}');
        return jsonList
            .map((json) => QaimeDto.fromJson(json as Map<String, dynamic>))
            .toList();

      } else {
        throw HttpException(
          'Failed to load qaime. Status code: ${response.statusCode}',
        );
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


  Future<Map<String, dynamic>>  ok(
      int dbKey,
      HereketDPlan dto,
      ) async {
    try {
      final enpoint = '/api/hereket-plani/dplan?dbKey=$dbKey';
      final response = await client.post(enpoint, body: dto.toJson());
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        // print('fetchQaimeServive...${response.body}');
        final Map<String, dynamic> result = json.decode(response.body);
        print('fetchQaimeServive...${result}');
        return result;
      } else {
        final friendlyMessage = getFriendlyMessage(response.statusCode);
        throw HttpException(friendlyMessage);
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


  Future<String> refreshHereket(
      int dbKey
      ) async {
    final endpoint = '/api/hereket-plani?dbKey=$dbKey';
    final response = await client.post(endpoint);
    debugPrint('${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load qaliq');
    }
  }


  Future<ApplyDto> fetchApply(
      int dbKey,
      int? dplan,
      int? nov,
      double? price,
      int? miqdar,
      String? note

      ) async {
    final queryParams = {
      'dbKey': dbKey,
      'dplan': dplan,
      'nov': nov,
      'price': price,
      'miqdar': miqdar,
      'note': note
    };
    debugPrint('fetchApplyParams... ${queryParams}');

    final Map<String, String> stringQueryParams = Map.fromEntries(
      queryParams.entries
          .where((entry) => entry.value != null) // filter out nulls
          .map(
            (MapEntry<String, Object?> entry) => MapEntry(entry.key, entry.value.toString()),
      ), // convert to String
    );
    try {
      // final response = await client.get(endpoint);
      // debugPrint('tringQueryParams ${stringQueryParams}');
      final response = await client.getWithQuery(
        '/api/hereket-plani/applyForm',
        queryParams: stringQueryParams,
        //  {
        //   'dbKey': dbKey.toString(),
        //   'obyektId': obyektId.toString(),
        //   'value': value,
        // },
      );
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('fetchApplyForm...${response.body}');
        final jsonMap = json.decode(response.body);
        debugPrint('fetchQaimeServive...${jsonMap}');
        return  ApplyDto.fromJson(jsonMap) ;

      } else {
        throw HttpException(
          'Failed to load apply. Status code: ${response.statusCode}',
        );
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


  Future<Map<String, dynamic>> updateDplan(
      int dbKey,
      UpdateApplyDto dto
      ) async {
      final String endPoint =  '/api/hereket-plani/update-dplan?dbKey=$dbKey';

    try {

      final Response response = await client.put( endPoint, body: dto.toJson());
      debugPrint('response.statusCode...${response.statusCode}');
      if (response.statusCode == 200) {
        print('fetchQaimeServive...${response.body}');
        final jsonMap = json.decode(response.body);
        print('fetchQaimeServive...${jsonMap}');
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;

      } else {
        throw HttpException(
          'Failed to load apply. Status code: ${response.statusCode}',
        );
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
