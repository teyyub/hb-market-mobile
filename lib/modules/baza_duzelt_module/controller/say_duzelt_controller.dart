import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/baza_duzelt_module/models/say_duzelt_request.dart';
import 'package:hbmarket/modules/baza_duzelt_module/service/say_duzelt_service.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';

class SayDuzeltController extends GetxController {
  TextEditingController txtController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  // SayDuzeltController ctrl = Get.find<SayDuzeltController>();
  TextEditingController? activeController;

  late final SayDuzeltService service;
  FocusNode idFocus = FocusNode();
  FocusNode barcodeFocus = FocusNode();
  FocusNode txtFocus = FocusNode();
  @override
  void onInit() {
    super.onInit();
    service = SayDuzeltService(client: ApiClient());
    idFocus.addListener(() {
      if (idFocus.hasFocus) activeController = idController;
    });
    barcodeFocus.addListener(() {
      if (barcodeFocus.hasFocus) activeController = barcodeController;
    });
    txtFocus.addListener(() {
      if (txtFocus.hasFocus) activeController = txtController;
    });
  }

  @override
  void onClose() {
    txtController.dispose();
    barcodeController.dispose();
    idController.dispose();
    idFocus.dispose();
    barcodeFocus.dispose();
    txtFocus.dispose();
    super.onClose();
  }

  Future<int?> qaliq(SayDuzeltRequest dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('qaliq.... ${dto.toJson()}');

      // Example: call your backend API
      // int res = await service.xercYeni(dbId, mustId, kassaId, amount, tip);
      final result = await service.qaliq(dbId, dto);
      final cavab = result['cavab'] ?? '';
      final miqdar = result['miqdar'];
      if (miqdar == null) {
        // Show message when no quantity
        Get.snackbar('Məlumat', cavab.isNotEmpty ? cavab : 'Miqdar tapılmadı');
        txtController.text = '';
      } else {
        // Show success with quantity
        // Get.snackbar('Uğurlu', 'Miqdar: $miqdar');
        txtController.text = miqdar.toString();
        txtController.selection = TextSelection.fromPosition(
          TextPosition(offset: txtController.text.length),
        );
      }
      update();
      return miqdar;

      // Get.snackbar('Success', 'Yeni xerc ugurla yadda saxlanildi!');

      // Update local list if needed
    } catch (e) {
      Get.snackbar('Xəta', 'API çağırışı zamanı xəta: $e');
      return null;
    }
  }

  Future<void> duzelt(SayDuzeltRequest dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('sayRequest.... ${dto.toJson()}');

      // Example: call your backend API
      // int res = await service.xercYeni(dbId, mustId, kassaId, amount, tip);
      final response = await service.duzelt(dbId, dto);
      final cavab = response['cavab'] as String?;
      if (cavab != null && cavab.toLowerCase() == 'ok') {
        // Optional: update your local list / UI
        update();

        Get.snackbar('Success', 'Ugurla yadda saxlanildi!');
      } else {
        Get.snackbar('Error', cavab ?? 'Unknown error from server');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
