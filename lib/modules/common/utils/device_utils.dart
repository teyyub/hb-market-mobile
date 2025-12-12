import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:html' as html;
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class DeviceUtils {
  static const _key = 'device_id';
  static bool isMobile(BuildContext context) =>  MediaQuery.of(context).size.width < 600;

  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        String? storedId = prefs.getString('device_id');
        if (storedId != null) return storedId;

        final newId = const Uuid().v4();
        // await prefs.setString('device_id', newId);
        return newId;
      } else if (Platform.isAndroid) {

        // final androidInfo = await deviceInfo.androidInfo;
        // return androidInfo.id;
        // final newId = const Uuid().v4();
        // return newId;
        final millis = DateTime.now().millisecondsSinceEpoch.toString();
        return millis;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ??
            'ios-${DateTime.now().millisecondsSinceEpoch}';
      } else {
        return 'unknown-${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      return 'error-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  static Future<int> getDeviceIdInt() async {
    debugPrint('kIsWeb ${kIsWeb}');
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final storedIdStr = prefs.getString(_key);

      if (storedIdStr != null) {
        return int.parse(storedIdStr);
      }

      // final newId = _generate10DigitId();
      String deviceId = await getDeviceId();
      // final newId = _generateDeviceInt(deviceId);
      final newId = _generateDeviceIntBetter(deviceId);
      // await prefs.setString(_key, newId.toString());
      return newId;
    } else {
      // 🔹 Use SharedPreferences on mobile
      final prefs = await SharedPreferences.getInstance();
      final storedIdStr = prefs.getString(_key);

      if (storedIdStr != null) {
        return int.parse(storedIdStr);
      }

      // final newId = _generate10DigitId();
      String deviceId = await getDeviceId();
      double ff = double.parse(deviceId);
      int  newId =  (((sin(ff*86400).abs())+1) * 1_000_000_000).toInt();
      // final newId = _generateDeviceInt(deviceId);
      // final newId = _generateDeviceIntBetter(deviceId);
      await prefs.setString(_key, newId.toString());
      return newId;
    }
  }

  static int _generate10DigitId() {
    // final millis = DateTime.now().millisecondsSinceEpoch.toString();

    // if (millis.length >= 10) {
    //   return int.parse(millis.substring(0, 10));
    // } else {
    //   final rnd = Random().nextInt(999999999);
    //   return int.parse((millis + rnd.toString()).substring(0, 10));
    // }
    final rnd = Random.secure();
    int num = rnd.nextInt(9) + 1; // first digit 1-9
    for (int i = 0; i < 9; i++) {
      num = num * 10 + rnd.nextInt(10); // digits 0-9
    }
    return num;
  }

  static int _generateDeviceInt(String deviceId) {
    var bytes = utf8.encode(deviceId);
    var digest = sha256.convert(bytes);

    // ilk 8 byte-u götür
    var hashBytes = digest.bytes.sublist(0, 8);
    var bigInt = BigInt.parse(
      hashBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    );

    int minVal = 1000000000; // 1,000,000,000 → 10 rəqəm
    int maxVal = 2147483647; // SQL INT maksimum
    int range = maxVal - minVal;

    return minVal + (bigInt % BigInt.from(range)).toInt();
  }

  static int _generateDeviceIntBetter(String deviceId) {
    final bytes = utf8.encode(deviceId);
    final digest = sha256.convert(bytes);

    // Mix all bytes (32 bytes) to reduce clustering
    BigInt bigInt = BigInt.zero;
    for (int i = 0; i < digest.bytes.length; i++) {
      bigInt += BigInt.from(digest.bytes[i]) * BigInt.from(i + 1) * BigInt.from(31).pow(i);
    }

    const minVal = 1000000000;
    const maxVal = 1999999999;
    // const maxVal = 2147483647;
    final range = maxVal - minVal;

    return minVal + (bigInt % BigInt.from(range)).toInt();
  }



  /// Generate 10-digit integer from deviceId + randomness + timestamp
  static int _generateDeviceIntNew(String deviceId) {
    final rnd = Random.secure();
    final now = DateTime.now().millisecondsSinceEpoch;
    final salt = rnd.nextInt(1000000); // 6-digit random number

    final combined = '$deviceId-$now-$salt';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);

    // Use first 8 bytes of hash
    final hashBytes = digest.bytes.sublist(0, 8);
    final bigInt = BigInt.parse(
      hashBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    );

    const minVal = 1000000000; // 10-digit minimum
    const maxVal = 2147483647; // SQL INT max
    final range = maxVal - minVal;

    return minVal + (bigInt % BigInt.from(range)).toInt();
  }
}
