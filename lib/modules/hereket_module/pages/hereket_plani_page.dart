import 'package:data_table_2/data_table_2.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/hereket_module/controller/hereket_plani_controller.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_model.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_request.dart';
import 'package:hbmarket/modules/hereket_module/pages/qaime_bax_page.dart';
import 'package:hbmarket/modules/hereket_module/widget/hereket_widget.dart';
import 'package:hbmarket/modules/hereket_module/widget/work_widget.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/raport_module/controller/report_controller.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat, PdfColors;
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:trina_grid/trina_grid.dart';

class HereketPlaniPage extends StatelessWidget {
  final ReportController controller = Get.find<ReportController>();
  final ObyektController obyController = Get.find<ObyektController>();
  final HereketPlaniController hereketController =
      Get.find<HereketPlaniController>();
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Hərəkət planı'.tr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: GetBuilder<HereketPlaniController>(
            builder: (HereketPlaniController ctrl) {
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
                            // child: _buildTable2(ctrl),
                          );
                        },
                      ),
                    ),
                  ),

                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => QaimeBaxPage(dplanId: ctrl.selectedId!,));
                          },
                          child: const Text('Bax'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _openDialog();
                          },
                          child: const Text('Funksiyalar'),
                        ),
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
            child: SizedBox.expand(
              child: ListView(
                // shrinkWrap: true,
                controller: scrollController,
                children: [
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                       hereketController.refreshHereket();
                    },
                    child: Text("refresh".tr),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // if (hereketController.selectedId == null) return;
                      // print('addClicked...');
                      // _openDialog();
                      _openBottomSheet();
                    },
                    child: Text("buttonNew".toString().tr),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (hereketController.selectedId == null) return;
                      final selected = hereketController.herekets.firstWhere(
                        (t) => t.id == hereketController.selectedId,
                      );

                      final editData = HereketRequest(
                        id: selected.id,
                        hereketId: selected.hereket?.id,
                        obyektId: selected.obyekt?.id,
                        partnyorId: selected.partnyor?.id,
                        percentage: Decimal.parse(
                          selected.percentage.toString(),
                        ),
                        note: selected.note,
                      );

                      _openBottomSheet(initial: editData);
                    },
                    child: Text("buttonUpdate".tr),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (hereketController.selectedId == null) return;
                      // Show confirmation dialog
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: Text("Təsdiqlə".tr),
                          content: Text("Əminsiniz?".tr),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false), // return false
                              child: Text("Xeyr".tr),
                            ),
                            ElevatedButton(
                              onPressed: () => Get.back(result: true), // return true
                              child: Text("Bəli".tr),
                            ),
                          ],
                        ),
                        barrierDismissible: false,
                      );


                      if (confirm != true) return;
                      await hereketController.deleteHereket(
                        hereketController.selectedId!,
                      );
                      Get.snackbar(
                        "Uğurla silindi".tr,
                        "",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 8,
                        duration: const Duration(seconds: 3),
                      );
                      // Get.back();
                    },
                    child: Text("buttonDel".tr),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (hereketController.selectedObyekt == null) return;
                      int? obyektId = hereketController.selectedObyekt?.id;
                      debugPrint('obyektId...${obyektId}');
                      // final selected = hereketController.herekets.firstWhere(
                      //   (t) => t.id == hereketController.selectedObyekt?.id,
                      // );
                      _openWorkBottomSheet1(context, obyektId!);
                      // _openWork();
                    },
                    child: Text("buttonWork".tr),
                  ),

                const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("cix".tr),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // isScrollControlled: true,
      // backgroundColor: Colors.transparent, // optional
    );
  }

  void _openWork() async {
    final result = await Get.to<HereketRequest>(
      () => Scaffold(
        appBar: AppBar(
          // title: Text(initial == null ? 'Yeni Hərəkət' : 'Redaktə'),
        ),
        body: WorkWidget(
          obyektId: 0,
          hereketId: 0,
          dPlanId: 0,
          // initial: initial,
          onSave: (dto) {
            Get.back(result: dto); // send data back
          },
        ),
      ),
    );

    if (result != null) {
      final ctrl = Get.find<HereketPlaniController>();

      //   if (initial == null) {
      //     await ctrl.saveNewHereket(result);
      //   } else {
      //     await ctrl.updateHereket(result);
      //   }

      //   ctrl.fetchHerekets(); // refresh your grid
      // }
    }
  }

  // void _openWorkBottomSheet1(BuildContext context, int obyektId) {
  //   debugPrint('before open dialiog dplanid: ${hereketController.dplaId}');
  //   Get.bottomSheet(
  //     Container(
  //       height: MediaQuery.of(context).size.height,
  //       padding: const EdgeInsets.all(16),
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: SingleChildScrollView(
  //         child: WorkWidget(
  //           obyektId: obyektId,
  //           hereketId: hereketController.selectedHereketDto!.id,
  //           dPlanId: hereketController.dplaId!,
  //           initial: null,
  //           onSave: (HereketRequest dto) async {
  //             Get.back(); // Close the bottom sheet
  //           },
  //         ),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //   );
  // }

  void _openWorkBottomSheet1(BuildContext context, int obyektId) {
    debugPrint('before open dialiog dplanid: ${hereketController.dplaId}');

    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: true, // Tam ekran üçün
        initialChildSize: 0.95, // Açılışda 95% hündürlük
        minChildSize: 0.5,      // minimal hündürlük
        maxChildSize: 0.95,     // maksimum hündürlük
        builder: (BuildContext context, ScrollController scrollController) {
          return GestureDetector(
              behavior: HitTestBehavior.translucent, // boş yerlərdə də klik tutsun
              onTap: () {
                FocusScope.of(context).unfocus(); // 👉 klaviaturanı gizlədir
              },
              child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController, // scroll üçün
              child: WorkWidget(
                obyektId: obyektId,
                hereketId: hereketController.selectedHereketDto!.id,
                dPlanId: hereketController.dplaId!,
                initial: null,
                onSave: (HereketRequest dto) async {
                  Get.back(); // Close the bottom sheet
                },
              ),
            ),
          ));
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }


  void _openWorkBottomSheet() {
    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          //     return LayoutBuilder(
          //       builder: (context, constraints) {
          //         return Container(
          //           padding: const EdgeInsets.all(16),
          //           decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          //           ),
          //           child: SingleChildScrollView(
          //             controller: scrollController,
          //             child: ConstrainedBox(
          //               constraints: BoxConstraints(
          //                 minHeight: constraints.maxHeight,
          //               ),
          //               // child: WorkWidget(
          //               //   id: 0,
          //               //   initial: null,
          //               //   onSave: (dto) => Get.back(),
          //               // ),
          //             ),
          //           ),
          //         );
          //       },
          // );
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: WorkWidget(
                obyektId: 0,
                hereketId: 0,
                dPlanId: 0,
                initial: null,
                onSave: (dto) async {
                  // final ctrl = Get.find<HereketPlaniController>();

                  // if (initial == null) {
                  //   await ctrl.saveNewHereket(dto);
                  // } else {
                  //   await ctrl.updateHereket(dto);
                  // }

                  Get.back(); // Close the bottom sheet
                },
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openBottomSheet({HereketRequest? initial}) async {
    final HereketPlaniController ctrl = Get.find<HereketPlaniController>();
    ctrl.resetSelections();
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    // await ctrl.preloadData();
    Get.back();
    // await Get.showOverlay(
    //   asyncFunction: () async => await ctrl.preloadData(),
    //   loadingWidget: const Center(child: CircularProgressIndicator()),
    // );

    Get.bottomSheet(
      DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8, // start at 70% of screen
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque, // boş sahələrdə klikləri də tutmaq üçün
              onTap: () {
                Get.focusScope?.unfocus();
              },
           child: Container(
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
                        'Yeni hərəkət planı'.tr,
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
                  HereketWidget(
                    id: hereketController.selectedId,
                    initial: initial,
                    onSave: (HereketRequest dto) async {
                      debugPrint('initialValues ${initial?.toJson()} ${dto}');
                      if (initial == null) {
                        await hereketController.saveNewHereket(dto);
                        // await ctrl.fetchHereketPlani();
                        Get.back();
                      } else {
                        // debugPrint('111111 ..${dto.toJson()}');
                        await hereketController.updateHereket(dto);
                        await ctrl.fetchHereketPlani();
                        Get.back();
                      }
                    },
                  ),
                ],
              ),
            ),
          )
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // optional
    );
  }

  Widget _buildTable2(HereketPlaniController ctrl) {
    return CustomDataTable<Hereket>(
      data: [],
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
        DataColumn2(label: Text('Obyekt')),
        DataColumn2(label: Text('Partnyor')),
        DataColumn2(label: Text('%')),
        DataColumn2(label: Text('Meb.')),
        DataColumn2(label: Text('R.meb')),
        DataColumn2(label: Text('Hereket')),
      ],
      rowBuilder: (data) {
        return data.map((k) {
          return DataRow(
            cells: [
              DataCell(Text(k.id.toString())),
              DataCell(Text(k.obyekt)),
              DataCell(Text(k.partnyor)),
              DataCell(Text(k.faiz)),
              DataCell(Text(k.mebleg.toString())),
              DataCell(Text(k.rmeb.toString())),
              DataCell(Text(k.hereket)),
            ],
          );
        }).toList();
      },
    );
  }

  void _openFooDialog(BuildContext context) {
    print('open dialog...');
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      Get.bottomSheet(
        Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Text(
                  "selectObject".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ), // Body
              Expanded(
                child: GetBuilder<ObyektController>(
                  builder: (ctrl) {
                    if (ctrl.obyekts.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      itemCount: ctrl.obyekts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final foo = ctrl.obyekts[index];
                        return ListTile(
                          leading: const Icon(Icons.store, color: Colors.blue),
                          title: Text(foo.name),
                          subtitle: Text("Details: ${foo.name}"),
                          onTap: () {
                            print('${foo}');
                            ctrl.setSelectedObyekt(foo);
                            Get.back();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 💻 Web/Desktop Modal style
      Get.dialog(
        Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Obyekt secin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Body
                Expanded(
                  child: GetBuilder<ObyektController>(
                    builder: (ctrl) {
                      if (ctrl.obyekts.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Scrollbar(
                        thumbVisibility: true,
                        child: ListView.separated(
                          itemCount: ctrl.obyekts.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final foo = ctrl.obyekts[index];
                            return ListTile(
                              leading: const Icon(
                                Icons.store,
                                color: Colors.blue,
                              ),
                              title: Text(foo.name),
                              subtitle: Text("Details: ${foo.name}"),
                              onTap: () {
                                ctrl.setSelectedObyekt(foo);
                                Get.back();
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // Get.dialog(
    //   AlertDialog(
    //     title: const Text("Select Foo"),
    //     content: SizedBox(
    //       width: double.maxFinite,
    //       child: GetBuilder<ObyektController>(
    //         builder: (ctrl) {
    //           if (ctrl.obyekts.isEmpty) {
    //             return const Center(child: CircularProgressIndicator());
    //           }

    //           return ListView.builder(
    //             shrinkWrap: true,
    //             itemCount: ctrl.obyekts.length,
    //             itemBuilder: (context, index) {
    //               final foo = ctrl.obyekts[index];
    //               return ListTile(
    //                 title: Text(foo.name),
    //                 subtitle: Text(foo.name),
    //                 onTap: () {
    //                   // ctrl.select(foo); // save selected Foo
    //                   Get.back(); // close dialog
    //                 },
    //               );
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //     actions: [
    //       TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
    //     ],
    //   ),
    // );
  }

  void printReports(ReportController ctrl) async {
    final pdf = pw.Document();
    final font = await loadFont();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          final allWidgets = <pw.Widget>[];

          for (var group in ctrl.reportItems) {
            final rows = group.rows ?? [];
            final headers = rows.isNotEmpty
                ? rows.expand((row) => row.fields.keys).toSet().toList()
                : [];

            // Group title
            allWidgets.add(
              pw.Text(
                group.basliq,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            );
            allWidgets.add(pw.SizedBox(height: 6));

            if (rows.isNotEmpty) {
              allWidgets.add(
                pw.TableHelper.fromTextArray(
                  headers: headers,
                  data: rows
                      .map(
                        (row) => headers
                            .map((h) => row.fields[h]?.value?.toString() ?? '')
                            .toList(),
                      )
                      .toList(),
                  headerStyle: pw.TextStyle(
                    font: font,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.blue,
                  ),
                  cellStyle: pw.TextStyle(font: font, fontSize: 10),
                  cellAlignment: pw.Alignment.center,
                  headerAlignment: pw.Alignment.center,
                ),
              );
              allWidgets.add(pw.SizedBox(height: 12));
            }
          }

          return allWidgets;
        },
      ),
    );
    // Collect all widgets
    // final allWidgets = <pw.Widget>[];
    // int rowCount = 0;

    // for (var group in ctrl.reportItems) {
    //   final rows = group.rows ?? [];
    //   rowCount += rows.length;
    //   final headers = rows.isNotEmpty
    //       ? rows.expand((row) => row.fields.keys).toSet().toList()
    //       : [];

    //   // Group title
    //   allWidgets.add(
    //     pw.Text(
    //       group.basliq,
    //       style: pw.TextStyle(
    //         font: font,
    //         fontSize: 16,
    //         fontWeight: pw.FontWeight.bold,
    //       ),
    //     ),
    //   );
    //   allWidgets.add(pw.SizedBox(height: 6));

    //   // Add table only if rows exist
    //   if (rows.isNotEmpty) {
    //     allWidgets.add(
    //       pw.TableHelper.fromTextArray(
    //         headers: headers,
    //         data: rows
    //             .map(
    //               (row) => headers
    //                   .map((h) => row.fields[h]?.value?.toString() ?? '')
    //                   .toList(),
    //             )
    //             .toList(),
    //         headerStyle: pw.TextStyle(
    //           font: font,
    //           fontWeight: pw.FontWeight.bold,
    //           color: PdfColors.white,
    //         ),
    //         headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
    //         cellStyle: pw.TextStyle(font: font, fontSize: 10),
    //         cellAlignment: pw.Alignment.center,
    //         headerAlignment: pw.Alignment.center,
    //       ),
    //     );
    //     allWidgets.add(pw.SizedBox(height: 12));
    //   }
    // }

    //   pdf.addPage(
    //     pw.MultiPage(
    //       pageFormat: PdfPageFormat.a4,
    //       build: (context) {
    //         final widgets = <pw.Widget>[
    //           pw.Text(
    //             group.basliq,
    //             style: pw.TextStyle(
    //               font: font,
    //               fontSize: 18,
    //               fontWeight: pw.FontWeight.bold,
    //             ),
    //           ),
    //           pw.SizedBox(height: 8),
    //         ];

    //         if (rows.isNotEmpty) {
    //           widgets.add(
    //             pw.TableHelper.fromTextArray(
    //               headers: headers,
    //               data: rows
    //                   .map(
    //                     (row) => headers
    //                         .map((h) => row.fields[h]?.value?.toString() ?? '')
    //                         .toList(),
    //                   )
    //                   .toList(),
    //               headerStyle: pw.TextStyle(
    //                 font: font,
    //                 fontWeight: pw.FontWeight.bold,
    //                 color: PdfColors.white,
    //               ),
    //               headerDecoration: const pw.BoxDecoration(
    //                 color: PdfColors.blue,
    //               ),
    //               cellStyle: pw.TextStyle(font: font),
    //               cellAlignment: pw.Alignment.center,
    //               headerAlignment: pw.Alignment.center,
    //             ),
    //           );
    //           widgets.add(pw.SizedBox(height: 16));
    //         }

    //         return widgets;
    //       },
    //     ),
    //   );
    // }

    // final estimatedHeight = (rowCount * 20) + 300;
    // final pageHeight = estimatedHeight < 842
    //     ? 842
    //     : estimatedHeight; // at least A4

    // Put everything on a single very tall page
    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat(
    //       595,
    //       pageHeight.toDouble(),
    //     ), // A4 width, 5000 height
    //     build: (context) => pw.Column(
    //       crossAxisAlignment: pw.CrossAxisAlignment.start,
    //       children: allWidgets,
    //     ),
    //   ),
    // );
    // Printing
    if (kIsWeb) {
      final pdfBytes = await pdf.save();
      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
    } else {
      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    }
  }

  Future<pw.Font> loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  Widget _buildTrinaGrid(HereketPlaniController ctrl) {
    // Map<String, double> savedColumnWidths = {};

    final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();

    // debugPrint('${visibleColumns.length}');
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
          child: TrinaGridWidget<HereketResponse>(
            key: ValueKey(ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join()),
            data: ctrl.herekets,
            selectedId: ctrl.selectedId,
            onSelect: (HereketResponse item) {
              ctrl.selectHereket(item); // works even if ID column is hidden
            },

            getId: (p) => p.id,
            columns: displayColumns,
            cellBuilder: (p) {
              final Map<String, TrinaCell> cells = {};

              for (final Map<String, dynamic> c in displayColumns) {
                // debugPrint(c['key']);
                switch (c['key']) {
                  case 'id':
                    cells['id'] = TrinaCell(value: p.id.toString());
                    break;
                  case 'hereket':
                    cells['hereket'] = TrinaCell(value: p.hereket?.name);
                    break;
                  case 'obyekt':
                    cells['obyekt'] = TrinaCell(value: p.obyekt?.name);
                    break;
                  case 'partner':
                    cells['partner'] = TrinaCell(value: p.partnyor?.ad);
                    break;

                  case 'percentage':
                    cells['percentage'] = TrinaCell(value: p.percentage);
                    break;
                  case 'note':
                    cells['note'] = TrinaCell(value: p.note);
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
