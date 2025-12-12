import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/BarcodeAddDto.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/service/mal_yoxla_service.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';

import '../../common/api_helper.dart';
import '../../common/utils/field_mapping.dart';

class MalYoxlaController extends GetxController with ColumnVisibilityMixin {
  final ObyektController obyController = Get.find<ObyektController>();
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  List<SearchItem> searchItems = [];
  List<MalYoxla> fetchMalYoxla = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  SearchItem? selectedSearchItem;
  TextEditingController? activeController;
  TextEditingController? amountController ;
  int? get selectedId => _selectedId;
  int? _selectedId;

  MalYoxla? _selectedMalYoxla;
  MalYoxla? get selectedMalYoxla => _selectedMalYoxla;

  void setFethcedMalYoxla(List<MalYoxla> m) {
     fetchMalYoxla = m;
      if (selectedId ==null && fetchMalYoxla.isNotEmpty){
        setSelectedMalYoxla(fetchMalYoxla.first);
      }

  }

  void setSelectedMalYoxla(MalYoxla m) {
    _selectedMalYoxla = m;
    debugPrint('itemSelected ...${m.id}');
    update();
  }
  // Obyekt _selectedObyekt = Obyekt.empty;


  void setActiveController(TextEditingController ctrl){
    activeController = ctrl;
    update();
  }

  void setAmountController(TextEditingController c){
    this.amountController = c;
  }

  late final MalYoxlaService service;

  @override
  void onInit() {
    super.onInit();
    service = MalYoxlaService(client: ApiClient());

    // initColumns('malYoxlaColumns', [
    //   {'key': 'id', 'label': 'No', 'visible': true},
    //   {'key': 'name', 'label': 'Ad', 'visible': true},
    //   {'key': 'say', 'label': 'Say', 'visible': true},
    //   {'key': 'qiymet', 'label': 'S.Qiy', 'visible': true},
    // ]);

    initColumns(
      'malYoxlaColumns',
      allFieldMappings['malYoxlaColumns']!,
    );
    fetchSearchItems();
  }
  String? _selectedBasliqItem = 'Satış' ;
  String? _selectedBasliqValue = 'satis' ;
  String? get selectedBasliqItem => _selectedBasliqItem;

  final Map<String, String> fieldMapping = {
    '': '',
    'Alış': 'alis',
    'Alış 0': 'alis0',
    'Satış': 'satis',
    'Satış. 2': 'sat2',
    'Satış. 3': 'sat3',
    'Satış. 4': 'sat4',
    'Satış. 5': 'sat5',
    'Satış. 6': 'sat6',
    'Ob .qiy.': 'alisN4',
    // 'En son': 'satisN4',
  };

  void setSelectedBasliqItem(String r) {
    _selectedBasliqItem = r;
    update();
  }


  String getSelectedPriceValue(String? field) {
    if (selectedMalYoxla == null) return '';

    switch (field) {
      case 'alis':
      case 'alis0':
        return selectedMalYoxla!.alis.toString();

      case 'satis':
        return selectedMalYoxla!.satis.toString();

      case 'sat2':
        return selectedMalYoxla!.sat2.toString();

      case 'sat3':
        return selectedMalYoxla!.sat3.toString();

      case 'sat4':
        return selectedMalYoxla!.sat4.toString();

      case 'sat5':
        return selectedMalYoxla!.sat5.toString();

      case 'sat6':
        return selectedMalYoxla!.sat6.toString();

      default:
        return '';
    }
  }

  /// --- Centralized validation ---
  bool validateSearch(String query) {
    query = query.trim();

    if (selectedSearchItem == null) {
      errorMessage = 'Zəhmət olmasa əvvəl axtarış növünü seçin';
      update();
      return false;
    }

    if (query.isEmpty) {
      errorMessage = 'Axtarış üçün mətn daxil edin';
      update();
      return false;
    }

    // ✅ Validation passed
    errorMessage = '';
    update();
    return true;
  }

  void search(String query) {
    int? id;
    String? name;
    String? barcode;
    Map<String, dynamic> dynamicOz = {};
    if (!validateSearch(query)) return;
    searchQuery = query.trim();
    // perform your search logic here, e.g., filter items or call API
    // print("Searching for: $query");
    // print("selected: $selectedSearchItem");

    switch (selectedSearchItem!.id) {
      case 0:
        id = int.tryParse(searchQuery);
        break;
      case 1:
        name = searchQuery;
        break;
      case 2:
        barcode = searchQuery;
        break;
      default:
        if (selectedSearchItem!.title.startsWith('oz')) {
          // Extract oz number if needed
          final ozField = selectedSearchItem!.title; // e.g. "oz1", "oz2", ...
          print('Searching by $ozField = $searchQuery');
          // You can store in a map for your backend call:
          dynamicOz[ozField] = searchQuery;
        } else {
          print("Unknown search type");
        }
    }

    fetchData(id: id, name: name, barcode: barcode);

    // update(); // notify GetBuilder to rebuild UI
  }

  Future<void> fetchData({
    int? id,
    String? name,
    String? barcode,
    Map<String, dynamic>? dynamicOz,
  }) async {
    try {
      isLoading = true;
      errorMessage = '';
      update();

      final dbId = DbSelectionController.to.getDbId;
      final obyektId = obyController.selectedObyekt.id;
      // final id = selectedSearchItem?.id;
      // print('id ${id}');
      final fetched = await service.fetchMalYoxla(
        dbId,
        obyektId,
        id,
        name,
        barcode,
        dynamicOz,
      );
      print('getData....${fetched}');
      setFethcedMalYoxla(fetched);
    } catch (e) {
      print('Error fetching data: $e');
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  void fetchSearchItems() async {
    try {
      print('fetched object...');

      final dbId = DbSelectionController.to.getDbId;
      //    print('${dbId}');
      isLoading = true;
      errorMessage = '';
      update(); // UI-yə xəbər veririk

      final data = await service.fetchSearchItem(dbId);
      searchItems = data;
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  void setSelectedSearchItem(SearchItem item) {
    selectedSearchItem = item;
    print('selectedItem ${selectedSearchItem?.id}');
    update(); // notify UI
  }

  List<SearchItem> get items {
    if (searchQuery.isEmpty) return searchItems;
    return searchItems
        .where(
          (item) =>
              item.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  Future<void> add(BarcodeAddDto dto)  async {

    final dbKey = DbSelectionController.to.getDbId;
    isLoading = true;
    update();
    debugPrint('dto->${dto.toJson()}');
    // await ApiHelper.handleApiCall(() => service.add(dbKey, dto));
    await  service.add(dbKey, dto);
    isLoading = false;
    update();
  }
}
