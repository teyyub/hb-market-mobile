import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/partnyor_module/data/fake_partnyor_list.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_light.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/partnyor_service/partnyor_service.dart';

import '../models/PartnyorFilter.dart';

class PartnyorController extends GetxController with ColumnVisibilityMixin {
  List<Partnyor> partnyors = [];
  List<PartnyorLight> partnyorTypes = [];
  String searchQuery = '';
  bool isLoading = false;
  bool isPartnyorTypesLoading = false;
  String errorMessage = '';
  String selectedRadio = '';
  late final PartnyorService service;
  int? _selectedMustId;
  PartnyorLight? _selectedPartnyorType;

  int? get selectedMustId => _selectedMustId;
  PartnyorLight? get selectedPartnyorType => _selectedPartnyorType;
  void setSelectedPartnyorType(PartnyorLight? type) {
    _selectedPartnyorType = type;
    update(); // UI-ni yeniləmək üçün GetBuilder istifadə olunursa
  }


  void selectPartnyor(int id) {
    _selectedMustId = id;
    print('selectedPartnyor...${_selectedMustId}');
    update(); // triggers GetBuilder rebuild
  }

  void selectFirstIfNull() {
    if (selectedMustId == null && partnyors.isNotEmpty) {
      _selectedMustId = partnyors.first.id;
    }
  }

  @override
  void onInit() {
    super.onInit();
    initColumns('partnyorColumns', [
      {'key': 'id', 'label': 'No', 'visible': true},
      {'key': 'ad', 'label': 'Ad', 'visible': true},
      {'key': 'borc', 'label': 'Borc', 'visible': true},
      {'key': 'tip', 'label': 'Tip', 'visible': true},
      {'key': 'aktiv', 'label': 'Aktiv', 'visible': true},
    ]);
    service = PartnyorService(client: ApiClient());
    // load initial data
    fetchPartnors();
  }

  void setSelectedRadio(String value) {
    selectedRadio = value;
    print('selectedRadio ${selectedRadio}');
    update(); // rebuild GetBuilder
  }

  void setDialogItems() {
    selectedRadio = '';
    update();
  }

  Future<void> fetchPartnors() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('dbId.....->${dbId}');
      partnyors = await service.fetchPartnyors(dbId);
      if (partnyors.isNotEmpty && _selectedMustId == null) {

        _selectedMustId = partnyors.first.id;
        debugPrint('selectFirst...$_selectedMustId');

      }
      // print('partnyor ${partnyors.length}');

      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }


  Future<void> fetchPartnorTypes() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isPartnyorTypesLoading = true;
      update();
      errorMessage = '';
      // print('dbId.....->${dbId}');
      partnyorTypes = await service.fetchPartnyorTypes(dbId);

      print('partnyorTypes ${partnyorTypes.length}');

      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isPartnyorTypesLoading = false;
      update();
    }
  }

  Future<void> saveYeniXerc(XercRequestDto dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('xercrequest.... ${dto.toJson()}');

      // Example: call your backend API
      // int res = await service.xercYeni(dbId, mustId, kassaId, amount, tip);
      int res = await service.xercYeni(dbId, dto);
      if (res == 200) {
        fetchPartnors();
      }

      // Update local list if needed
      update();
      Get.snackbar('Success', 'Yeni xerc ugurla yadda saxlanildi!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void xercQazancUpdate(XercRequestDto dto) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      // print('dbId.... ${dbId}');
      // print('mustId.... ${mustId}');
      // print('kassa.... ${kassaId}');
      // print('tip.... ${tip}');
      // print('amount.... ${amount}');
      // Example: call your backend API
      debugPrint("dto...${dto}");
      int res = await service.updateMustBorcKassa(
        dbId,
        dto.mustId,
        dto.kassaId,
        dto.amount!,
        dto.sign!,
      );
      // return res;
      // // Update local list if needed
      // update();
      // Get.snackbar('Success', 'Partnyor saved successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void filterPartnyor({
    PartnyorFilter? filter
  }) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      isLoading = true;
      update();
      // Example: call your backend API
      final res = await service.filterPartnyors(dbId,  filter );
      debugPrint('res...${res.length}');
      partnyors = res;
      isLoading = false;
      // Update local list if needed
      update();
      // Get.snackbar('Success', 'Partnyor saved successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  void addOrUpdatePartnyor({
    required int mustId,
    required int kassaId,
    required double amount,
    required String tip,
  }) async {
    final dbId = DbSelectionController.to.getDbId;
    try {
      print('dbId.... ${dbId}');
      print('mustId.... ${mustId}');
      print('kassa.... ${kassaId}');
      print('tip.... ${tip}');
      print('amount.... ${amount}');
      // Example: call your backend API
      int res = await service.updateMustBorcKassa(
        dbId,
        mustId,
        kassaId,
        amount,
        tip,
      );
      if (res == 200) {
        fetchPartnors();
      }

      // Update local list if needed
      update();
      // Get.snackbar('Success', 'Partnyor saved successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  List<Partnyor> get filteredCustomers {
    if (searchQuery.isEmpty) return partnyors;
    return partnyors
        .where(
          (c) =>
              c.ad.toLowerCase().contains(searchQuery.toLowerCase()) ||
              c.ad.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void addCustomer(Partnyor customer) {
    // customers.add(customer);
    update();
  }

  void removeCustomer(int index) {
    // customers.removeAt(index);
    update();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    update();
  }

  void setSelectedPartnyor(Partnyor r) {
    
  }
}
