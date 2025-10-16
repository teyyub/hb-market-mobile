import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/custom_table.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_model.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/pages/barcode_scanner_page.dart';
import 'package:hbmarket/modules/partnyor_module/widgets/add_partnyor.dart';
import 'package:hbmarket/modules/partnyor_module/widgets/yeni_xerc.dart';

class PartnyorPage extends StatelessWidget {
  final PartnyorController controller = Get.put(PartnyorController());
  int? selectedMustId;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Partnyorlar'.tr), // You can replace with your title
    //     centerTitle: true,
    //   ),
    return MainLayout(
      title: 'Partnyorlar'.tr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchField(),
              const SizedBox(height: 16),
              Expanded(
                child: GetBuilder<PartnyorController>(
                  builder: (ctrl) {
                    return _buildTable2(ctrl);
                    // return kIsWeb
                    //     ? _buildListView(ctrl)
                    //     : _buildGridView(ctrl, context);
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Add buttons here
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align to right
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Yeni pul emeliyyat'.tr),
                          content: AddPartnyorDialog(
                            mustId: selectedMustId!,
                            onSave: (mustId, amount, tip, kassaId) {
                              controller.addOrUpdatePartnyor(
                                mustId: mustId,
                                amount: amount,
                                tip: tip,
                                kassaId: kassaId,
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('Əlavə et'.tr),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      print('addClicked...');
                      Get.dialog(
                        Dialog(
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text('Yeni xərclər'.tr),
                              leading: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Get.back(),
                              ),
                            ),
                            body: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: YeniXercDialog(
                                mustId: selectedMustId!,
                                onSave: (mustId, amount, tip, kassaId) {
                                  controller.addOrUpdatePartnyor(
                                    mustId: mustId,
                                    amount: amount,
                                    tip: tip,
                                    kassaId: kassaId,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Yeni xerc'.tr),
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.red,
                    // ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add action for Refresh button
                    },
                    child: Text('Yenilə'.tr),
                  ),
                ],
              ),
            ],
          ),
          // child: GetBuilder<CustomerController>(
          //   builder: (ctrl) {
          //     return kIsWeb ? _buildListView(ctrl) : _buildGridView(ctrl);
          //   },
          // ),
        ),
      ),
    );
  }

  Widget _buildTable2(PartnyorController ctrl) {
    double screenWidth = Get.width;
    return CustomDataTable<Partnyor>(
      data: ctrl.partnyors,
      sortColumnIndex: 0,
      sortAscending: true,
      columns: [
        DataColumn2(
          label: Text('No'),
          // onSort: (colIndex, asc) => ctrl.sort<num>((k) => k.id, colIndex, asc),
        ),
        // DataColumn(
        //   label: Text('Ad'),
        //   // onSort: (colIndex, asc) =>
        //   //     ctrl.sort<String>((k) => k.ad, colIndex, asc),
        // ),
        DataColumn2(label: Text('Ad'), size: ColumnSize.L),
        DataColumn2(label: Text('Borc')),
        DataColumn2(label: Text('Tip')),
        DataColumn2(label: Text('Aktiv')),
      ],
      rowBuilder: (data) {
        return data.map((k) {
          // final isSelected = selectedMustId == k.id;
          return DataRow(
            onSelectChanged: (_) {
              selectedMustId = k.id; // save selected row id
              ctrl.update(); // refresh UI if needed
              print('Selected row ID: ${k.id}');
            },

            // selected: isSelected,
            // onSelectChanged: (selected) {
            //   if (selected ?? false) {
            //     selectedMustId = k.id;
            //   } else {
            //     selectedMustId = null;
            //   }
            //   ctrl.update(); // refresh UI
            // },
            cells: [
              DataCell(Text(k.id.toString())),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth < 600
                        ? screenWidth *
                              0.4 // phones
                        : screenWidth * 0.2, // tablets & web
                  ),
                  child: Text(
                    k.ad,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              DataCell(Text(k.borc.toString())),
              DataCell(Text(k.tip)),
              DataCell(Text(k.aktiv)),
            ],
          );
        }).toList();
      },
    );
  }

  Widget _buildSearchField() {
    // return TextField(
    //   decoration: InputDecoration(
    //     labelText: 'Search customers',
    //     prefixIcon: Icon(Icons.search),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    //   ),
    //   onChanged: (value) {
    //     controller.setSearchQuery(value); // Filter logic in controller
    //   },
    // );
    final TextEditingController searchController = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search or Scan Barcode',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              controller.setSearchQuery(value);
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.qr_code_scanner, size: 28),
          tooltip: 'Scan Barcode',
          onPressed: () async {
            final code = await Get.to(() => const BarcodeScannerPage());
            if (code != null) {
              searchController.text = code;
              controller.setSearchQuery(code);
            }
          },
        ),
      ],
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
        final partnyor = controller.partnyors[index];
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
                    child: Text(partnyor.ad),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      partnyor.ad,
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
                      partnyor.borc.toString(),
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
                  Flexible(
                    child: Text(
                      partnyor.tip,
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
                  Flexible(
                    child: Text(
                      partnyor.aktiv,
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
