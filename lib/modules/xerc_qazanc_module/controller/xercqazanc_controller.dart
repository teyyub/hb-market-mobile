import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/modules/customer_module/models/customer_model.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';

class XercQazancController extends GetxController {
  List<XercQazanc> customers = [];
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    // customers = List.from(fakeCustomers); // load initial data
  }

  List<XercQazanc> get filteredCustomers {
    if (searchQuery.isEmpty) return customers;
    return customers
        .where(
          (c) =>
              c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              c.email.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void addCustomer(XercQazanc customer) {
    customers.add(customer);
    update();
  }

  void removeCustomer(int index) {
    customers.removeAt(index);
    update();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    update();
  }
}
