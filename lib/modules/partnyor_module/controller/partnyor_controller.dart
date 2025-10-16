import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/partnyor_module/data/fake_partnyor_list.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/partnyor_service/partnyor_service.dart';

class PartnyorController extends GetxController {
  List<Partnyor> partnyors = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  String selectedRadio = 'A';
  late final PartnyorService service;
  @override
  void onInit() {
    super.onInit();
    service = PartnyorService(client: ApiClient());
    // load initial data
    fetchPartnors();
  }

  void setSelectedRadio(String value) {
    selectedRadio = value;
    update(); // rebuild GetBuilder
  }

  void fetchPartnors() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('dbId.....->${dbId}');
      partnyors = await service.fetchPartnyors(dbId);
      print('partnyor ${partnyors.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
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
}
