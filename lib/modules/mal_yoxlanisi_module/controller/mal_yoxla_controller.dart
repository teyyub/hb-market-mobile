import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/service/mal_yoxla_service.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';

class MalYoxlaController extends GetxController {
  final ObyektController obyController = Get.put(ObyektController());
  TextEditingController searchController = TextEditingController();
  List<SearchItem> searchItems = [];
  List<MalYoxla> fetchMalYoxla = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  SearchItem? selectedSearchItem;
  // Obyekt _selectedObyekt = Obyekt.empty;

  late final MalYoxlaService service;

  @override
  void onInit() {
    super.onInit();
    service = MalYoxlaService(client: ApiClient());
    fetchSearchItems();
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
    print("Searching for: $query");
    print("selected: $selectedSearchItem");

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

    update(); // notify GetBuilder to rebuild UI
  }

  Future<void> fetchData({
    int? id,
    String? name,
    String? barcode,
    Map<String, dynamic>? dynamicOz,
  }) async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      final obyektId = obyController.selectedObyekt.id;
      // final id = selectedSearchItem?.id;
      // print('id ${id}');
      fetchMalYoxla = await service.fetchMalYoxla(
        dbId,
        obyektId,
        id,
        name,
        barcode,
        dynamicOz,
      );
      print('getData....${fetchMalYoxla}');
      // for (var mal in malList) {
      //   print('ID: ${mal.id}, Name: ${mal.name}, Price: ${mal.salePrice}');
      // }
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
}
