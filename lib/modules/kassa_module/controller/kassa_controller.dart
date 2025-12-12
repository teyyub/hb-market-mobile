import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/kassa_module/service/kassa_service.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/category_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/qeyd_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';

class KassaController extends GetxController with ColumnVisibilityMixin {
  final dbId = DbSelectionController.to.getDbId;
  PartnyorController partnyorController = Get.find<PartnyorController>();
  List<Kassa> kassa = [];
  List<Kassa> kassaVeren = [];
  List<Kassa> kassaAlan = [];
  List<Category> categories = [];
  List<Category> subCategories = [];
  List<Qeyd> qeyds = [];
  List<Qeyd> sebebs = [];
  Kassa? selectedKassa;
  Kassa? selectedVeren; // the giver
  Kassa? selectedAlan; // the taker
  Qeyd? selectedQeyd;
  Qeyd? selectedSebeb;
  String? typedSebeb;
  String? typedQeyd;
  Category? selectedCategory;
  Category? selectedSubCategory;
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  int? sortColumnIndex;
  bool sortAscending = true;
  late final KassaService service;
  int? selectedId;
  String? nameFilter;

  bool get isFiltered => nameFilter != null && nameFilter!.isNotEmpty;

  void setSelectedVeren(Kassa kassa) {
    selectedVeren = kassa;
    update(); // rebuild UI
  }

  void setSelectedAlan(Kassa kassa) {
    selectedAlan = kassa;
    update();
  }

  void setSelectedKassa(Kassa kassa) {
    selectedKassa = kassa;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    service = KassaService(client: ApiClient());

    initColumns('kassaColumns', [
      {'key': 'id', 'label': 'S.No', 'visible': true},
      {'key': 'name', 'label': 'Ad', 'visible': true},
      {'key': 'money', 'label': 'Pul', 'visible': true},
      {'key': 'active', 'label': 'Aktiv', 'visible': true},
    ]);
    preloadData();
    // fetchKassa();
  }

  Future<void> preloadData() async {
    final futures = <Future>[];
    debugPrint('kassa.isEmpty ${kassa.isEmpty}');
    if (kassa.isEmpty) futures.add(fetchKassa());
    if (categories.isEmpty) futures.add(fetchCategory());
    if (qeyds.isEmpty) futures.add(fetchQeyd());
    if (sebebs.isEmpty) futures.add(fetchSebeb());

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> preloadDataForce() async {
    final futures = <Future>[];
    futures.add(fetchKassa());

    futures.add(fetchKassaFiltered());

    futures.add(fetchCategory());
    futures.add(fetchQeyd());
    futures.add(fetchSebeb());

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  void setSelectedQeyd(Qeyd q) {
    selectedQeyd = q;
    update();
  }

  void setSelectedSebeb(Qeyd q) {
    selectedSebeb = q;
    debugPrint('setSelectedSebeb....${selectedSebeb}');
    update();
  }

  void setTypedSebeb(String q) {
    typedSebeb = q;
    selectedSebeb = null;
    update();
  }

  void setTypedQeyd(String q) {
    typedQeyd = q;
    selectedQeyd = null;
    update();
  }

  Future<void> setSelectedCategory(Category cat) async {
    selectedCategory = cat;
    subCategories.clear();
    update();
    await fetchSubCategory(cat.id);
  }

  void setSelectedSubCategory(Category cat) {
    selectedSubCategory = cat;
    update();
  }

  void sort<T>(
    Comparable<T> Function(Kassa k) getField,
    int columnIndex,
    bool ascending,
  ) {
    kassa.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    update();
  }

  Future<void> fetchKassa({String? nameFilter}) async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('1111dbId->${dbId}');
      kassa = await service.fetchKassa(dbId,nameFilter: nameFilter);
      print('kassa length ${kassa.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }


  void applyFilter(String? newNameFilter) {
    nameFilter = newNameFilter;
    fetchKassa(nameFilter: newNameFilter);
  }

  void resetFilter() {
    nameFilter = null;
    fetchKassa();
  }
  void setFilter(String value) {
    nameFilter = value;
    update(); // UI yenilənir
  }

  Future<void> fetchKassaFiltered() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('1111dbId->${dbId}');
      // kassa = await service.fetchKassaFiltered(dbId);
      kassaVeren = await service.fetchKassaFiltered(dbId, filter: 'emelPlus');

      // Fetch Alan (taker)
      kassaAlan = await service.fetchKassaFiltered(dbId, filter: 'transPlus');

      print('kassa length ${kassa.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchCategory() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('1111dbId->${dbId}');
      categories = await service.fetchCategory(dbId, null);
      print('categories length ${categories.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchSubCategory(int parentId) async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('1111dbId->${dbId}');
      subCategories = await service.fetchCategory(dbId, parentId);
      print('subCategories length ${subCategories.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchQeyd() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      // print('1111dbId->${dbId}');
      qeyds = await service.fetchQeyd(dbId);
      print('qeyds length ${qeyds.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchSebeb() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      sebebs = await service.fetchSebeb(dbId);
      print('sebeb length ${qeyds.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }

  /// 🔹 New method to call the procedure
  Future<void> runProcedure() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();

      await service.executeProcedure(dbId);

      Get.snackbar(
        'Success',
        'Procedure executed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  // List<Kassa> get filteredCustomers {
  //   if (searchQuery.isEmpty) return customers;
  //   return customers
  //       .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
  //       .toList();
  // }

  // void addCustomer(Kassa customer) {
  //   customers.add(customer);
  //   update();
  // }

  // void removeCustomer(Kassa k) {
  //   customers.remove(k);
  //   update();
  // }

  void setSearchQuery(String query) {
    searchQuery = query;
    update();
  }

  Future<void> initSelectedFromDto(XercRequestDto dto) async {
    print('initSelection....${kassa}');
    selectedKassa = kassa.firstWhereOrNull((k) => k.id == dto.kassaId);
    selectedCategory = categories.firstWhereOrNull(
      (c) => c.id == dto.categoryId,
    );

    if (selectedCategory != null) {
      await setSelectedCategory(selectedCategory!);
    }
    selectedSubCategory = subCategories.firstWhereOrNull(
      (c) => c.id == dto.subCategoryId,
    );

    // debugPrint('kassaController.sebebs....${sebebs}');
    // debugPrint('kassaController.sebebs....${sebebs}');
    debugPrint('dto.sebebs....${dto.sebeb}');
    if (dto.sebeb != null && dto.sebeb!.isNotEmpty) {
      final found = sebebs.firstWhereOrNull((s) => s.ad == dto.sebeb);
      debugPrint('found....${found}');
      if (found != null) {
        // kassaController.selectedSebeb = found;
        selectedSebeb = found;
      } else {
        final newSebeb = Qeyd(id: 0, ad: dto.sebeb!);
        // kassaController.selectedSebeb = newSebeb;
        sebebs.add(newSebeb); // 👈 important!
        selectedSebeb = newSebeb;
      }
    } else {
      debugPrint('else....');
      selectedSebeb = null;
    }
    debugPrint('kassaController.selectedSebeb...${selectedSebeb}');
    debugPrint('kassaController.Sebeb...${sebebs}');

    // selectedQeyd = qeyds.firstWhereOrNull((q) => q.ad == dto.qeyd);

    if (dto.qeyd != null && dto.qeyd!.isNotEmpty) {
      final foundQeyd = qeyds.firstWhereOrNull((s) => s.ad == dto.qeyd);
      debugPrint('found....${foundQeyd}');
      if (foundQeyd != null) {
        // kassaController.selectedSebeb = found;
        selectedQeyd = foundQeyd;
      } else {
        final newQeyd = Qeyd(id: 0, ad: dto.qeyd!);
        // kassaController.selectedSebeb = newSebeb;
        qeyds.add(newQeyd); // 👈 important!
        selectedQeyd = newQeyd;
      }
    } else {
      debugPrint('else....');
      selectedSebeb = null;
    }

    partnyorController.setSelectedRadio(dto.sign!);

    update();
  }

  void resetSelections() {
    selectedKassa = null;
    selectedCategory = null;
    selectedSubCategory = null;
    selectedSebeb = null;
    selectedQeyd = null;
    typedSebeb = null;
    typedQeyd = null;
    selectedVeren = null; // reset giver
    selectedAlan = null;
    update(); // make UI rebuild
  }
}
