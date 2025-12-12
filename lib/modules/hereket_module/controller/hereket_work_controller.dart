import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';

import 'package:hbmarket/modules/hereket_module/models/daime.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dplan.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dto.dart';

import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';

import 'package:hbmarket/modules/hereket_module/models/work_item.dart';
import 'package:hbmarket/modules/hereket_module/service/hereket_service.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';

import '../../common/api_helper.dart';
import '../../common/utils/validator.dart';
import '../models/apply_dto.dart';
import '../models/f1_dto.dart';

class HereketWorkController extends GetxController with ColumnVisibilityMixin {
  TextEditingController? activeController;
  VoidCallback? onAmountFocusRequested;

  String? _selectedValue = '1';
  void setSelectedValue(String value) {
    _selectedValue = value;
    update(); // GetBuilder/Obx ilə UI-ni refresh etmək üçün
  }
  String? get getSelectedValue => _selectedValue;

  bool get isBarcode =>
      selectedWorkItem?.name.toLowerCase() == 'barkod';
  bool get onlyNumbers =>
      selectedWorkItem?.name.toLowerCase() == 'no';

  List<QaimeDto> qaimeler = [];

  List<WorkItem> workItems = [
    WorkItem(id: 1, name: "No"),
    WorkItem(id: 2, name: "Barkod"),
    WorkItem(id: 3, name: "Ad"),
  ];
  String searchQuery = '';
  late final HereketService service;
  bool isLoading = false;
  String errorMessage = '';
  bool _sol = false;
  bool _sag = false;
  bool _auto = false;

  bool get sol => _sol;

  set setSol(bool value) {
    _sol = value;
    update();
  }

  bool get sag => _sag;

  set setSag(bool value) {
    _sag = value;
    update();
  }

  bool get auto => _auto;

  set setAuto(bool a){
    _auto =a;
    update();
  }

  int? get selectedId => _selectedId;
  int? _selectedId;

  set setSelectedId(int? value) {
    _selectedId = value;
    update();
  }


  TextEditingController searchItemController = TextEditingController();
  TextEditingController rController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  final FocusNode searchFocusNode = FocusNode();
  final FocusNode amountFocus = FocusNode();
  final FocusNode rQiymetFocus = FocusNode();


  void _setupFocusListeners() {
    amountFocus.addListener(_onAmountFocus);
    rQiymetFocus.addListener(_onRQiymetFocus);
    searchFocusNode.addListener(_onSearchFocus);
  }

  void _onAmountFocus() {
    if (amountFocus.hasFocus) {
      setActiveController(amountController);
      // _scrollToEnd();
    }
  }

  void _onRQiymetFocus() {
    if (rQiymetFocus.hasFocus) {
      setActiveController(rController);
    }
  }

  void _onSearchFocus() {
    if (searchFocusNode.hasFocus) {
      setActiveController(searchItemController);
    }
  }

  void _setupSearchListener() {
    searchItemController.addListener(() {
      final value = searchItemController.text;
      // istəsən debouncing də əlavə edə bilərəm
      debugPrint("Search changed: $value");
    });
  }

  void _setupAmountFocusRequest() {
    amountController.addListener(() {
      if (amountController.text.isNotEmpty) {
        debugPrint("Amount changed: ${amountController.text}");
      }
    });
  }


  void setNoteText(String text) {
    noteController.text = text;
  }

  void clearAllInputs() {
    searchItemController.clear();
    amountController.clear();
    rController.clear();
    noteController.clear();
  }

  void setActiveController(TextEditingController ctrl){
    activeController = ctrl;
    debugPrint('activeCtrl : ${ctrl}');
    update();
  }

  void setSearchItemController(TextEditingController controller) {
    searchItemController = controller;
  }

  void setAmountController(TextEditingController c){
    this.amountController = c;
  }
  void setNoteController(TextEditingController n){
    this.noteController = n;
  }

  void setRController(TextEditingController controller) {
    rController = controller;
  }

  void handleOk({
    required int hereketId,
    required int dPlanId,
  }) {
    if (_selectedValue == '2') {
      _handleDPlan(dPlanId);
    }
    // else if (selectedValue == '1') {
    //   _handleApply(hereketId, dPlanId);
    // } else {
    //   _handleF1(hereketId, dPlanId);
    // }
  }
  void _handleDPlan(int dPlanId) {
    final dto = HereketDPlan(
      dPlanId: dPlanId,
      hereketId: selectedQaimeDto?.id,
      amount: int.tryParse(amountController.text),
      price: double.tryParse(rController.text),
      sellPrice: selectedQaimeDto?.satis,
      note: noteController.text,
    );
    debugPrint('handleDplan:${dto}');
    //ok(dto);

    clearAllInputs();
    reset();
    // _scrollToTop();
  }



  // OK düyməsi üçün lojiq
  HereketDPlan? createHereketDPlan() {
    if (!Validators.number(amountController, "Miqdar düzgün daxil edilməyib!")) return null;
    if (!Validators.show(selectedQaimeDto != null, "Əməliyyat üçün mal seçilməyib!")) return null;

    return HereketDPlan(
      dPlanId: selectedQaimeDto?.id,
      hereketId: selectedId,
      amount: int.tryParse(amountController.text),
      price: double.tryParse(rController.text),
      sellPrice: selectedQaimeDto?.satis,
      note: noteController.text,
    );
  }

  ApplyDto? createApplyDto(int hereketId, int dPlanId) {
    if (!Validators.number(amountController, "Miqdar düzgün daxil edilməyib!")) return null;
    if (hereketId != 5 && !Validators.number(rController, "Qiymət düzgün daxil edilməyib!")) return null;
    if (!Validators.show(selectedQaimeDto != null, "Əməliyyat üçün mal seçilməyib!")) return null;

    return ApplyDto(
      hereketId: hereketId,
      dPlanId: dPlanId,
      nov: selectedQaimeDto?.id,
      amount: int.tryParse(amountController.text),
      price: hereketId == 5 ? null : double.tryParse(rController.text),
      note: noteController.text,
    );
  }


  F1Dto createF1Dto() {
    return F1Dto(
      amount: int.tryParse(amountController.text),
      price: double.tryParse(rController.text),
      sellPrice: double.tryParse(rController.text),
    );
  }

  // void _scrollToTop() {
  //   scrollCtrl.animateTo(
  //     0,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  // void _scrollToEnd() {
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     scrollCtrl.animateTo(
  //       scrollCtrl.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }

  // void updateSelected(String value) {
  //   selectedValue = value;
  //   update();   // <-- refresh UI
  // }

  WorkItem? _selectedWorkItem;
  WorkItem? get selectedWorkItem => _selectedWorkItem;

  QaimeDto? _selectedQaimeDto;
  QaimeDto? get selectedQaimeDto => _selectedQaimeDto;

  HereketDto? _selectedHereket;
  HereketDto? get selectedHereketDto => _selectedHereket;

  void setSelectedHereketDto(HereketDto dto){
     _selectedHereket  = dto;
  }

  int? _selectedObyektId;
  Obyekt? _selectedObyekt;
  Obyekt? get selectedObyekt => _selectedObyekt;

  Partnyor? _partnyor;
  Partnyor? get selectedPartnyor => _partnyor;


  String? _selectedBasliqItem = 'Alış' ;
  String? get selectedBasliqItem => _selectedBasliqItem;

  // List<String> fields = ['','Aliş 0', 'Aliş', 'Satiş', 'Satiş. 2', 'Satiş. 3', 'Ob .qiy.' , 'En son'];

  final Map<String, String> fieldMapping = {
    '': '',
    'Alış 0': 'alis0',
    'Alış': 'alis',
    'Satış': 'satis',
    'Satış. 2': 'satis2',
    'Satış. 3': 'satis3',
    'Satış. 4': 'satis4',
    'Satış. 5': 'satis5',
    'Satış. 6': 'satis6',
    'Ob .qiy.': 'alisN4',
    'En son': 'satisN4',
  };



  void setSelectedBasliqItem(String r) {
    _selectedBasliqItem = r;
    debugPrint('workItem - > ${r}');
    update();
  }


  // void setQaimeler(List<QaimeDto> list) {
  //   qaimeler = list;
  //
  //   // Auto-select the first item if none is selected
  //   if (selectedId == null && qaimeler.isNotEmpty) {
  //     setSelectedQaimeDto(qaimeler.first);
  //   }
  //
  // }
  void clearQaimeler(){
    qaimeler = [];
    update();
  }
  void setSelectedQaimeDto(QaimeDto q) {
    _selectedQaimeDto = q;
    debugPrint('_selectedQaimeDto ..${_selectedQaimeDto}');
    update();
  }

  void selectHereket(HereketResponse item) {
    _selectedId = item.id;
    debugPrint(_selectedId.toString());
    update();
  }
    // void setSelectedObyektId(Obyekt oby){
    //   _selectedObyekt = oby;
    //   update();
    // }
  String getSelectedFieldValue(String label) {
    final key = fieldMapping[label];
    return selectedQaimeDto?.valueOf(key ?? '') ?? '';
  }

  // Add this method
  void applyR(TextEditingController rController) {
    if (selectedQaimeDto == null) return;
    rController.text = getSelectedFieldValue(selectedBasliqItem ?? '');
  }

  // void applyR() {
  //   if (selectedQaimeDto == null) return;
  //   rController.text = getSelectedFieldValue(selectedBasliqItem ?? '');
  //   amountFocus.requestFocus();
  // }

  Future<void> setSearchQuery(String search, {bool autoVal = false}) async {
    debugPrint('clicked....${search}');
    try {
      final dbId = DbSelectionController.to.getDbId;

      isLoading = true;
      update();
      errorMessage = '';
      String field = getFieldForWorkItem(_selectedWorkItem);
      debugPrint('field...${field}');
      String idValue = '';
      String barkodValue = '';
      String nameValue = '';

      switch (field) {
        case 'id':
          idValue = search;
          break;
        case 'barkod':
          barkodValue = search;
          break;
        case 'name':
          nameValue = search;
          break;
      }
      debugPrint('before call...');
      int? parsedId = (idValue != null && idValue.isNotEmpty)
          ? int.parse(idValue)
          : null;
      debugPrint('before call...${parsedId} ${_selectedObyektId} ${barkodValue}' );
      qaimeler = await service.fetchQaime(
        dbId,
        _selectedObyektId!,
        parsedId,
        barkodValue,
        nameValue,
        sol,
        sag,
      );

      // debugPrint('qaime: ${qaimeler}');

      if (qaimeler.length==1){

        _selectedQaimeDto = qaimeler.first;
        // applyR();
        applyR(rController);
        update();
        if (onAmountFocusRequested != null) {
          onAmountFocusRequested!();
        }


        //bunu ne ucun edib bilmirem

        // // Call ok automatically
        // final dto = HereketDPlan(
        //   dPlanId: _selectedQaimeDto?.id,
        //   hereketId: selectedId,
        //   amount: 1,
        //   price: double.tryParse(rController.text ?? ''),
        //   sellPrice: _selectedQaimeDto?.satis,
        //   note: noteController.text,
        // );
        // debugPrint('auto  ${auto}');
        // if (auto){
        //   ok(dto);
        //   reset();
        // } else {

        // }

      }

      // print('qaimeler ${qaimeler}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    // loadConfigNew(selectedHereketDto?.id.toString());

    _initTableCol();
    service = HereketService(client: ApiClient());
    _setupFocusListeners();
    _setupSearchListener();
    // loadConfigNew(hereketId.toString());
  }

  @override
  void onClose() {
    searchItemController.dispose();
    super.onClose();
  }

  void _initTableCol(){
    initColumns('hereketWorkColumns', [
      {'key': 'id', 'label': 'Mal No', 'visible': true},
      {'key': 'satis', 'label': 'Satis', 'visible': true},
      {'key': 'satis2', 'label': 'Satis2', 'visible': true},
      {'key': 'satis3', 'label': 'Satis3', 'visible': true},
      {'key': 'satis4', 'label': 'Satis4', 'visible': true},
      {'key': 'satis5', 'label': 'Satis5', 'visible': true},
      {'key': 'satis6', 'label': 'Satis6', 'visible': true},
      {'key': 'alis', 'label': 'Al. Qiy', 'visible': true},
      {'key': 'name', 'label': 'Mal', 'visible': true},
      {'key': 'seri', 'label': 'Barkod', 'visible': true},
    ]);
  }
  void setSelectedObyekt(Obyekt r) {
    _selectedObyekt = r;
    // debugPrint('obyektDto - > ${r}');
    update();
  }

  set setSelectedObyektId(int? r) {
    _selectedObyektId = r;
    update();
  }

  void setSelectedWorkItem(WorkItem r) {
    _selectedWorkItem = r;
    debugPrint('workItem - > ${r}');
    update();
  }

  String getFieldForWorkItem(WorkItem? item) {
    if (item == null) return '';
    switch (item.id) {
      case 1:
        return 'id';
      case 2:
        return 'barkod';
      case 3:
        return 'name';
      default:
        return '';
    }
  }

  Future<void> reset() async {
    qaimeler = [];
    // searchItemController.clear();
    // rController.clear();
    update();
  }

  void setR() {
    
  }

  // Future<void> ok(HereketDPlan dto) async{
  //
  //   try {
  //     final dbId = DbSelectionController.to.getDbId;
  //     debugPrint('dto->$dto');
  //     isLoading = true;
  //     update();
  //     errorMessage = '';
  //
  //     // final result =  await service.ok(
  //     //   dbId,
  //     //   dto,
  //     // );
  //
  //     await ApiHelper.handleApiCall(() => service.ok(dbId, dto));
  //
  //   } catch (e) {
  //     errorMessage = e.toString();
  //     Get.snackbar(
  //       'Xəta',
  //       errorMessage,
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red.withOpacity(.7),
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading = false;
  //     update();
  //   }
  // }

  Future<void> ok(HereketDPlan dto) async {

    // if (selectedValue!='2') return;
    final dbId = DbSelectionController.to.getDbId;
    debugPrint('dto -> $dto');

    isLoading = true;
    update();

    // centralized API call handling
    await ApiHelper.handleApiCall(() => service.ok(dbId, dto));

    isLoading = false;
    update();
  }

  void saveConfig() {
    final Map<String, dynamic> config = {
      'sol': sol,
      'sag': sag,
      'auto': auto,
      'selectedValue': _selectedValue,
      'selectedWorkItem': _selectedWorkItem?.toJson()
    };

    // Save to GetStorage or local file, here we use GetStorage as example
    final storage = GetStorage();
    storage.write('hereketWorkConfig', config);

    debugPrint('Config saved: $config');
  }

  void saveConfigNew(String? hereketId) {
    final storage = GetStorage();


    if (hereketId != null) {
      // Mövcud map-i götür, yoxdursa boş map
      final Map<String, String> selectedMap =
          storage.read('selectedHereketConfig')?.cast<String, String>() ?? {};

      // Cari hereketId üçün selectedValue güncəllə
      selectedMap[hereketId] = selectedBasliqItem??'';

      // Map-i saxla
      storage.write('selectedHereketConfig', selectedMap);

      debugPrint('SelectedValue saved for $hereketId: $selectedBasliqItem');

    }


    final Map<String, dynamic> config = {
      'sol': sol,
      'sag': sag,
      'auto': auto,
      'selectedValue': _selectedValue,
      'selectedWorkItem': _selectedWorkItem?.toJson()
    };

    storage.write('hereketWorkConfig', config);

    debugPrint('Config saved: $config');
  }

  void loadConfig() {
    final storage = GetStorage();
    final config = storage.read<Map<String, dynamic>>('hereketWorkConfig');
    if (config != null) {
      _sol = config['sol'] ?? false;
      _sag = config['sag'] ?? false;
      _auto = config['auto'] ?? false;
      _selectedValue = config['selectedValue']?? '1';
      final itemJson = config['selectedWorkItem'];
      if (itemJson != null) {
        _selectedWorkItem = WorkItem.fromJson(itemJson);
      }else if (workItems.isNotEmpty) {
        _selectedWorkItem = workItems.first; // default olaraq birinci item
      }

      update();
      debugPrint('Config loaded: $config');
    }
  }

  void loadConfigNew(String? hereketId) {
    final storage = GetStorage();
    final Map<String, dynamic> savedMap =
        storage.read('selectedHereketConfig') ?? {};


    final config = storage.read<Map<String, dynamic>>('hereketWorkConfig');
    if (config != null) {
      _sol = config['sol'] ?? false;
      _sag = config['sag'] ?? false;
      _auto = config['auto'] ?? false;
      _selectedValue = config['selectedValue']?? '1';
      final itemJson = config['selectedWorkItem'];
      if (itemJson != null) {
        _selectedWorkItem = WorkItem.fromJson(itemJson);
      }else if (workItems.isNotEmpty) {
        _selectedWorkItem = workItems.first; // default olaraq birinci item
      }
      debugPrint('selectedWorkItem:${selectedWorkItem}');
      final String? savedValue =
      savedMap[hereketId] != null && savedMap[hereketId].toString().isNotEmpty
          ? savedMap[hereketId].toString()
          : null;

      if (savedValue != null) {
        setSelectedBasliqItem(savedValue);
        debugPrint(
            'Loaded selectedBasliqItem for hereketId=$hereketId → $savedValue');
      } else {
        debugPrint('No saved selectedBasliqItem found for hereketId=$hereketId');
      }


      update();
      debugPrint('Config loaded: $config');
    }
  }

}
