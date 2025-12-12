import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dto.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_model.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_request.dart';
import 'package:hbmarket/modules/hereket_module/models/work_item.dart';
import 'package:hbmarket/modules/hereket_module/service/hereket_service.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/pul_tranfer_model.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';

class HereketPlaniController extends GetxController with ColumnVisibilityMixin {
  List<HereketResponse> herekets = [];
  List<HereketDto> hereketDtos = [];

  List<HereketResponse> invoices = [];

  TextEditingController? activeController;

  List<WorkItem> workItems = [
    WorkItem(id: 1, name: "No"),
    WorkItem(id: 2, name: "Barkod"),
    WorkItem(id: 3, name: "Ad"),
  ];
  String searchQuery = '';
  late final HereketService service;

  bool isLoading = false;

  String errorMessage = '';

  int? get selectedId => _selectedId;
  int? _selectedId;

  int? get dplaId => _dplanId;
  int? _dplanId;


  WorkItem? _selectedWorkItem;
  WorkItem? get selectedWorkItem => _selectedWorkItem;


  HereketDto? _selectedHereket;
  HereketDto? get selectedHereketDto => _selectedHereket;

  Obyekt? _selectedObyekt;
  Obyekt? get selectedObyekt => _selectedObyekt;

  Partnyor? _partnyor;
  Partnyor? get selectedPartnyor => _partnyor;

  void selectHereket(HereketResponse item) {
    _selectedId = item.id;
    _dplanId = item.id;
    _selectedObyekt = item.obyekt;
    _selectedHereket  = item.hereket;
    debugPrint(item.toString());
    debugPrint('dplanid :$_dplanId');
    update();
  }

  void setActiveController(TextEditingController ctrl){
    activeController = ctrl;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    initColumns('hereketColumns', [
      {'key': 'id', 'label': 'No', 'visible': true},
      {'key': 'hereket', 'label': 'Hərəkət', 'visible': true},
      {'key': 'obyekt', 'label': 'Obyekt', 'visible': true},
      {'key': 'partner', 'label': 'Partnyor', 'visible': true},
      {'key': 'percentage', 'label': 'Faiz', 'visible': true},
      {'key': 'note', 'label': 'Qeyd', 'visible': true},
    ]);

    service = HereketService(client: ApiClient());
    // fetchHereketPlani();
    preloadData();
  }

  @override
  void onClose() {
    debugPrint('HereketPlaniController disposed');
    super.onClose();
  }


  void setHerekets(List<HereketResponse> list) {
    herekets = list;

    // Auto-select the first item if none is selected
    if (selectedId == null && herekets.isNotEmpty) {
      selectHereket(herekets.first);
    }

  }



  Future<void> fetchHereketPlani() async {
    // debugPrint('fetched herekets...');
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('dbId.....->${dbId}');
      final fetchedHerekets = await service.fetchHereketPlani(dbId);
      setHerekets(fetchedHerekets);
      print('hereketPlani ${herekets.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> saveNewHereket(HereketRequest dto) async {
    // debugPrint('save herekets...');
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('dto.....->${dto.toJson()}');

      final response = await service.saveNew(dbId, dto);
      if (response['message'] == 'Ok') {
        await fetchHereketPlani();
        // selectTransfer(response['id']);
        Get.snackbar('Success', 'Yeni transfer ugurla yadda saxlanildi!');
      }

      // print('herekets ${herekets}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateHereket(HereketRequest dto) async {
    // debugPrint('updateHerekets...${dto.toJson()}');
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('dto.....->${dto.toJson()}');

      final response = await service.updateHereket(dbId, dto);
      if (response['message'] == 'Ok') {
        fetchHereketPlani();
        Get.snackbar('Success', 'Transfer ugurla yadda saxlanildi!');
      }

      // print('herekets ${herekets}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchHereketDto() async {
    // debugPrint('fetched herekets...');
    try {
      final int dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('dbId.....->${dbId}');
      hereketDtos = await service.fetchHerekets(dbId);
      debugPrint('herekets ${herekets}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  void resetSelections() {
    _selectedHereket = null;
    _selectedObyekt = null;
    _partnyor = null;
    update(); // make UI rebuild
  }

  Future<void> preloadData() async {
    debugPrint('preload Called');
    await fetchHereketDto();
  }

  void setSelectedHereketDto(HereketDto r) {
    _selectedHereket = r;
    debugPrint('hereketDto - > ${r}');
    update();
  }

  void setSelectedObyekt(Obyekt r) {
    _selectedObyekt = r;
    debugPrint('obyektDto - > ${r}');
    update();
  }

  void setSelectedPartnyor(Partnyor r) {
    _partnyor = r;
    debugPrint('partnyorDto - > ${r}');
    update();
  }

  void setSelectedWorkItem(WorkItem r) {
    _selectedWorkItem = r;
    debugPrint('workItem - > ${r}');
    update();
  }



  Future<void> deleteHereket(int selectedId) async {
    try {
      final int dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      debugPrint('selectedId $selectedId');
      await service.deleteHereket(dbId, selectedId);
      // print('herekets ${herekets}');
      await fetchHereketPlani();
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  void refreshHereket() async{
    try {
      final int dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      debugPrint('selectedId $selectedId');
      await service.refreshHereket(dbId);
      // print('herekets ${herekets}');
      await fetchHereketPlani();
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }
}
