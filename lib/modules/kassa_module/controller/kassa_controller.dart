import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/kassa_module/data/fake_kassa_list.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/kassa_module/service/kassa_service.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';

class KassaController extends GetxController {
  final dbId = DbSelectionController.to.getDbId;
  List<Kassa> kassa = [];
  Kassa? selectedKassa;
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  int? sortColumnIndex;
  bool sortAscending = true;
  late final KassaService service;

  @override
  void onInit() {
    super.onInit();
    // customers = List.from(fakeKassalar); // load initial data
    service = KassaService(client: ApiClient());
    fetchKassa();
  }

  void setSelectedKassa(Kassa kassa) {
    selectedKassa = kassa;
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

  void fetchKassa() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('1111dbId->${dbId}');
      kassa = await service.fetchKassa(dbId);
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
}
