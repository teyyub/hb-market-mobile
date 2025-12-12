import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table2.dart';
import 'package:hbmarket/modules/common/widgets/custom_trina_grid.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';

import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/widget/yeni_xerc.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/controller/xercqazanc_controller.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/models/xerc_qazanc_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trina_grid/trina_grid.dart';

class XercQazancPage extends StatelessWidget {
  // final XercQazancController controller = Get.put(
  //   XercQazancController(),
  //   permanent: true,
  // );

  final XercQazancController controller = Get.find<XercQazancController>();

  final PartnyorController partnyorController = Get.find<PartnyorController>();

  final KassaController kassaController = Get.find<KassaController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Xərc qazanc'.tr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<XercQazancController>(
            builder: (XercQazancController ctrl) {
              if (ctrl.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // _buildSearchField(),
                  // const SizedBox(height: 16),
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
                            // return _buildTable2(ctrl);
                            child: _buildTrinaGrid(ctrl),
                            // return kIsWeb
                            //     ? _buildListView(ctrl)
                            //     : _buildGridView(ctrl, context);
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align to right
                    children: [
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // print('${controller.selectedMustId}');
                          // print('selected....${controller.selectedItem}');
                          if (controller.selectedItem == null) return;
                          print('addClicked...');
                          // _openDialog();
                          _openBottomSheet();
                        },
                        child: Text('Duzelis'.tr),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          print('addClicked... ${controller.selectedItem}');
                          if (controller.selectedItem == null) return;
                          // _openDialog();
                          _openQaimeSheet();
                        },
                        child: Text('Qaime'.tr),
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.red,
                        // ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildSearchField() {
  //   return TextField(
  //     decoration: InputDecoration(
  //       labelText: 'Search customers1111',
  //       prefixIcon: Icon(Icons.search),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //     onChanged: (value) {},
  //   );
  // }

  Widget _buildTrinaGrid(XercQazancController ctrl) {
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
              onChanged: (key, visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: CustomTrinaGrid<XercQazanc>(
            key: ValueKey(ctrl.columns.map((c) => c['visible']).join()),
            data: ctrl.xercs,
            selectedId: ctrl.selectedMustId,
            // onSelect: ctrl.selectPartnyor,
            getId: (item) => item.musId,
            onSelect: (item) {
              ctrl.setSelectItem(item); // works even if ID column is hidden
            },
            columns: displayColumns
                .map(
                  (c) => TrinaColumn(
                    title: c['label'],
                    field: c['key'],
                    type: TrinaColumnType.text(),
                    width: savedColumnWidths[c['key']] ?? 150, // default width
                    enableContextMenu: false,
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
                  case 'mad':
                    cells['mad'] = TrinaCell(value: p.mad);
                    break;
                  case 'mebleg':
                    cells['mebleg'] = TrinaCell(value: p.mebleg.toString());
                    break;
                  case 'oden':
                    cells['oden'] = TrinaCell(value: p.oden.toString());
                    break;
                  case 'kad':
                    cells['kad'] = TrinaCell(value: p.kad.toString());
                    break;
                  case 'xkatAd':
                    cells['xkatAd'] = TrinaCell(value: p.xkatAd ?? '');
                    break;
                  case 'xakatAd':
                    cells['xakatAd'] = TrinaCell(value: p.xakatAd ?? '');
                    break;
                  case 'sebeb':
                    cells['sebeb'] = TrinaCell(value: p.sebeb ?? '');
                    break;
                  case 'qeyd':
                    cells['qeyd'] = TrinaCell(value: p.qeyd ?? '');
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

  Widget _buildTable2(XercQazancController ctrl) {
    ctrl.selectFirstIfNull();
    // Filter visible columns
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
            // PopupMenuButton<String>(
            //   icon: Icon(Icons.view_column),
            //   tooltip: 'Goster/Gizle',
            //   itemBuilder: (context) {
            //     return ctrl.columns.map((col) {
            //       return CheckedPopupMenuItem<String>(
            //         value: col['key'],
            //         checked: col['visible'],
            //         child: Text(col['label']),
            //       );
            //     }).toList();
            //   },
            //   onSelected: (key) {
            //     ctrl.toggleColumnVisibility(key);
            //   },
            // ),
            ColumnVisibilityMenu(
              columns: ctrl.columns,
              onChanged: (key, visible) =>
                  ctrl.toggleColumnVisibilityExplicit(key, visible),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Expanded(
          child: CustomDataTable2<XercQazanc>(
            key: ValueKey(ctrl.columns.map((c) => c['visible']).join()),
            data: ctrl.xercs,
            getId: (p) => p.id,
            sortColumnIndex: 0,
            sortAscending: true,
            selectedId: ctrl.selectedMustId, // optional
            onSelect: ctrl.selectPartnyor,
            columns: displayColumns
                .map((c) => DataColumn(label: Text(c['label'])))
                .toList(),

            cellBuilder: (p) => displayColumns.map<DataCell>((c) {
              if (c['key'] == 'placeholder') return DataCell(Text(''));
              switch (c['key']) {
                case 'id':
                  return DataCell(Text(p.id.toString()));
                case 'mus':
                  return DataCell(Text(p.mad.toString()));
                case 'mebleg':
                  return DataCell(Text(p.mebleg.toString()));
                case 'oden':
                  return DataCell(Text(p.oden?.toString() ?? ''));
                case 'kad':
                  return DataCell(Text(p.kad));
                case 'cat':
                  return DataCell(Text(p.xkatAd?.toString() ?? ''));
                case 'subCat':
                  return DataCell(Text(p.xakatAd?.toString() ?? ''));
                case 'reason':
                  return DataCell(Text(p.sebeb.toString()));
                case 'note':
                  return DataCell(Text(p.qeyd.toString()));
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

  void _openQaimeSheet() {
    final item = controller.xercs.firstWhere(
      (x) => x.id == controller.selectedItem?.id,
    );
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlıq
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Qaimə',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 10),

                  // Qaimə məlumatları
                  _buildQaimeRow('Qaimə №', item.id.toString()),
                  _buildQaimeRow('Müştəri ID', item.musId.toString()),
                  _buildQaimeRow(
                    'Məbləğ',
                    '${item.mebleg?.toStringAsFixed(2)} AZN',
                  ),
                  _buildQaimeRow(
                    'Ödənilmiş',
                    '${item.oden?.toStringAsFixed(2) ?? "0.00"} AZN',
                  ),
                  _buildQaimeRow('Qeyd', item.qeyd ?? '-'),
                  _buildQaimeRow('Səbəb', item.sebeb ?? '-'),
                  _buildQaimeRow('Kateqoriya ID', item.xkat?.toString() ?? '-'),
                  _buildQaimeRow(
                    'Alt Kateqoriya ID',
                    item.xakat?.toString() ?? '-',
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.print),
                      label: Text('Qaiməni çap et'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        _printQaime(item);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openBottomSheet() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      kassaController.resetSelections();
      // await kassaController.preloadData();
      await kassaController.preloadDataForce();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }

    final item = controller.xercs.firstWhere(
      (x) => x.id == controller.selectedItem?.id,
    );

    final isNegative = item.mebleg < 0;
    final sign = isNegative ? '-' : '+';
    final mebleg = isNegative ? item.mebleg.abs() : item.mebleg;
    final pays = isNegative ? item.oden?.abs() : item.oden;

    final dto = XercRequestDto(
      id: item.id,
      mustId: item.musId,
      amount: mebleg,
      pays: pays,
      sign: sign,
      kassaId: item.kassa,
      categoryId: item.xkat,
      subCategoryId: item.xakat,
      sebeb: item.sebeb,
      qeyd: item.qeyd,
    );
    await kassaController.initSelectedFromDto(dto);
    print('mustId...${item.musId}');
    print('item...${item}');
    print('dto...${dto.toString()}');
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7, // start at 70% of screen
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
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
                        'Xərc redakte'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  YeniXercDialog(
                    mustId: item.musId,
                    onSave: (XercRequestDto dto) async {
                      // await controller.saveYeniXerc(dto);
                      await controller.saveXercDuzelis(dto);
                      // Get.back();
                    },
                    initial: dto,
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

  Widget _buildQaimeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: font,
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.Text(value, style: pw.TextStyle(font: font, fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _printQaime(XercQazanc item) async {
    final ttf = pw.Font.ttf(
      await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
    );
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Q A İ M Ə',
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                _buildPdfRow('Qaimə ID', item.id.toString(), ttf),
                _buildPdfRow('Müştəri ID', item.musId.toString(), ttf),
                _buildPdfRow(
                  'Məbləğ',
                  '${item.mebleg?.toStringAsFixed(2)} AZN',
                  ttf,
                ),
                _buildPdfRow(
                  'Ödənilmiş',
                  '${item.oden?.toStringAsFixed(2) ?? "0.00"} AZN',
                  ttf,
                ),
                _buildPdfRow('Səbəb', item.sebeb ?? '-', ttf),
                _buildPdfRow('Qeyd', item.qeyd ?? '-', ttf),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Tarix: ${DateTime.now().toString().split(" ").first}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    Get.snackbar('Çap', 'Qaimə məlumatları printere göndərildi');
  }
}
