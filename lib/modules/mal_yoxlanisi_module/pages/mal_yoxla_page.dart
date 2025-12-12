import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table2.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/widgets/add_barcode.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/widget/obyekt_widget.dart';
import 'package:hbmarket/modules/object_module/widget/select_object_button.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/pages/barcode_scanner_page.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../hereket_module/models/hereket_request.dart';
import '../../hereket_module/widget/work_widget_bkp1.dart';

class MalYoxlaPage extends StatelessWidget {
  final ObyektController obyController = Get.find<ObyektController>();
  final MalYoxlaController malYoxlaController = Get.find<MalYoxlaController>();
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Mal yoxlanışı',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopControls(context),
              const SizedBox(height: 16),

              Flexible(
                child: GetBuilder<MalYoxlaController>(
                  builder: (MalYoxlaController ctrl) {
                    if (ctrl.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // return _buildTable();
                    return _buildTrinaGrid(ctrl,context);
                  },
                ),
              ),

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
      builder: (MalYoxlaController ctrl) {
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
                        builder: (MalYoxlaController ctrl) {
                          return DropdownSelector<SearchItem>(
                            label: ''.tr,
                            selectedValue:
                                malYoxlaController.selectedSearchItem,
                            items: malYoxlaController.searchItems,
                            itemLabel: (r) => r.title,
                            onChanged: (r) {
                              malYoxlaController.setSelectedSearchItem(r);
                              malYoxlaController.searchFocus.requestFocus();
                              malYoxlaController.searchController.clear();
                            }
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      buildNumberField(
                        label: 'Axtar',
                        isNumberOnly: ctrl.selectedSearchItem?.id == 0,
                        focusNode: malYoxlaController.searchFocus,

                        onChanged: (String value) {

                        },
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
                      const Column(
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
    FocusNode? focusNode,
  }) {

    final controller = malYoxlaController.searchController;
    return GetBuilder<MalYoxlaController>(
      builder: (MalYoxlaController ctrl) {
        final isNumber = ctrl.selectedSearchItem?.id == 0;
        final isBarcode = ctrl.selectedSearchItem?.id == 2;
        return TextField(
          key: ValueKey(isNumber),
          controller: controller,
          focusNode: malYoxlaController.searchFocus,
          enabled: enabled,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isBarcode)
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    tooltip: 'Barkodu oxu',
                    onPressed: () async {
                      final result = await Get.to(
                        () => const BarcodeScannerPage(),
                      );
                      if (result != null && result is String) {
                        // final result1 = '2513183501007';
                        malYoxlaController.searchController.text = result;
                        malYoxlaController.search(result);
                      }
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    malYoxlaController.search(controller.text);
                  },
                ),
              ],
            ),
          ),
          onSubmitted: (value) {
            malYoxlaController.search(value);
          },
          onChanged: (String value) {
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

  // Future<void> scanBarcode() async {
  //   try {
  //     final barcode = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666', // scanner line color
  //       'İmtina et', // cancel text
  //       true, // show flash icon
  //       ScanMode.BARCODE,
  //     );

  //     if (barcode != '-1') {
  //       malYoxlaController.searchController.text = barcode;
  //       malYoxlaController.search(barcode);
  //     }
  //   } on PlatformException {
  //     Get.snackbar('Xəta', 'Barkod oxunmadı');
  //   }
  // }



  Widget _buildTrinaGrid(MalYoxlaController ctrl , BuildContext context) {
    // Map<String, double> savedColumnWidths = {};

    final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();

    debugPrint('${visibleColumns}');
    final displayColumns = visibleColumns.isNotEmpty
        ? visibleColumns
        : [
            {'key': 'placeholder', 'label': 'Bosdur', 'visible': true},
          ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                debugPrint('malYoxla...${ctrl.selectedMalYoxla}');
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: SingleChildScrollView(
                      child: AddBarcodeWidget(
                        id: ctrl.selectedMalYoxla!.id,
                        barcode: ctrl.selectedMalYoxla!.barcode,
                        name: ctrl.selectedMalYoxla!.name,
                        malYoxla: ctrl.selectedMalYoxla!,
                        onSave: (HereketRequest dto) async {
                          Get.back(); // Close the bottom sheet
                        },
                      ),
                    ),
                  ),
                  isScrollControlled: true, // allows sheet to be taller than default
                  backgroundColor: Colors.transparent, // optional
                );
              },
              child:const Text('Barkod siyahısına əlavə'),
            ),
            const Spacer(),
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (String key, bool visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Expanded(
          child: TrinaGridWidget<MalYoxla>(
            key: ValueKey(ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()),
            data: ctrl.fetchMalYoxla,
            selectedId: ctrl.selectedId,
            // onSelect: ctrl.selectPartnyor,
            onSelect: (MalYoxla item) {
              ctrl.setSelectedMalYoxla(
                item,
              ); // works even if ID column is hidden
            },

            getId: (p) => p.id,
            columns: displayColumns,
            cellBuilder: (p) {
              final Map<String, TrinaCell> cells = {};
              for (final Map<String, dynamic> c in displayColumns) {
                switch (c['key']) {
                  case 'id':
                    cells['id'] = TrinaCell(value: p.id.toString());
                    break;
                  case 'ad':
                    cells['ad'] = TrinaCell(value: p.name);
                    break;
                  case 'say':
                    cells['say'] = TrinaCell(value: p.stockQuantity);
                    break;
                  case 'satis':
                    cells['satis'] = TrinaCell(value: p.salePrice);
                    break;
                  case 'alis':
                    cells['alis'] = TrinaCell(value: p.alis);
                    break;
                  case 'seri':
                    cells['seri'] = TrinaCell(value: p.barcode);
                    break;
                  case 'sat2':
                    cells['sat2'] = TrinaCell(value: p.sat2);
                    break;
                  case 'sat3':
                    cells['sat3'] = TrinaCell(value: p.sat3);
                    break;
                  case 'sat4':
                    cells['sat4'] = TrinaCell(value: p.sat4);
                    break;
                  case 'sat5':
                    cells['sat5'] = TrinaCell(value: p.sat5);
                    break;
                  case 'sat6':
                    cells['sat6'] = TrinaCell(value: p.sat6);
                    break;
                  default:
                    cells[c['key']] = TrinaCell(value: '');
                }
              }

              return cells;
            },
          ),
        ),
      ],
    );
  }
}
