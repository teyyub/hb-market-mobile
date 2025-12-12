import 'package:decimal/decimal.dart';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/baza_duzelt_module/controller/say_duzelt_controller.dart';
import 'package:hbmarket/modules/baza_duzelt_module/models/say_duzelt_request.dart';
import 'package:hbmarket/modules/baza_duzelt_module/pages/keyboard.dart';

import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/partnyor_module/pages/barcode_scanner_page.dart';
import 'package:hbmarket/modules/raport_module/controller/report_controller.dart';

class SayDuzeltPage extends StatelessWidget {
  final ReportController controller = Get.find<ReportController>();
  final ObyektController obyController = Get.find<ObyektController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'sayduzelt'.tr,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(children: [_buildTopControls(context)]),
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    return GetBuilder<SayDuzeltController>(
      builder: (SayDuzeltController ctrl) {
        return Card(
          color: Colors.blue[50],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIdRow(ctrl),
                  const SizedBox(height: 10),
                  _buildBarcodeRow(ctrl),
                  const SizedBox(height: 10),
                  _buildBarcodeButtonRow(ctrl),
                  const SizedBox(height: 10),
                  _buildCalcRow(context, ctrl),
                  const SizedBox(height: 10),
                  _buildOkRow(context, ctrl),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 400, // or whatever height you want for your keyboard
                    child: _buildKeyboard(context, ctrl),
                  ),
                  // _buildKeyboard(context, ctrl),
                  // Expanded(child: _buildKeyboard(context, ctrl)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIdRow(SayDuzeltController ctrl) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ctrl.idController,
            focusNode: ctrl.idFocus,
            keyboardType: TextInputType.none,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'hereket',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _focusAndSelectAll(ctrl.idController, ctrl.idFocus),
          child: const Text("Hərəkət"),
        ),
      ],
    );
  }

  Widget _buildBarcodeRow(SayDuzeltController ctrl) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ctrl.barcodeController,
            focusNode: ctrl.barcodeFocus,
            decoration: InputDecoration(
              hintText: 'Barkod',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      final code = await Get.to(
                        () => const BarcodeScannerPage(),
                      );
                      if (code != null) {
                        ctrl.barcodeController.text = code;
                        _searchBarcode(ctrl);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchBarcode(ctrl);
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   _focusAndSelectAll(ctrl.txtController, ctrl.txtFocus);
                      // });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeButtonRow(SayDuzeltController ctrl) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                _focusAndSelectAll(ctrl.barcodeController, ctrl.barcodeFocus);
                ctrl.txtController.clear();
              },
              child: const FittedBox(child: Text("Barkod")),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalcRow(BuildContext context, SayDuzeltController ctrl) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: ctrl.txtController,
              focusNode: ctrl.txtFocus,
              keyboardType: TextInputType.none,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true, // makes input smaller vertically
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                ctrl.txtController.text = calculateExpression(
                  ctrl.txtController.text,
                ).toString();
                // try {
                //   final expression = Expression.parse(ctrl.txtController.text);
                //   final evaluator = const ExpressionEvaluator();
                //   final result = evaluator.eval(expression, {});
                //   ctrl.txtController.text = result.toString();
                // } catch (_) {
                //   ctrl.txtController.text = '0';
                // }
              },
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("Calc"),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                final value = calculateExpression(ctrl.txtController.text);
                final dto = SayDuzeltRequest(
                  id: int.tryParse(ctrl.idController.text) ?? 0,
                  barcode: ctrl.barcodeController.text.trim(),
                  remain: value,
                );
                ctrl.duzelt(dto);
                ctrl.txtController.clear();
                ctrl.barcodeController.clear();
                FocusScope.of(context).requestFocus(ctrl.barcodeFocus);
              },
              child: const FittedBox(fit: BoxFit.scaleDown, child: Text("OK")),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOkRow(BuildContext context, SayDuzeltController ctrl) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                final dto = SayDuzeltRequest(
                  id: int.tryParse(ctrl.idController.text) ?? 0,
                  barcode: ctrl.barcodeController.text.trim(),
                  remain: Decimal.tryParse(ctrl.txtController.text.trim()),
                );
                ctrl.duzelt(dto);
                ctrl.txtController.clear();
                ctrl.barcodeController.clear();
                FocusScope.of(context).requestFocus(ctrl.barcodeFocus);
              },
              child: const Text("OK"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboard(BuildContext context, SayDuzeltController ctrl) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: NumberSymbolKeyboard(
        onKeyPressed: (String key) {
          final controller = ctrl.activeController;
          if (controller == null) return;

          final text = controller.text;
          final selection = controller.selection;
          final start = selection.start >= 0 ? selection.start : text.length;
          final end = selection.end >= 0 ? selection.end : text.length;

          switch (key) {
            case '⌫':
              if (start != end) {
                controller.text = text.replaceRange(start, end, '');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: start),
                );
              } else if (start > 0) {
                final newStart = start - 1;
                controller.text = text.replaceRange(newStart, start, '');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: newStart),
                );
              }
              break;
            case '✖':
              controller.clear();
              break;
            case '⏎':
              _searchBarcode(ctrl);
              break;
            default:
              if (controller == ctrl.idController &&
                  !RegExp(r'\d').hasMatch(key))
                return;

              final newText = text.replaceRange(start, end, key);
              controller.text = newText;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: start + key.length),
              );
          }
        },
      ),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ), // Body
              Expanded(
                child: GetBuilder<ObyektController>(
                  builder: (ObyektController ctrl) {
                    if (ctrl.obyekts.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      itemCount: ctrl.obyekts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
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
                          itemBuilder: (BuildContext context, int index) {
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

  Widget _buildTimeSelectors(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (ctrl) {
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
      },
    );
  }

  void _focusAndSelectAll(
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    FocusScope.of(Get.context!).requestFocus(focusNode);
    Future.delayed(const Duration(milliseconds: 50), () {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    });
    // controller.selection = TextSelection(
    //   baseOffset: 0,
    //   extentOffset: controller.text.length,
    // );
  }

  void _searchBarcode(SayDuzeltController ctrl) async {
    final dto = SayDuzeltRequest(
      id: int.tryParse(ctrl.idController.text.trim()) ?? 0,
      barcode: ctrl.barcodeController.text.trim(),
    );
    final result = await ctrl.qaliq(dto);
    if (result != null) {
      ctrl.txtController.text = result
          .toString(); // put fetched value in txtController
      // _focusAndSelectAll(ctrl.txtController, ctrl.txtFocus); // select all text
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusAndSelectAll(ctrl.txtController, ctrl.txtFocus);
      });
    }
  }

  Decimal calculateExpression(String input) {
    try {
      final expression = Expression.parse(input);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      return Decimal.tryParse(result.toString()) ?? Decimal.zero;
    } catch (_) {
      return Decimal.zero;
    }
  }
}
