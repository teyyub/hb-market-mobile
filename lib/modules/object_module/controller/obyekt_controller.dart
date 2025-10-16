import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/object_module/service/obyekt_service.dart';

class ObyektController extends GetxController {
  final ScrollController listScrollController = ScrollController();
  List<Obyekt> obyekts = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  Obyekt _selectedObyekt = Obyekt.empty;

  late final ObyektService service;

  @override
  void onInit() {
    super.onInit();
    service = ObyektService(client: ApiClient());
    fetchObyekts();
  }

  void fetchObyekts() async {
    try {
      print('fetched object...');

      final dbId = DbSelectionController.to.getDbId;
      print('${dbId}');
      isLoading = true;
      errorMessage = '';
      update(); // UI-yə xəbər veririk

      final data = await service.fetchObjects(dbId);
      // obyekts = data;
      obyekts = [Obyekt.empty, ...data];
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  List<Obyekt> get filteredObyekt {
    if (searchQuery.isEmpty) return obyekts;
    return obyekts
        .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  Obyekt get selectedObyekt => _selectedObyekt;

  String get selectedObyektLabel =>
      selectedObyekt.isEmpty ? "selectObject".tr : selectedObyekt.name;

  void setSelectedObyekt(Obyekt obyekt) {
    _selectedObyekt = obyekt;
    print('selectedObject...${_selectedObyekt}');
    update();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    update();
  }
}
