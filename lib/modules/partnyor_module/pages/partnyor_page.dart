import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table.dart';
import 'package:hbmarket/modules/common/widgets/custom_table2.dart';
import 'package:hbmarket/modules/common/widgets/custom_trina_grid.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_model.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/partnyor_module/pages/barcode_scanner_page.dart';
import 'package:hbmarket/modules/partnyor_module/widgets/add_partnyor.dart';
import 'package:hbmarket/modules/partnyor_module/widgets/filter_partnyor.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/widget/yeni_xerc.dart';
import 'package:trina_grid/trina_grid.dart';

import '../models/PartnyorFilter.dart';

class PartnyorPage extends StatelessWidget {
  // final PartnyorController controller = Get.put(PartnyorController());
  final PartnyorController controller = Get.find<PartnyorController>();
  // int? selectedMustId;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Partnyorlar'.tr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          // _buildSearchField(),
          // const SizedBox(height: 16),
          child: GetBuilder<PartnyorController>(
            builder: (PartnyorController ctrl) {
              if (ctrl.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            height:
                                constraints.maxHeight, // ensures bounded height
                            child: _buildTrinaGrid(ctrl),
                          );
                        },
                      ),
                      // margin: const EdgeInsets.only(bottom: 16),
                      // child: Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   // child: _buildTable2(ctrl),
                      //   child: _buildTrinaGrid(ctrl),
                      // ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _openDialog();
                    },
                    child: const Text('Funksiyalar'),
                  ),
                ],
              );
              // return _buildTable2(ctrl);
              // return kIsWeb
              //     ? _buildListView(ctrl)
              //     : _buildGridView(ctrl, context);
            },
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

  void _openDialog() {
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7, // start at 70% of screen
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),

            child: ListView(
              // shrinkWrap: true,
              controller: scrollController,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (controller.selectedMustId == null) return;
                    controller.setDialogItems();
                    Get.dialog(
                      AlertDialog(
                        title: Text('Yeni pul emeliyyat'.tr),
                        content: AddPartnyorDialog(
                          mustId: controller.selectedMustId!,
                          onSave: (int mustId, double amount, String tip, int kassaId) {
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
                  child: Text("buttonOperation".tr),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (controller.selectedMustId == null) return;
                    print('addClicked...');
                    // _openDialog();
                    _openBottomSheet();
                  },
                  child: Text("buttonNewDepth".toString().tr),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (controller.selectedMustId == null) return;
                    print('addClicked...');
                    // _openDialog();
                    // _openBottomSheet();
                  },
                  child: Text("buttonRecalculateDepth".tr),
                ),
              ],
            ),
          );
        },
      ),
      // isScrollControlled: true,
      // backgroundColor: Colors.transparent, // optional
    );
  }

  void _openBottomSheet() async {
    final kassaCtrl = Get.find<KassaController>();
    kassaCtrl.resetSelections();
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    await kassaCtrl.preloadData();
    Get.back();
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7, // start at 70% of screen
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController, // attach scrollController!
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Yeni xərclər'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  YeniXercDialog(
                    mustId: controller.selectedMustId!,
                    initial: XercRequestDto(
                      mustId: controller.selectedMustId ?? 0,
                      kassaId: 0,
                      amount: null,
                      pays: null,
                      sign: '',
                      categoryId: null,
                      subCategoryId: null,
                      sebeb: '',
                      qeyd: '',
                    ),
                    onSave: (XercRequestDto dto) async {
                      await controller.saveYeniXerc(dto);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // optional
    );
  }

  Widget _buildTable2(PartnyorController ctrl) {
    ctrl.selectFirstIfNull();
    final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();
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
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (key, visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Expanded(
          child: CustomDataTable2<Partnyor>(
            key: ValueKey(ctrl.columns.map((c) => c['visible']).join()),
            data: ctrl.partnyors,
            selectedId: ctrl.selectedMustId,
            onSelect: ctrl.selectPartnyor,
            getId: (p) => p.id,
            columns: displayColumns
                .map((c) => DataColumn(label: Text(c['label'])))
                .toList(),
            cellBuilder: (p) => displayColumns.map((c) {
              switch (c['key']) {
                case 'id':
                  return DataCell(Text(p.id.toString()));
                case 'ad':
                  return DataCell(Text(p.ad));
                case 'borc':
                  return DataCell(Text(p.borc.toString()));
                case 'tip':
                  return DataCell(Text(p.tip));
                case 'aktiv':
                  return DataCell(Text(p.aktiv));
                case 'placeholder':
                  return DataCell(Text('Bosdur'));
                default:
                  return DataCell(Text(''));
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
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
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final customer = ctrl.filteredCustomers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildTrinaGrid(PartnyorController ctrl) {
    final Map<String, double> savedColumnWidths = {};
    final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();
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
            // const SizedBox(width: 8),
            // ElevatedButton(
            //   onPressed: () {
            //     // burada savedColumnWidths-i controller-ə göndərə bilərik
            //     // ctrl.saveColumnWidths(savedColumnWidths);
            //     Get.snackbar('Uğur', 'Column widths saved');
            //   },
            //   child: const Text('Config'),
            // ),
            // 1. 🔍 Filter Düyməsi
            IconButton(
              icon: const Icon(Icons.filter_list), // Filter ikonu
              tooltip: 'Filterlər'.tr, // Tooltip əlavə edirik
              onPressed: () async {
                // Filter dialoqunu açan funksiyanı çağırın
                // _openPartnyorFilterDialog(ctrl);
                await ctrl.fetchPartnorTypes();
                Get.dialog(
                  AlertDialog(
                    title: Text('Filter'.tr),
                    content: FilterPartnyor(
                      onSave: ( String? name, double? minAmount, double? maxAmount, int? tip, String? aktiv) {
                        final filter = PartnyorFilter(
                          name: name,
                          minAmount: minAmount,
                          maxAmount: maxAmount,
                          tip: tip,
                          aktiv: aktiv,
                        );
                        controller.filterPartnyor(filter: filter);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8), // İkonlar arasında bir az boşluq
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (key, visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),



        const SizedBox(height: 12),
        Expanded(
          child: CustomTrinaGrid<Partnyor>(
            key: ValueKey(ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()),
            data: ctrl.partnyors,
            selectedId: ctrl.selectedMustId,
            // onSelect: ctrl.selectPartnyor,
            onSelect: (Partnyor item) {
              ctrl.selectPartnyor(item.id); // works even if ID column is hidden
            },

            getId: (p) => p.id,
            columns: displayColumns
                .map(
                  (c) => TrinaColumn(
                    title: c['label'],
                    field: c['key'],
                    type: TrinaColumnType.text(),
                    width: savedColumnWidths[c['key']] ?? 150, // default width
                    enableContextMenu: false,
                    enableDropToResize: true,

                    // filterWidgetDelegate: null,
                  ),
                )
                .toList(),
            cellBuilder: (p) {
              final Map<String, TrinaCell> cells = {};
              cells['id'] = TrinaCell(value: p.id.toString());
              for (final c in displayColumns) {
                switch (c['key']) {
                  case 'id':
                    cells['id'] = TrinaCell(value: p.id.toString());
                    break;
                  case 'ad':
                    cells['ad'] = TrinaCell(value: p.ad);
                    break;
                  case 'borc':
                    cells['borc'] = TrinaCell(value: p.borc.toString());
                    break;
                  case 'tip':
                    cells['tip'] = TrinaCell(value: p.tip);
                    break;
                  case 'aktiv':
                    cells['aktiv'] = TrinaCell(value: p.aktiv);
                    break;
                  // case 'placeholder':
                  // return DataCell(Text('Bosdur'));
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



  Widget _buildSearchField1(PartnyorController ctrl) {
    return TextField(
      // controller: ctrl.searchController,
      decoration: InputDecoration(
        labelText: 'Ad / ID-ə görə axtarış'.tr,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (value) {
        ctrl.setSearchQuery(value);
        // Kontrollerdə məlumatı filterləyən metodu çağırın.
        // ctrl.filterPartnyors();
      },
    );
  }
}
