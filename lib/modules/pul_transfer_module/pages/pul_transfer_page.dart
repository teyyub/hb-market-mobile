import 'package:data_table_2/data_table_2.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table.dart';
import 'package:hbmarket/modules/common/widgets/custom_trina_grid.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/pul_transfer_module/controller/pul_transfer_controller.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/pul_tranfer_model.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/tranfer_request.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/transfer_response.dart';
import 'package:hbmarket/modules/pul_transfer_module/widget/transfer_widget.dart';
import 'package:hbmarket/modules/raport_module/controller/report_controller.dart';
import 'package:trina_grid/trina_grid.dart';

class PulTransferPage extends StatelessWidget {
  final ReportController controller = Get.find<ReportController>();
  final ObyektController obyController = Get.find<ObyektController>();
  final PulTransferController pulTransferController = Get.put(
    PulTransferController(),
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = DeviceUtils.isMobile(context);

    return MainLayout(
      title: 'Pul transferləri',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // _buildTopControls(context),
              // const SizedBox(height: 16),
              Expanded(
                child: GetBuilder<PulTransferController>(
                  builder: (PulTransferController ctrl) {
                    if (ctrl.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildTrinaGrid(ctrl);
                    // return _buildTable2(ctrl);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // full width
                  ),
                  onPressed: () => _openBottomSheet(context),
                  child: const Text('Funksiyalar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.4, // starting height
        minChildSize: 0.3, // min drag height
        maxChildSize: 0.9, // max drag height
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Yeni əməliyyat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // TODO: Handle save logic
                      Get.back(); // closes the bottom sheet
                    },
                    child: const Text('Refresh'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      _openTransferDialog();
                      // Get.back(); // closes the bottom sheet
                    },
                    child: const Text('Yeni transfer'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      debugPrint(
                        'selected...${pulTransferController.selectedId}',
                      );
                      final selected = pulTransferController.transfers
                          .firstWhere(
                            (t) => t.id == pulTransferController.selectedId,
                          );
                      debugPrint('selected...${selected.toJson()}');
                      // Map it to TransferRequest
                      final editData = TransferRequest(
                        id: selected.id,
                        giver: selected.giver?.id,
                        taker: selected.taker?.id,
                        amount: Decimal.parse(selected.amount.toString()),
                        note: selected.note,
                      );
                      _openTransferDialog(editData: editData);

                      // TODO: Handle save logic
                      // Get.back(); // closes the bottom sheet
                    },
                    child: const Text('Düzəliş'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _openTransferDialog({TransferRequest? editData}) async {
    final kassaCtrl = Get.find<KassaController>();
    kassaCtrl.resetSelections();
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    await kassaCtrl.preloadDataForce();
    Get.back();

    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,

        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: TransferWidget(
                initialData: editData,
                onSubmit: (TransferRequest req) {
                  if (editData == null) {
                    debugPrint('1.${req.toJson()}');
                    pulTransferController.saveTransfer(req);
                  } else {
                    pulTransferController.updateTransfer(req);
                  }
                },
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _openDuzelisDialog() {
    final TextEditingController inputController = TextEditingController();

    Get.defaultDialog(
      title: "Düzəliş",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Yeni dəyər daxil edin"),
          const SizedBox(height: 8),
          TextField(
            controller: inputController,
            decoration: const InputDecoration(
              labelText: "Dəyər",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          final value = inputController.text;
          if (value.isEmpty) {
            Get.snackbar("Xəta", "Zəhmət olmasa dəyəri daxil edin");
            return;
          }
          // TODO: handle update logic here
          Get.back();
          Get.snackbar("Uğurla", "Düzəliş yadda saxlanıldı");
        },
        child: const Text("OK"),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Ləğv et"),
      ),
    );
  }

  Widget _buildTable2(PulTransferController ctrl) {
    return CustomDataTable<TransferResponse>(
      data: ctrl.transfers,
      sortColumnIndex: 0,
      sortAscending: true,
      columns: const [
        DataColumn2(
          label: Text('No'),
          // onSort: (colIndex, asc) => ctrl.sort<num>((k) => k.id, colIndex, asc),
        ),
        // DataColumn(
        //   label: Text('Ad'),
        //   // onSort: (colIndex, asc) =>
        //   //     ctrl.sort<String>((k) => k.ad, colIndex, asc),
        // ),
        DataColumn(label: Text('Veren')),
        DataColumn(label: Text('Alan')),
        DataColumn(label: Text('Meb.')),
        DataColumn(label: Text('Qeyd')),
      ],
      rowBuilder: (data) {
        return data.map((k) {
          return DataRow(
            cells: [
              DataCell(Text(k.id.toString())),
              // DataCell(Text(k.veren)),
              // DataCell(Text(k.alan)),
              DataCell(Text(k.amount.toString())),
              DataCell(Text(k.note)),
            ],
          );
        }).toList();
      },
    );
  }

  Widget _buildTrinaGrid(PulTransferController ctrl) {
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
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (String key, bool visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: TrinaGridWidget<TransferResponse>(
            key: ValueKey(ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()),
            data: ctrl.transfers,
            selectedId: ctrl.selectedId,
            // onSelect: ctrl.selectedTransfer,
            onSelect: (TransferResponse item) {
              print('item...${item}');
              ctrl.selectTransfer(item.id); // works even if ID column is hidden
            },
            onColumnVisibilityChanged: (String key, bool visible) {
              ctrl.toggleColumnVisibilityExplicit(key, visible);
            },

            getId: (p) => p.id,
            columns: displayColumns,

            cellBuilder: (p) {
              final Map<String, TrinaCell> cells = {};
              // cells['id'] = TrinaCell(value: p.id.toString());
              for (final c in displayColumns) {
                switch (c['key']) {
                  case 'id':
                    cells['id'] = TrinaCell(value: p.id.toString());
                    break;
                  case 'amount':
                    cells['amount'] = TrinaCell(value: p.amount);
                    break;
                  case 'giver':
                    cells['giver'] = TrinaCell(value: p.giver?.ad);
                    break;

                  case 'taker':
                    cells['taker'] = TrinaCell(value: p.taker?.ad);
                    break;
                  case 'note':
                    cells['note'] = TrinaCell(value: p.note.toString());
                    break;
                  // case 'borc':
                  //   cells['borc'] = TrinaCell(value: p.borc.toString());
                  //   break;
                  // case 'tip':
                  //   cells['tip'] = TrinaCell(value: p.tip);
                  //   break;
                  // case 'aktiv':
                  //   cells['aktiv'] = TrinaCell(value: p.aktiv);
                  //   break;
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
}
