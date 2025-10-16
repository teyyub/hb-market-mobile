import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';

class PartnyorPage extends StatelessWidget {
  final PartnyorController controller = Get.put(PartnyorController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _openFooDialog();
              },
              child: const Text("Select Foo"),
            ),
            Expanded(
              child: GetBuilder<PartnyorController>(
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

  /// Open dialog to select Foo
  void _openFooDialog() {
    final obyController = Get.find<ObyektController>();

    Get.dialog(
      AlertDialog(
        title: const Text("Select Foo"),
        content: SizedBox(
          width: double.maxFinite,
          child: GetBuilder<ObyektController>(
            builder: (ctrl) {
              if (ctrl.obyekts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: ctrl.obyekts.length,
                itemBuilder: (context, index) {
                  final foo = ctrl.obyekts[index];
                  return ListTile(
                    title: Text(foo.name),
                    subtitle: Text(foo.name),
                    onTap: () {
                      // ctrl.select(foo); // save selected Foo
                      Get.back(); // close dialog
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ],
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

  Widget _buildListView(PartnyorController ctrl) {
    return ListView.separated(
      // padding: EdgeInsets.all(16),
      itemCount: ctrl.partnyors.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final customer = ctrl.filteredCustomers[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(customer.ad[0])),
            title: Text(customer.ad),
            subtitle: Text(customer.borc.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => ctrl.removeCustomer(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(PartnyorController ctrl, BuildContext context) {
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
      itemCount: controller.partnyors.length,
      itemBuilder: (context, index) {
        final customer = controller.partnyors[index];
        return InkWell(
          onTap: () {},
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width > 600 ? 40 : 30,
                    child: Text(customer.ad),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      customer.ad,
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
                      customer.ad,
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
