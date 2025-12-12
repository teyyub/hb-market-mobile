import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/column_visibility.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/pul_emeliyyat_module/models/pul_emeliyyati_model.dart';
import 'package:hbmarket/modules/pul_emeliyyat_module/service/pul_emeliyyat_service.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/pul_tranfer_model.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';

class PulEmeliyyatController extends GetxController with ColumnVisibilityMixin {
  List<PulEmeliyyati> pulEmeliyyats = [];
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';
  late final PulEmeliyyatService service;
  @override
  void onInit() {
    super.onInit();
    service = PulEmeliyyatService(client: ApiClient());
    fetchPulEmeliyyat();

    initColumns('pullEmeliyyatiColumns', [
      {'key': 'id', 'label': 'No', 'visible': true},
      {'key': 'mad', 'label': 'Musteri', 'visible': true},
      {'key': 'mebleg', 'label': 'Mebleg', 'visible': true},
      {'key': 'kad', 'label': 'Kassa', 'visible': true},
      // {'key': 'aktiv', 'label': 'Aktiv', 'visible': true},
    ]);
  }

  Future<void> fetchPulEmeliyyat() async {
    try {
      final dbId = DbSelectionController.to.getDbId;
      isLoading = true;
      update();
      errorMessage = '';
      print('dbId.....->${dbId}');
      pulEmeliyyats = await service.fetchPulEmeliyyat(dbId);
      print('pulEmeliyyats ${pulEmeliyyats.length}');
      update();
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isLoading = false;
      update();
    }
  }
  // List<XercQazanc> get filteredCustomers {
  // if (searchQuery.isEmpty) return customers;
  // return customers
  //     .where(
  //       (c) =>
  //           c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
  //           c.email.toLowerCase().contains(searchQuery.toLowerCase()),
  //     )
  //     .toList();
  // }

  // void addCustomer(XercQazanc customer) {
  //   customers.add(customer);
  //   update();
  // }

  // void removeCustomer(int index) {
  //   customers.removeAt(index);
  //   update();
  // }

  // void setSearchQuery(String query) {
  //   searchQuery = query;
  //   update();
  // }
}
