import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class JsonTranslations extends Translations {
  Map<String, Map<String, String>> translations = {};

  JsonTranslations();

  Future<void> load() async {
    final data = await rootBundle.loadString('assets/translations.json');
    final Map<String, dynamic> jsonResult = json.decode(data);

    translations = jsonResult.map((key, value) {
      return MapEntry(key, Map<String, String>.from(value));
    });
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
