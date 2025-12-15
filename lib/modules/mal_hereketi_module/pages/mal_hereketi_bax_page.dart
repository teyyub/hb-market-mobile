import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../print_module/controller/qaime_print_controller.dart';
import '../../print_module/models/qaime_detail_dto.dart';
import '../../print_module/models/qaime_item.dart';
import '../controller/mal_hereketi_controller.dart';
import '../models/pul_hereketi_bax.dart';

class MalHereketiBaxPage extends StatelessWidget {
  // final ObyektController obyController = Get.find<ObyektController>();
  // final MalHereketiController malHereketiController = Get.find<MalHereketiController>();
  final qaimePrintCtrl = Get.find<QaimePrintController>();
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Mal hərəkəti Bax',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // _buildTopControls(context),
              // const SizedBox(height: 16),
              Flexible(
                child: GetBuilder<MalHereketiController>(
                  builder: (MalHereketiController ctrl) {
                    if (ctrl.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // return _buildTable();
                    return _buildTrinaGrid(ctrl, context);
                  },
                ),
              ),
              const SizedBox(height: 16),
              GetBuilder<QaimePrintController>(
                builder: (ctrl) {
                  return Stack(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: Text("Print".tr),
                        onPressed: ctrl.isLoading || ctrl.isPrinting
                            ? null
                            : () async {
                                await ctrl.loadQaime(170220);
                                printInvoicePdf(
                                  ctrl.qaimePrintDto!.qaimeDetail,
                                  ctrl.qaimePrintDto!.qaimeItems,
                                );
                              },
                      ),

                      // Loading overlay
                      if (ctrl.isLoading || ctrl.isPrinting)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black45,
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 12),
                                  Text(
                                    "Zəhmət olmasa gözləyin...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> printInvoicePdf(
    QaimeDetailDto detail,
    List<QaimeItem> items,
  ) async {
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final fontBold = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBold);
    final pdf = pw.Document();
    final today = DateFormat('MM.dd.yyyy').format(DateTime.now());
    final prtinFrm = DateFormat('MM.dd.yyyy HH:mm').format(detail.printedAt);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            // mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: 'Qaimə №',
                        style: pw.TextStyle(fontSize: 22, font: ttfBold),
                      ),
                      pw.TextSpan(
                        text: '${detail.id}',
                        style: pw.TextStyle(fontSize: 22, font: ttf),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Center(
                child: pw.Container(
                  width: 200,
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      ...[
                        {'label': 'Müştəri:', 'value': detail.dtAd},
                        {'label': 'Tarix:', 'value': today},
                        {'label': 'Çap edilib:', 'value': prtinFrm},
                        {'label': 'Obyekt:', 'value': detail.oAd},
                      ].map((item) {
                        return pw.Row(
                          mainAxisSize: pw.MainAxisSize.max, // full width
                          children: [
                            pw.Container(
                              width: 90,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                item['label'] ?? '',
                                style: pw.TextStyle(font: ttfBold),
                              ),
                            ),
                            pw.SizedBox(width: 6),
                            pw.Container(
                              width: 140,
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                '${item['value'] ?? ''}',
                                style: pw.TextStyle(font: ttf),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 16),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: items.map((e) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                e.ad,
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                '${e.barkod}',
                                style: pw.TextStyle(font: ttf, fontSize: 10),
                              ),
                            ],
                          ),
                          // Miqdar sağ tərəf
                          pw.Text(
                            '${e.miqdar} x ${e.qiymet.abs()} = ${e.miqdar * e.qiymet.abs()}',
                            style: pw.TextStyle(font: ttf, fontSize: 10),
                          ),
                        ],
                      ),
                      pw.Divider(), // hər məhsuldan sonra xətt
                      pw.SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),

              pw.SizedBox(height: 16),
              pw.Padding(
                padding: const pw.EdgeInsets.only(right: 2),
                child: pw.Container(
                  width: double.infinity, // Column-u sağa çəkir
                  child: pw.Column(
                    // mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      ...[
                        {'label': 'Cəm:', 'value': detail.mebleg},
                        {'label': 'Endirim:', 'value': detail.endirim},
                        {'label': 'Ödənilib:', 'value': detail.oden},
                        {'label': 'Borc:', 'value': detail.borc},
                      ].map((item) {
                        return pw.Row(
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Container(
                              width: 190,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                item['label'] as String,
                                style: pw.TextStyle(font: ttfBold),
                              ),
                            ),
                            pw.SizedBox(width: 6),
                            pw.Container(
                              width: 60,
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                '${item['value'] ?? ''}',
                                style: pw.TextStyle(font: ttf),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Widget _buildTopControls(BuildContext context) {
  //   final isMobile = DeviceUtils.isMobile(context);
  //   return GetBuilder<MalYoxlaController>(
  //     builder: (MalYoxlaController ctrl) {
  //       if (ctrl.errorMessage.isNotEmpty) {
  //         Future.microtask(() {
  //           Get.snackbar(
  //             'Xəbərdarlıq',
  //             ctrl.errorMessage,
  //             snackPosition: SnackPosition.BOTTOM,
  //             backgroundColor: Colors.orange.shade100,
  //             colorText: Colors.black,
  //           );
  //           ctrl.errorMessage = '';
  //         });
  //       }
  //       return Card(
  //         color: Colors.blue[50],
  //         elevation: 2,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: isMobile
  //               ? Column(
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     SelectObjectButton(obyCtrl: Get.find<ObyektController>()),
  //                     const SizedBox(height: 12),
  //                     GetBuilder<MalYoxlaController>(
  //                       builder: (MalYoxlaController ctrl) {
  //                         return DropdownSelector<SearchItem>(
  //                           label: ''.tr,
  //                           selectedValue:
  //                               malYoxlaController.selectedSearchItem,
  //                           items: malYoxlaController.searchItems,
  //                           itemLabel: (r) => r.title,
  //                           onChanged: (r) {
  //                             malYoxlaController.setSelectedSearchItem(r);
  //                             malYoxlaController.searchFocus.requestFocus();
  //                             malYoxlaController.searchController.clear();
  //                           }
  //                         );
  //                       },
  //                     ),
  //                     const SizedBox(height: 12),
  //                     buildNumberField(
  //                       label: 'Axtar',
  //                       isNumberOnly: ctrl.selectedSearchItem?.id == 0,
  //                       focusNode: malYoxlaController.searchFocus,
  //
  //                       onChanged: (String value) {
  //
  //                       },
  //                     ),
  //                   ],
  //                 )
  //               : Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.stretch,
  //                         children: [
  //                           ElevatedButton(
  //                             onPressed: () =>
  //                                 ObyektWidget.show(context, obyController),
  //                             child: const Text("Select Obyekt"),
  //                           ),
  //                           const SizedBox(height: 12),
  //                           // _buildTimeSelectors(context),
  //                           // const SizedBox(height: 12),
  //                           // _buildReportIdSelector(),
  //                           // const SizedBox(height: 12),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     const Column(
  //                       children: [
  //                         // ElevatedButton.icon(
  //                         //   icon: const Icon(Icons.download),
  //                         //   label: Text("btnFetchReport".tr),
  //                         //   onPressed: () {
  //                         //     // ctrl.fetchReportPrint();
  //                         //   },
  //                         // ),
  //                         // const SizedBox(height: 12),
  //                         // ElevatedButton.icon(
  //                         //   icon: const Icon(Icons.print),
  //                         //   label: Text("btnPrint".tr),
  //                         //   onPressed: () => printReports(controller),
  //                         // ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget buildNumberField({
  //   required String label,
  //   required Function(String) onChanged,
  //   int? initialValue,
  //   bool enabled = true,
  //   bool isNumberOnly = false,
  //   FocusNode? focusNode,
  // }) {
  //
  //   final controller = malYoxlaController.searchController;
  //   return GetBuilder<MalYoxlaController>(
  //     builder: (MalYoxlaController ctrl) {
  //       final isNumber = ctrl.selectedSearchItem?.id == 0;
  //       final isBarcode = ctrl.selectedSearchItem?.id == 2;
  //       return TextField(
  //         key: ValueKey(isNumber),
  //         controller: controller,
  //         focusNode: malYoxlaController.searchFocus,
  //         enabled: enabled,
  //         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
  //         inputFormatters: isNumber
  //             ? [FilteringTextInputFormatter.digitsOnly]
  //             : [],
  //         decoration: InputDecoration(
  //           labelText: label,
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //           suffixIcon: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               if (isBarcode)
  //                 IconButton(
  //                   icon: const Icon(Icons.qr_code_scanner),
  //                   tooltip: 'Barkodu oxu',
  //                   onPressed: () async {
  //                     final result = await Get.to(
  //                       () => const BarcodeScannerPage(),
  //                     );
  //                     if (result != null && result is String) {
  //                       // final result1 = '2513183501007';
  //                       malYoxlaController.searchController.text = result;
  //                       malYoxlaController.search(result);
  //                     }
  //                   },
  //                 ),
  //               IconButton(
  //                 icon: const Icon(Icons.search),
  //                 onPressed: () {
  //                   malYoxlaController.search(controller.text);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         onSubmitted: (value) {
  //           malYoxlaController.search(value);
  //         },
  //         onChanged: (String value) {
  //           if (isNumberOnly) {
  //             int number = int.tryParse(value) ?? 0;
  //             onChanged(number.toString());
  //           } else {
  //             onChanged(value);
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

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

  Widget _buildTrinaGrid(MalHereketiController ctrl, BuildContext context) {
    // Map<String, double> savedColumnWidths = {};

    final visibleColumns = ctrl.malHereketiBaxColumns
        .where((c) => c['visible'])
        .toList();

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
          child: TrinaGridWidget<MalHereketiBaxDto>(
            key: ValueKey(
              ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join(),
            ),
            data: ctrl.malHereketleriBax,
            selectedId: ctrl.selectedId,
            // onSelect: ctrl.selectPartnyor,
            onSelect: (MalHereketiBaxDto item) {
              ctrl.setSelectedMalHereketiBax(
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
                  case 'nad':
                    cells['nad'] = TrinaCell(value: p.nAd);
                    break;
                  case 'seri':
                    cells['seri'] = TrinaCell(value: p.seri);
                    break;
                  case 'miqdar':
                    cells['miqdar'] = TrinaCell(value: p.miqdar);
                    break;
                  case 'qiymet':
                    cells['qiymet'] = TrinaCell(value: p.qiymet);
                    break;
                  case 'qeyd':
                    cells['qeyd'] = TrinaCell(value: p.qeyd);
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
