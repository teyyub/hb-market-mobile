import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/common/widgets/date_picker_field.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/widget/obyekt_widget.dart';
import 'package:hbmarket/modules/object_module/widget/select_object_button.dart';
import 'package:hbmarket/modules/raport_module/controller/report_controller.dart';
import 'package:hbmarket/modules/raport_module/models/report_model.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat, PdfColors;
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportPage extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());
  final ObyektController obyController = Get.put(ObyektController());
  final ScrollController listScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final isMobile = DeviceUtils.isMobile(context);
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
    return MainLayout(title: 'Raport', 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopControls(context),
              const SizedBox(height: 16),

              Expanded(
                child: GetBuilder<ReportController>(
                  builder: (ctrl) {
                    if (ctrl.isLoading && ctrl.reportItemFetched) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Page just opened, user hasn't fetched yet
                    if (!ctrl.reportItemFetched) {
                      return SizedBox.shrink(); // show nothing
                    }

                    return !isMobile
                        ? _buildListView(ctrl, context)
                        : _buildMobileListView(ctrl, context);
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
      ),
    );
  }

  Widget _buildMobileListView(ReportController ctrl, BuildContext context) {
    if (ctrl.reportItems.isEmpty) {
      return Center(child: Text("notFound".tr));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ctrl.reportItems.length,
      itemBuilder: (context, index) {
        final group = ctrl.reportItems[index];
        final rows = group.rows ?? [];
        if (rows.isEmpty) return const SizedBox.shrink();
        final headers = rows.expand((row) => row.fields.keys).toSet().toList();

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ExpansionTile(
            title: Text(
              group.basliq,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    // Header row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blue[100]),
                      children: headers.map((h) {
                        return Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            h,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),
                    // Data rows
                    ...rows.map((row) {
                      return TableRow(
                        children: headers.map((h) {
                          final field = row.fields[h];
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              field?.value?.toString() ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopControls(BuildContext context) {
    final isMobile = DeviceUtils.isMobile(context);
    return GetBuilder<ReportController>(
      builder: (ctrl) {
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
                      _buildTimeSelectors(context),
                      const SizedBox(height: 12),
                      _buildReportIdSelector(),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: isMobile ? double.infinity : 160,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.download),
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('btnFetchReport'.tr),
                              ),
                              onPressed: () {
                                Get.snackbar(
                                  'Info',
                                  'Hesabat hazirlanir...',
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                );
                                ctrl.fetchReportPrint();
                              },
                            ),
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
                            _buildTimeSelectors(context),
                            const SizedBox(height: 12),
                            _buildReportIdSelector(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.download),
                            label: Text("btnFetchReport".tr),
                            onPressed: () {
                              ctrl.fetchReportPrint();
                            },
                          ),
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

  // Widget _buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: const BoxDecoration(
  //       color: Colors.blue,
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     child: Text(
  //       "selectObject".tr,
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 18,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildFooter() {
  //   return // Footer
  //   Padding(
  //     padding: const EdgeInsets.all(12),
  //     child: Align(
  //       alignment: Alignment.centerRight,
  //       child: TextButton(
  //         onPressed: () => Get.back(),
  //         child: const Text("Cancel"),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildBody(bool isMobile) {
  //   return GetBuilder<ObyektController>(
  //     builder: (ctrl) {
  //       if (ctrl.isLoading)
  //         return const Center(child: CircularProgressIndicator());
  //       if (ctrl.errorMessage.isNotEmpty)
  //         return Center(child: Text(ctrl.errorMessage));
  //       if (ctrl.obyekts.isEmpty)
  //         return const Center(child: Text('No objects found'));

  //       // Use the same ScrollController for Scrollbar and ListView
  //       return Scrollbar(
  //         controller: listScrollController,
  //         thumbVisibility:
  //             !isMobile, // show thumb on desktop/web, hide on mobile
  //         child: ListView.separated(
  //           controller: listScrollController,
  //           itemCount: ctrl.obyekts.length,
  //           separatorBuilder: (_, __) => const Divider(height: 1),
  //           itemBuilder: (context, index) {
  //             final foo = ctrl.obyekts[index];
  //             return ListTile(
  //               leading: const Icon(Icons.store, color: Colors.blue),
  //               title: Text(foo.name),
  //               subtitle: Text("Details: ${foo.name}"),
  //               onTap: () {
  //                 ctrl.setSelectedObyekt(foo);
  //                 Get.back();
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildDialogContent(BuildContext context, bool isMobile) {
  //   return Column(
  //     children: [
  //       _buildHeader(),
  //       Expanded(child: _buildBody(isMobile)),
  //       _buildFooter(),
  //     ],
  //   );
  // }

  // void _openFooDialog(BuildContext context) {
  //   print('open dialog...');
  //   final ctrl = Get.find<ObyektController>();
  //   if (ctrl.obyekts.isEmpty) {
  //     ctrl.fetchObyekts(); // ensure fetch runs
  //   }
  //   final isMobile = DeviceUtils.isMobile(context);
  //   // final content = _buildDialogContent(context, isMobile);

  //   if (isMobile) {
  //     Get.bottomSheet(
  //       Container(
  //         height: MediaQuery.of(context).size.height * 0.85,
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //         ),
  //         child: content,
  //         // Column(
  //         //   children: [
  //         //     // Header
  //         //     _buildHeader(), // Body
  //         //     Expanded(
  //         //       child: GetBuilder<ObyektController>(
  //         //         builder: (ctrl) {
  //         //           if (ctrl.isLoading) {
  //         //             return const Center(child: CircularProgressIndicator());
  //         //           }
  //         //           if (ctrl.errorMessage.isNotEmpty) {
  //         //             return Center(child: Text(ctrl.errorMessage));
  //         //           }

  //         //           if (ctrl.obyekts.isEmpty) {
  //         //             return const Center(child: Text('No objects found'));
  //         //           }
  //         //           // if (ctrl.obyekts.isEmpty) {
  //         //           //   return const Center(child: CircularProgressIndicator());
  //         //           // }

  //         //           return ListView.separated(
  //         //             itemCount: ctrl.obyekts.length,
  //         //             separatorBuilder: (_, __) => const Divider(height: 1),
  //         //             itemBuilder: (context, index) {
  //         //               final foo = ctrl.obyekts[index];
  //         //               return ListTile(
  //         //                 leading: const Icon(Icons.store, color: Colors.blue),
  //         //                 title: Text(foo.name),
  //         //                 subtitle: Text("Details: ${foo.name}"),
  //         //                 onTap: () {
  //         //                   print('${foo}');
  //         //                   ctrl.setSelectedObyekt(foo);
  //         //                   Get.back();
  //         //                 },
  //         //               );
  //         //             },
  //         //           );
  //         //         },
  //         //       ),
  //         //     ),
  //         //     _buildFooter(),
  //         // ],
  //       ),
  //     );
  //   } else {
  //     // 💻 Web/Desktop Modal style
  //     Get.dialog(
  //       Dialog(
  //         insetPadding: const EdgeInsets.all(24),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: content,
  //         // ConstrainedBox(
  //         //   constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
  //         //   child: Column(
  //         //     mainAxisSize: MainAxisSize.min,
  //         //     children: [
  //         //       // Header
  //         //       _buildHeader(),

  //         //       // Body
  //         //       Expanded(
  //         //         child: GetBuilder<ObyektController>(
  //         //           builder: (ctrl) {
  //         //             if (ctrl.obyekts.isEmpty) {
  //         //               return const Center(child: CircularProgressIndicator());
  //         //             }

  //         //             return Scrollbar(
  //         //               thumbVisibility: true,
  //         //               child: ListView.separated(
  //         //                 itemCount: ctrl.obyekts.length,
  //         //                 separatorBuilder: (_, __) => const Divider(height: 1),
  //         //                 itemBuilder: (context, index) {
  //         //                   final foo = ctrl.obyekts[index];
  //         //                   return ListTile(
  //         //                     leading: const Icon(
  //         //                       Icons.store,
  //         //                       color: Colors.blue,
  //         //                     ),
  //         //                     title: Text(foo.name),
  //         //                     subtitle: Text("Details: ${foo.name}"),
  //         //                     onTap: () {
  //         //                       ctrl.setSelectedObyekt(foo);
  //         //                       Get.back();
  //         //                     },
  //         //                   );
  //         //                 },
  //         //               ),
  //         //             );
  //         //           },
  //         //         ),
  //         //       ),

  //         //       _buildFooter(),
  //         //     ],
  //         //   ),
  //         // ),
  //       ),
  //     );
  //   }
  //   // Get.dialog(
  //   //   AlertDialog(
  //   //     title: const Text("Select Foo"),
  //   //     content: SizedBox(
  //   //       width: double.maxFinite,
  //   //       child: GetBuilder<ObyektController>(
  //   //         builder: (ctrl) {
  //   //           if (ctrl.obyekts.isEmpty) {
  //   //             return const Center(child: CircularProgressIndicator());
  //   //           }

  //   //           return ListView.builder(
  //   //             shrinkWrap: true,
  //   //             itemCount: ctrl.obyekts.length,
  //   //             itemBuilder: (context, index) {
  //   //               final foo = ctrl.obyekts[index];
  //   //               return ListTile(
  //   //                 title: Text(foo.name),
  //   //                 subtitle: Text(foo.name),
  //   //                 onTap: () {
  //   //                   // ctrl.select(foo); // save selected Foo
  //   //                   Get.back(); // close dialog
  //   //                 },
  //   //               );
  //   //             },
  //   //           );
  //   //         },
  //   //       ),
  //   //     ),
  //   //     actions: [
  //   //       TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
  //   //     ],
  //   //   ),
  //   // );
  // }

  Widget _buildTimeSelectors(BuildContext context) {
    final isMobile = DeviceUtils.isMobile(context);
    return GetBuilder<ReportController>(
      builder: (ctrl) {
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DatePickerField(
                label: "startDate".tr,
                selectedDate: ctrl.startDate,
                onDateSelected: ctrl.setStartDate,
              ),
              const SizedBox(height: 12),
              DatePickerField(
                label: "endDate".tr,
                selectedDate: ctrl.endDate,
                onDateSelected: ctrl.setEndDate,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text("Start Time"),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "startDate".tr,
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: ctrl.startDate != null
                            ? "${ctrl.startDate!.day}/${ctrl.startDate!.month}/${ctrl.startDate!.year}"
                            : "",
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: ctrl.startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) ctrl.setStartDate(picked);
                      },
                    ),
                    // TextButton(
                    //   onPressed: () async {
                    //     final picked = await showDatePicker(
                    //       context: context,
                    //       initialDate: ctrl.startDate ?? DateTime.now(),
                    //       firstDate: DateTime(2000),
                    //       lastDate: DateTime(2100),
                    //     );
                    //     if (picked != null) ctrl.setStartDate(picked);
                    //   },
                    //   child: Text(
                    //     ctrl.startDate != null
                    //         ? "${ctrl.startDate!.day}/${ctrl.startDate!.month}/${ctrl.startDate!.year}"
                    //         : "Select Start",
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // InputDatePickerFormField(
              //   firstDate: DateTime(2000),
              //   lastDate: DateTime(2100),
              //   initialDate: ctrl.startDate ?? DateTime.now(),
              //   onDateSubmitted: (date) => ctrl.setStartDate(date),
              //   onDateSaved: (date) => ctrl.setStartDate(date),
              // ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text("End Time"),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "endDate".tr,
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: ctrl.endDate != null
                            ? "${ctrl.endDate!.day}/${ctrl.endDate!.month}/${ctrl.endDate!.year}"
                            : "",
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: ctrl.endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) ctrl.setEndDate(picked);
                      },
                    ),
                    // TextButton(
                    //   onPressed: () async {
                    //     final picked = await showTimePicker(
                    //       context: context,
                    //       initialTime: ctrl.endTime ?? TimeOfDay.now(),
                    //     );
                    //     if (picked != null) ctrl.setEndTime(picked);
                    //   },
                    //   child: Text(
                    //     ctrl.endTime != null
                    //         ? ctrl.endTime!.format(context)
                    //         : "Select End",
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          );
        }
      },
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
        // controller.setSearchQuery(value); // Filter logic in controller
      },
    );
  }

  Widget _buildReportIdSelector() {
    return GetBuilder<ReportController>(
      builder: (ctrl) {
        return DropdownButtonFormField<Report>(
          decoration: InputDecoration(
            labelText: "selectReport".tr,
            border: OutlineInputBorder(),
          ),
          value: ctrl.selectedReport,
          items: ctrl.reports.map((report) {
            return DropdownMenuItem(
              value: report,
              child: Text("${report.name}"),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) ctrl.setSelectedReport(value);
          },
        );
      },
    );
  }

  // Widget _buildListView(ReportController ctrl) {
  //   final items = ctrl.reportItems;
  //   return ListView.separated(
  //     // padding: EdgeInsets.all(16),
  //     itemCount: ctrl.reportItems.length,
  //     separatorBuilder: (_, __) => SizedBox(height: 8),
  //     itemBuilder: (context, index) {
  //       final dto = ctrl.reportItems[index];
  //       return Card(
  //         margin: EdgeInsets.symmetric(vertical: 8),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: dto.fields.entries.map((entry) {
  //               final field = entry.value;

  //               // Determine text alignment
  //               TextAlign textAlign = TextAlign.left;
  //               if (field.alignment == 'right')
  //                 textAlign = TextAlign.right;
  //               else if (field.alignment == 'center')
  //                 textAlign = TextAlign.center;

  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 2),
  //                 child: Text(
  //                   '${entry.key}: ${field.value}',
  //                   textAlign: textAlign,
  //                   style: const TextStyle(fontSize: 16),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildListView(ReportController ctrl) {
  //   return ListView.separated(
  //     itemCount: ctrl.reportItems.length,
  //     separatorBuilder: (_, __) => const SizedBox(height: 8),
  //     itemBuilder: (context, index) {
  //       final dto = ctrl.reportItems[index];
  //       return Card(
  //         margin: const EdgeInsets.symmetric(vertical: 8),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: dto.fields.entries.map((entry) {
  //               final field = entry.value;
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 2),
  //                 child: Row(
  //                   mainAxisAlignment: field.alignment == 'right'
  //                       ? MainAxisAlignment.end
  //                       : field.alignment == 'center'
  //                       ? MainAxisAlignment.center
  //                       : MainAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       '${entry.key}: ',
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${field.value}',
  //                       style: const TextStyle(fontSize: 16),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  // Widget _buildListView(ReportController ctrl) {
  //   if (ctrl.reportItems.isEmpty) {
  //     return const Center(child: Text("No results found"));
  //   }

  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: ctrl.reportItems.map((group) {
  //         final headers = group.rows
  //             .expand((row) => row.fields.keys)
  //             .toSet()
  //             .toList();

  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             // Group title
  //             Container(
  //               color: Colors.blue[200],
  //               padding: const EdgeInsets.all(8),
  //               child: Text(
  //                 group.basliq,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             // Table header
  //             Container(
  //               color: Colors.blue[100],
  //               child: Row(
  //                 children: headers.map((h) {
  //                   return Container(
  //                     width: 120, // same as row cells
  //                     padding: const EdgeInsets.all(8.0),
  //                     decoration: BoxDecoration(
  //                       border: Border(
  //                         bottom: BorderSide(color: Colors.grey.shade300),
  //                         right: BorderSide(color: Colors.grey.shade300),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       h,
  //                       textAlign: TextAlign.center,
  //                       style: const TextStyle(fontWeight: FontWeight.bold),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //             // Table rows
  //             SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Column(
  //                 children: group.rows.map((row) {
  //                   return Row(
  //                     children: headers.map((h) {
  //                       final field = row.fields[h];
  //                       return Container(
  //                         width: 120, // fixed width for better alignment
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           border: Border(
  //                             bottom: BorderSide(color: Colors.grey.shade300),
  //                             right: BorderSide(color: Colors.grey.shade300),
  //                           ),
  //                         ),
  //                         child: Text('${field?.value}'),
  //                       );
  //                     }).toList(),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //           ],
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildListView(ReportController ctrl, BuildContext context) {
    if (ctrl.reportsFetched) {
      return Center(child: Text("notFound".tr));
    }

    return SingleChildScrollView(
      // scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ctrl.reportItems.map((group) {
          final rows = group.rows ?? [];
          if (rows.isEmpty) {
            //   // ✅ Skip this group entirely
            return const SizedBox.shrink();
          }
          final headers = group.rows
              .expand((row) => row.fields.keys)
              .toSet()
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group title
              Container(
                color: Colors.blue[200],
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Text(
                  group.basliq,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Table with horizontal scroll
              // Real Table with horizontal scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    // Header row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blue[100]),
                      children: headers.map((h) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            h,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),

                    // Data rows
                    if (rows.isNotEmpty)
                      ...rows.map((row) {
                        return TableRow(
                          children: headers.map((h) {
                            final field = row.fields[h];
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                field?.value?.toString() ?? '',
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                        );
                      }),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
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

  Widget _buildGridView(ReportController ctrl, BuildContext context) {
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
      itemCount: ctrl.filteredReports.length,
      itemBuilder: (context, index) {
        final customer = ctrl.filteredReports[index];
        return InkWell(
          onTap: () {
            // Navigate to detail page
            // Get.to(() => CustomerDetailPage(customer: customer));
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
                      customer.name,
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
