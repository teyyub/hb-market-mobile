import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/config/customer_list.dart';
import 'package:hbmarket/modules/customer_module/controller/customer_controller.dart';
import 'package:hbmarket/modules/customer_module/pages/customer_detail_page.dart';

class CustomerPage extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<CustomerController>(
                builder: (ctrl) {
                  return kIsWeb
                      ? _buildListView(ctrl)
                      : _buildGridView(ctrl, context);
                },
              ),
            ),
          ],
        ),
        // child: GetBuilder<CustomerController>(
        //   builder: (ctrl) {
        //     return kIsWeb ? _buildListView(ctrl) : _buildGridView(ctrl);
        //   },
        // ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search customers',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (value) {
        controller.setSearchQuery(value); // Filter logic in controller
      },
    );
  }

  Widget _buildListView(CustomerController ctrl) {
    return ListView.separated(
      // padding: EdgeInsets.all(16),
      itemCount: ctrl.customers.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final customer = ctrl.filteredCustomers[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(customer.name[0])),
            title: Text(customer.name),
            subtitle: Text(customer.email),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => ctrl.removeCustomer(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(CustomerController ctrl, BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    double childAspectRatio = MediaQuery.of(context).size.width > 600 ? 2 : 1.3;
    return GridView.builder(
      // padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: controller.customers.length,
      itemBuilder: (context, index) {
        final customer = controller.customers[index];
        return InkWell(
          onTap: () {
            // Navigate to detail page
            Get.to(() => CustomerDetailPage(customer: customer));
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width > 600 ? 40 : 30,
                    child: Text(customer.name),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 18
                            : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      customer.email,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width > 600
                            ? 16
                            : 12,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ); // return Card(
        //   child: Center(
        //     child: ListTile(
        //       leading: CircleAvatar(child: Text(customer.name[0])),
        //       title: Text(customer.name),
        //       subtitle: Text(customer.email),
        //     ),
        //   ),
        // );
      },
    );
  }
}
