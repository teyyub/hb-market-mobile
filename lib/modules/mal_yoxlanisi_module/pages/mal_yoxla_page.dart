import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/widget/obyekt_widget.dart';
import 'package:hbmarket/modules/object_module/widget/select_object_button.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';

class MalYoxlaPage extends StatelessWidget {
  final ObyektController obyController = Get.put(ObyektController());
  final MalYoxlaController malYoxlaController = Get.put(MalYoxlaController());
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Report'.tr), // You can replace with your title
    //     centerTitle: true,
    //     actions: [
    //       IconButton(
    //         icon: Icon(Icons.refresh),
    //         onPressed: () {
    //           // Optional: trigger refresh
    //         },
    //       ),
    //     ],
    //   ),
    return MainLayout(
      title: 'Mal yoxlanisi',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopControls(context),
              const SizedBox(height: 16),
              // GetBuilder<MalYoxlaController>(
              //   builder: (ctrl) {
              //     return DropdownSelector<SearchItem>(
              //       label: 'Select Report',
              //       selectedValue: malYoxlaController.selectedSearchItem,
              //       items: malYoxlaController.searchItems,
              //       itemLabel: (r) => r.title,
              //       onChanged: (r) =>
              //           malYoxlaController.setSelectedSearchItem(r),
              //     );
              //   },
              // ),
              const SizedBox(height: 16),
              _buildTable(),
            ],
            // const SizedBox(height: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    final isMobile = DeviceUtils.isMobile(context);
    return GetBuilder<MalYoxlaController>(
      builder: (ctrl) {
        if (ctrl.errorMessage.isNotEmpty) {
          Future.microtask(() {
            Get.snackbar(
              'Xəbərdarlıq',
              ctrl.errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.shade100,
              colorText: Colors.black,
            );
            ctrl.errorMessage = '';
          });
        }
        return Card(
          color: Colors.blue[50],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SelectObjectButton(obyCtrl: Get.find<ObyektController>()),
                      const SizedBox(height: 12),
                      GetBuilder<MalYoxlaController>(
                        builder: (ctrl) {
                          return DropdownSelector<SearchItem>(
                            label: 'selectReport'.tr,
                            selectedValue:
                                malYoxlaController.selectedSearchItem,
                            items: malYoxlaController.searchItems,
                            itemLabel: (r) => r.title,
                            onChanged: (r) =>
                                malYoxlaController.setSelectedSearchItem(r),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      buildNumberField(
                        label: 'Axtar',
                        isNumberOnly: ctrl.selectedSearchItem?.id == 0,
                        onChanged: (value) {
                          // ctrl.number.value = value;
                        },
                        // initialValue: ctrl.number.value,
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: isMobile ? double.infinity : 160,
                            // child: ElevatedButton.icon(
                            //   style: ElevatedButton.styleFrom(
                            //     padding: const EdgeInsets.symmetric(
                            //       vertical: 14,
                            //     ),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            //   icon: const Icon(Icons.download),
                            //   label: FittedBox(
                            //     fit: BoxFit.scaleDown,
                            //     child: Text('btnFetchReport'.tr),
                            //   ),
                            //   onPressed: () {
                            //     // ctrl.fetchReportPrint();
                            //   },
                            // ),
                          ),
                          // const SizedBox(width: 12),
                          SizedBox(
                            width: isMobile ? double.infinity : 160,
                            // child: ElevatedButton.icon(
                            //   style: ElevatedButton.styleFrom(
                            //     padding: const EdgeInsets.symmetric(
                            //       vertical: 14,
                            //     ),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            //   icon: const Icon(Icons.print),
                            //   label: FittedBox(
                            //     fit: BoxFit.scaleDown,
                            //     child: Text(
                            //       "btnPrint".tr,
                            //       overflow: TextOverflow.ellipsis,
                            //     ),
                            //   ),

                            //   onPressed: () => printReports(controller),
                            // ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  // obyController.openObyektDialog(context),
                                  ObyektWidget.show(context, obyController),
                              child: const Text("Select Obyekt"),
                            ),
                            const SizedBox(height: 12),
                            // _buildTimeSelectors(context),
                            // const SizedBox(height: 12),
                            // _buildReportIdSelector(),
                            // const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          // ElevatedButton.icon(
                          //   icon: const Icon(Icons.download),
                          //   label: Text("btnFetchReport".tr),
                          //   onPressed: () {
                          //     // ctrl.fetchReportPrint();
                          //   },
                          // ),
                          // const SizedBox(height: 12),
                          // ElevatedButton.icon(
                          //   icon: const Icon(Icons.print),
                          //   label: Text("btnPrint".tr),
                          //   onPressed: () => printReports(controller),
                          // ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget buildNumberField({
    required String label,
    required Function(String) onChanged,
    int? initialValue,
    bool enabled = true,
    bool isNumberOnly = false,
  }) {
    // final controller = TextEditingController(
    //   text: initialValue != null ? initialValue.toString() : '',
    // );
    final controller = malYoxlaController.searchController;
    return GetBuilder<MalYoxlaController>(
      builder: (ctrl) {
        final isNumber = ctrl.selectedSearchItem?.id == 0;

        return TextField(
          key: ValueKey(isNumber),
          controller: controller,
          enabled: enabled,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                malYoxlaController.search(controller.text);
              },
            ),
          ),
          onChanged: (value) {
            if (isNumberOnly) {
              int number = int.tryParse(value) ?? 0;
              onChanged(number.toString());
            } else {
              onChanged(value);
            }
          },
        );
      },
    );
  }

  Widget _buildTable() {
    return Expanded(
      child: GetBuilder<MalYoxlaController>(
        builder: (ctrl) {
          final data = ctrl
              .fetchMalYoxla; // Suppose `items` is a list in your controller
          if (data.isEmpty) {
            return Center(child: Text('No data'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sn')),
                  DataColumn(label: Text('Ad')),
                  DataColumn(label: Text('Say')),
                  DataColumn(label: Text('S.qiy')),
                ],
                rows: data
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item.id.toString())),
                          DataCell(
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                item.name,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          DataCell(Text(item.stockQuantity.toString())),
                          DataCell(Text(item.salePrice.toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
