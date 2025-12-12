import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Validators {
  // ✅ Percentage validation
  static bool validatePercentage(String value) {
    if (value.isEmpty) return false;

    try {
      final decimalValue = Decimal.parse(value);
      final min = Decimal.fromInt(-9999);
      final max = Decimal.fromInt(100);
      if (decimalValue < min  || decimalValue > max) {
        return false;
      }
      return true;
    } catch (e) {
      return false; // not a valid decimal
    }
  }

  static bool show(bool condition, String message) {
    if (condition) return true;

    Get.snackbar(
      "Xəta",
      message,
      backgroundColor: Colors.red.withOpacity(.7),
      colorText: Colors.white,
    );
    return false;
  }

  static bool number(TextEditingController ctrl, String message) {
    final v = num.tryParse(ctrl.text.trim());
    if (v == null || v <= 0) {
      Get.snackbar(
        "Xəta",
        message,
        backgroundColor: Colors.red.withOpacity(.7),
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }
}
