import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiHelper {
  static Future<void> handleApiCall(
      Future<Map<String, dynamic>> Function() apiCall,
      ) async {
    try {
      final result = await apiCall();

      if (result['success'] == true) {
        Get.snackbar(
          'Uğurlu əməliyyat',
          result['message'] ?? 'Əməliyyat uğurla başa çatdı',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(.7),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Xəta',
          result['message'] ?? 'Xəta baş verdi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Xəta',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(.7),
        colorText: Colors.white,
      );
    }
  }
}
