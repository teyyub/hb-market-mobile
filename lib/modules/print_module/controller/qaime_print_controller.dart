import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../http/api_class.dart';
import '../../login_module/controller/db_selection_controller.dart';
import '../models/qaime_detail_dto.dart';
import '../models/qaime_item.dart';
import '../models/qaime_print_dto.dart';
import '../service/qaime_print_service.dart';

class QaimePrintController extends GetxController {
  late QaimePrintService service;

  QaimeDetailDto? qaimeDetail;
  List<QaimeItem> qaimeItems = [];
  QaimePrintDto? qaimePrintDto;
  bool isLoading = false;
  bool isPrinting = false;
  String errorMessage = '';

  @override
  void onInit() {
    super.onInit();
    service = QaimePrintService(client: ApiClient());
  }

  void setLoading(bool v) {
    isLoading = v;
    update();
  }

  void setPrinting(bool v) {
    isPrinting = v;
    update();
  }

  Future<QaimePrintDto?> loadQaime(int id) async {
    final dbKey = DbSelectionController.to.getDbId;
    try {
      isLoading = true;
      errorMessage = '';
      update(); // UI-yə xəbər veririk

      final response = await service.fetchQaimeDetail(dbKey, id);
      qaimePrintDto = response;
      debugPrint('qaimePrint: ${qaimePrintDto}');
      return qaimePrintDto;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update(); // UI yenilənir
    }
  }
}
