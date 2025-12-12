// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:hbmarket/modules/baza_duzelt_module/pages/keyboard.dart';
// import 'package:hbmarket/modules/common/utils/validator.dart';
// import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
// import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
// import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
// import 'package:hbmarket/modules/hereket_module/controller/apply_controller.dart';
// import 'package:hbmarket/modules/hereket_module/controller/hereket_plani_controller.dart';
// import 'package:hbmarket/modules/hereket_module/controller/hereket_work_controller.dart';
// import 'package:hbmarket/modules/hereket_module/models/apply_dto.dart';
// import 'package:hbmarket/modules/hereket_module/models/daime.dart';
// import 'package:hbmarket/modules/hereket_module/models/f1_dto.dart';
// import 'package:hbmarket/modules/hereket_module/models/hereket_request.dart';
// import 'package:hbmarket/modules/hereket_module/models/work_item.dart';
// import 'package:hbmarket/modules/hereket_module/widget/apply_widget.dart';
// import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
// import 'package:trina_grid/trina_grid.dart';
//
// import '../../common/widgets/custom_keyboard.dart';
// import '../../partnyor_module/pages/barcode_scanner_page.dart';
// import '../models/hereket_dplan.dart';
// import 'f1_widget.dart';
//
// class WorkWidget_bkp1 extends StatefulWidget {
//   final void Function(HereketRequest dto) onSave;
//   final int? obyektId;
//   final int dPlanId;
//   final int hereketId;
//   final HereketRequest? initial;
//   const WorkWidget_bkp1({
//     super.key,
//     this.obyektId,
//     required this.hereketId,
//     required this.dPlanId,
//     required this.onSave,
//     this.initial,
//   });
//   @override
//   State<WorkWidget_bkp1> createState() => _WorkWidgetState();
// }
//
// class _WorkWidgetState extends State<WorkWidget_bkp1> {
//   final HereketWorkController hereketWorkCtrl =
//       Get.find<HereketWorkController>();
//   final ApplyController applyCtrl = Get.find<ApplyController>();
//   final obyektCtrl = Get.find<ObyektController>();
//   final ScrollController scrollCtrl = ScrollController();
//   final FocusNode searchFocusNode = FocusNode();
//   final FocusNode amountFocus = FocusNode();
//   final FocusNode rQiymetFocus = FocusNode();
//   //
//   bool allowKeyboard = false;
//   bool showClear = false;
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void _setupFocusListeners() {
//     amountFocus.addListener(_onAmountFocus);
//     rQiymetFocus.addListener(_onRQiymetFocus);
//     searchFocusNode.addListener(_onSearchFocus);
//   }
//
//   void _onAmountFocus() {
//     if (amountFocus.hasFocus) {
//       hereketWorkCtrl.setActiveController(hereketWorkCtrl.amountController);
//       _scrollToEnd();
//     }
//   }
//
//   void _onRQiymetFocus() {
//     if (rQiymetFocus.hasFocus) {
//       hereketWorkCtrl.setActiveController(hereketWorkCtrl.rController);
//     }
//   }
//
//   void _onSearchFocus() {
//     if (searchFocusNode.hasFocus) {
//       hereketWorkCtrl.setActiveController(
//         hereketWorkCtrl.searchItemController,
//       );
//     }
//   }
//
//   void _setupSearchListener() {
//     // searchItemCtrl.addListener(_onSearchTextChanged);
//     hereketWorkCtrl.searchItemController.addListener(_onSearchTextChanged);
//   }
//
//   void _onSearchTextChanged() {
//     setState(() {
//       // showClear = searchItemCtrl.text.isNotEmpty;
//       showClear = hereketWorkCtrl.searchItemController.text.isNotEmpty;
//     });
//   }
//
//   void _setupAmountFocusRequest() {
//     hereketWorkCtrl.onAmountFocusRequested = () {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         amountFocus.requestFocus();
//       });
//     };
//   }
//
//   void _scrollToEnd() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       scrollCtrl.animateTo(
//         scrollCtrl.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   void _scrollToTop() {
//     scrollCtrl.animateTo(
//       0,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _init() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       hereketWorkCtrl.loadConfigNew(widget.hereketId.toString());
//       // await Future.wait([hereketWorkCtrl.reset()]);
//       // await hereketWorkCtrl.reset();
//
//       // hereketWorkCtrl
//       // ..setSearchItemController(searchItemCtrl)
//       // ..setSearchItemController(hereketWorkCtrl.searchItemController)
//       //   ..setRController(rQiymetCtrl)
//       //   ..setAmountController(amountController)
//       //   ..setNoteController(noteController);
//       // ✅ Only after data is loaded, initialize UI
//       // _initFromInitial();
//
//
//       _setupFocusListeners();
//       _setupSearchListener();
//       _setupAmountFocusRequest();
//       searchFocusNode.requestFocus();
//       hereketWorkCtrl.setNoteText('Multi');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final double height = MediaQuery.of(context).size.height * 0.8;
//     return SizedBox(
//       // height: height, // bounded height
//       child: SingleChildScrollView(
//         controller: hereketWorkCtrl.scrollCtrl,
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             GetBuilder<HereketWorkController>(
//               builder: (HereketWorkController ctrl) {
//                 return DropdownSelector<WorkItem>(
//                   label: ''.tr,
//                   selectedValue: ctrl.selectedWorkItem,
//                   items: ctrl.workItems,
//                   itemLabel: (WorkItem r) => r.name,
//                   onChanged: (WorkItem r) {
//                     // searchItemCtrl.text = '';
//                     ctrl.searchItemController.clear();
//                     ctrl.setSelectedWorkItem(r);
//                     ctrl.searchFocusNode.requestFocus();
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 6),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GetBuilder<HereketWorkController>(
//                   builder: (HereketWorkController ctrl) {
//                     // final bool isBarcode = ctrl.selectedWorkItem?.name.toLowerCase() == 'barkod';
//                     // final bool onlyNumbers =
//                     //     ctrl.selectedWorkItem?.name == 'No';
//                     return Expanded(
//                       child: TextField(
//                         // controller: searchItemCtrl,
//                         controller: ctrl.searchItemController,
//                         focusNode: ctrl.searchFocusNode,
//                         readOnly:
//                             ctrl.isBarcode &&
//                             !allowKeyboard, // barkod seçilib, allowKeyboard false → klaviatura gizli
//                         showCursor: true,
//                         autofocus: true,
//                         keyboardType: ctrl.onlyNumbers
//                             ? TextInputType.number
//                             : TextInputType.text,
//                         inputFormatters: ctrl.onlyNumbers
//                             ? [
//                                 FilteringTextInputFormatter.digitsOnly,
//                               ] // allow only numbers
//                             : [],
//
//                         decoration: InputDecoration(
//                           labelText: 'Axtarmaq ücün yazın'.tr,
//                           border: const OutlineInputBorder(),
//                           suffixIcon: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               if (ctrl.isBarcode)
//                                 SizedBox(
//                                   width: 48,
//                                   child: IconButton(
//                                     icon: const Icon(Icons.qr_code_scanner),
//                                     onPressed: () async {
//                                       final scannedBarcode = await Get.to(
//                                         () => const BarcodeScannerPage(),
//                                       );
//                                       if (scannedBarcode != null) {
//                                         // searchItemCtrl.text = scannedBarcode;
//                                         ctrl.searchItemController.text =
//                                             scannedBarcode;
//                                         ctrl.setSearchQuery(
//                                           // searchItemCtrl.text,
//                                           scannedBarcode,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               SizedBox(
//                                 width: 48,
//                                 child: IconButton(
//                                   icon: const Icon(Icons.search),
//                                   onPressed: () {
//                                     // ctrl.setSearchQuery(searchItemCtrl.text);
//                                     performSearch(ctrl.searchItemController.text);
//                                   },
//                                 ),
//                               ),
//                               if (showClear)
//                                 IconButton(
//                                   icon: const Icon(Icons.clear),
//                                   onPressed: () {
//                                     // searchItemCtrl.clear();
//                                     ctrl.searchItemController.clear();
//                                     ctrl.clearQaimeler();
//                                   },
//                                 ),
//                             ],
//                           ),
//                         ),
//                         onSubmitted: (String value) {
//                           performSearch(value);
//                         },
//                         textInputAction: TextInputAction.search,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 2),
//             SizedBox(
//               height: 200,
//               child: GetBuilder<HereketWorkController>(
//                 builder: (HereketWorkController ctrl) {
//                   if (ctrl.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   // if (ctrl.qaimeler.length == 1) {
//                   //   Future.delayed(const Duration(milliseconds: 100), () {
//                   //     ctrl.amountFocus.requestFocus();
//                   //   });
//                   // }
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     if (ctrl.qaimeler.length == 1) {
//                       FocusScope.of(context).requestFocus(ctrl.amountFocus);
//                     }
//                   });
//                   return _buildTrinaGrid(ctrl);
//                 },
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // hereketWorkCtrl.applyR(rQiymetCtrl);
//                     hereketWorkCtrl.applyR();
//                     // hereketWorkCtrl.amountFocus.requestFocus();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.all(2), // reduce internal padding
//                   ),
//                   child: const Text('R'),
//                 ),
//                 const SizedBox(width: 2),
//                 Expanded(
//                   flex: 2,
//                   child: TextField(
//                     // controller: amountController,
//                     controller: hereketWorkCtrl.amountController,
//                     focusNode: hereketWorkCtrl.amountFocus,
//                     keyboardType: TextInputType.none,
//                     // keyboardType: const TextInputType.numberWithOptions(
//                     //   decimal: true,
//                     // ),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(
//                         RegExp(r'^\d*\.?\d{0,2}'),
//                       ),
//                       // optional: allows up to 2 decimal places
//                     ],
//                     decoration: InputDecoration(
//                       labelText: 'Miqdar'.tr,
//                       border: const OutlineInputBorder(),
//                       isDense: true,
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 4,
//                         horizontal: 8,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 2),
//                 Expanded(
//                   flex: 2,
//                   child: GetBuilder<HereketWorkController>(
//                     builder: (HereketWorkController ctrl) {
//                       return DropdownSelector<String>(
//                         label: 'Qiymət'.tr,
//                         selectedValue: ctrl.selectedBasliqItem,
//                         items: ctrl.fieldMapping.keys.toList(),
//                         itemLabel: (r) => r,
//                         onChanged: (r) {
//                           ctrl.setSelectedBasliqItem(r);
//                           // ctrl.applyR(rQiymetCtrl);
//                           ctrl.applyR();
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 2),
//                 Expanded(
//                   flex: 2,
//                   child: TextField(
//                     // controller: rQiymetCtrl,
//                     controller: hereketWorkCtrl.rController,
//                     focusNode: hereketWorkCtrl.rQiymetFocus,
//                     keyboardType: TextInputType.none,
//                     // keyboardType: const TextInputType.numberWithOptions(
//                     //   decimal: true,
//                     // ),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(
//                         RegExp(r'^\d*\.?\d{0,2}'),
//                       ),
//                       // optional: allows up to 2 decimal places
//                     ],
//                     decoration: InputDecoration(
//                       labelText: 'Qiymət'.tr,
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: TextField(
//                     // controller: noteController,
//                     controller: hereketWorkCtrl.noteController,
//                     keyboardType: const TextInputType.numberWithOptions(
//                       decimal: true,
//                     ),
//                     decoration: InputDecoration(
//                       labelText: 'Qeyd'.tr,
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               // crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: GetBuilder<HereketWorkController>(
//                     builder: (HereketWorkController ctrl) {
//                       return CustomKeyboard(
//                         controller: ctrl.activeController!,
//                         onSubmit: (String value) {
//                           print('Submitted: $value');
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 2),
//                 Expanded(child: _rightSideOfKeyboard()),
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   void performSearch(String query) {
//     if (query.trim().isEmpty) return;
//     hereketWorkCtrl.setSelectedObyektId = widget.obyektId;
//     hereketWorkCtrl.setSearchQuery(query);
//   }
//
//   Widget _rightSideOfKeyboard() {
//     return GetBuilder<HereketWorkController>(
//       builder: (HereketWorkController ctrl) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // TextField(
//             //   controller: noteController,
//             //   keyboardType: const TextInputType.numberWithOptions(
//             //     decimal: true,
//             //   ),
//             //   decoration: InputDecoration(
//             //     labelText: 'Qeyd'.tr,
//             //     border: const OutlineInputBorder(),
//             //   ),
//             // ),
//             // const SizedBox(height: 12),
//             Row(
//               mainAxisSize: MainAxisSize.min, // wrap content
//               children: [
//                 Checkbox(
//                   value: ctrl.auto,
//                   onChanged: (bool? value) => ctrl.setAuto = value!,
//                 ),
//                 const SizedBox(width: 4), // tiny space between box and label
//                 const Text("Auto 1"),
//               ],
//             ),
//
//             const SizedBox(height: 6),
//             ElevatedButton(
//               onPressed: () {
//                 ctrl.saveConfigNew(widget.hereketId.toString());
//               },
//               child: const Text('Config'),
//             ),
//
//             const SizedBox(height: 6),
//             DropdownButton<String>(
//               value: ctrl.getSelectedValue,
//               items: const [
//                 DropdownMenuItem(value: '1', child: Text('Apply')),
//                 DropdownMenuItem(value: '2', child: Text('Add')),
//                 DropdownMenuItem(value: '3', child: Text('F1')),
//               ],
//               onChanged: (String? value) {
//                 if(value!=null) {
//                   ctrl.setSelectedValue(value);
//                 }
//                 debugPrint('Selected: $value');
//               },
//               // onChanged: (String? value) {
//               //   setState(() {
//               //     ctrl.selectedValue = value!;
//               //   });
//               //   debugPrint('Selected: $value');
//               // },
//             ),
//
//             const SizedBox(height: 6),
//
//             ElevatedButton(
//               onPressed: () {
//                 // debugPrint('hereketWorkCtrl.selectedValue ${hereketWorkCtrl.selectedValue}');
//                 //eger add secilibse
//                 if (hereketWorkCtrl.getSelectedValue == '2') {
//                   ctrl.handleOk(
//                     hereketId: widget.hereketId,
//                     dPlanId: widget.dPlanId,
//                   );
//                   FocusScope.of(context).requestFocus(hereketWorkCtrl.searchFocusNode);
//                 } else if (hereketWorkCtrl.getSelectedValue == '1') {
//                   final applyDto = hereketWorkCtrl.createApplyDto(
//                     widget.hereketId,
//                     widget.dPlanId,
//                   );
//                   if (applyDto != null) {
//                     Get.bottomSheet(
//                       ApplyWidget(
//                         applyRequestDto: applyDto,
//                         onNullSave: () {
//                           final dtoSave = hereketWorkCtrl.createHereketDPlan();
//                           if (dtoSave != null) ctrl.ok(dtoSave);
//                         },
//                       ),
//                       isScrollControlled: true,
//                       backgroundColor: Colors.white,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(20),
//                         ),
//                       ),
//                     );
//                     // Get.to(() => const ApplyWidget());
//                   }
//                 } else {
//                   final f1Dto = hereketWorkCtrl.createF1Dto();
//                   Get.bottomSheet<HereketDPlan>(
//                     F1Widget(f1RequestDto: f1Dto),
//                     isScrollControlled: true,
//                     backgroundColor: Colors.white,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(20),
//                       ),
//                     ),
//                   ).then((HereketDPlan? dtoSave) {
//                     if (dtoSave != null) {
//                       final updatedDto = dtoSave.copyWith(
//                         dPlanId: widget.dPlanId,
//                         hereketId: widget.hereketId,
//                         note: hereketWorkCtrl
//                             .noteController
//                             .text, // burda yeni note verirsən
//                         amount: dtoSave.amount,
//                         price: dtoSave.price,
//                         sellPrice: dtoSave.sellPrice,
//                       );
//                       ctrl.ok(updatedDto);
//                     }
//                   });
//                 }
//               },
//               child: const Text('Ok'),
//             ),
//             const SizedBox(height: 6),
//             ElevatedButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: const Text('Cix'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//
//   Widget _buildTrinaGrid(HereketWorkController ctrl) {
//     final visibleColumns = ctrl.columns.where((c) => c['visible']).toList();
//     final displayColumns = visibleColumns.isNotEmpty
//         ? visibleColumns
//         : [
//             {'key': 'placeholder', 'label': 'Boşdur', 'visible': true},
//           ];
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Row(
//               children: [
//                 Checkbox(
//                   value: ctrl.sag, // or a state variable like isChecked1
//                   onChanged: (bool? value) {
//                     ctrl.setSag = value!;
//                   },
//                 ),
//                 const Text('%'),
//               ],
//             ),
//
//             const SizedBox(width: 1),
//
//             Row(
//               children: <Widget>[
//                 const Text('%'),
//                 Checkbox(
//                   value: ctrl.sol, // or a state variable like isChecked1
//                   onChanged: (bool? value) {
//                     ctrl.setSol = value!;
//                   },
//                 ),
//               ],
//             ),
//
//             const SizedBox(width: 2),
//             // if (isBarcode)
//             IconButton(
//               icon: Icon(
//                 allowKeyboard ? Icons.keyboard : Icons.keyboard_hide,
//                 color: allowKeyboard ? Colors.green : Colors.grey,
//               ),
//               onPressed: () {
//                 setState(() {
//                   allowKeyboard = !allowKeyboard;
//                   if (allowKeyboard) {
//                     ctrl.searchFocusNode.requestFocus();
//                   } else {
//                     ctrl.searchFocusNode.unfocus();
//                   }
//                 });
//               },
//             ),
//             ColumnVisibilityMenu(
//               columns: ctrl.columns,
//               onChanged: (String key, bool visible) =>
//                   ctrl.toggleColumnVisibilityExplicit(key, visible),
//             ),
//           ],
//         ),
//         const SizedBox(height: 2),
//
//         Expanded(
//           child: TrinaGridWidget<QaimeDto>(
//             key: ValueKey(
//               ctrl.columns.map((Map<String, dynamic> c) => c['visible']).join(),
//             ),
//             data: ctrl.qaimeler,
//             selectedId: ctrl.selectedObyekt?.id,
//             // onSelect: ctrl.selectPartnyor,
//             onSelect: (QaimeDto item) {
//               ctrl.setSelectedQaimeDto(
//                 item,
//               ); // works even if ID column is hidden
//             },
//
//             getId: (p) => p.id!,
//             columns: displayColumns,
//             cellBuilder: (p) {
//               final Map<String, TrinaCell> cells = {};
//
//               // cells['id'] = TrinaCell(value: p.id.toString());
//               // debugPrint('${displayColumns.length}');
//               for (final c in displayColumns) {
//                 // debugPrint('${c['key']}');
//                 switch (c['key']) {
//                   case 'id':
//                     cells['id'] = TrinaCell(value: p.id);
//                     break;
//                   case 'satis':
//                     cells['satis'] = TrinaCell(value: p.satis);
//                     break;
//                   // case 'satis1':
//                   //   cells['satis1'] = TrinaCell(value: p.satis1);
//                   //   break;
//                   case 'satis2':
//                     cells['satis2'] = TrinaCell(value: p.satis2);
//                     break;
//                   case 'satis3':
//                     cells['satis3'] = TrinaCell(value: p.satis3);
//                     break;
//                   case 'satis4':
//                     cells['satis4'] = TrinaCell(value: p.satis3);
//                     break;
//                   case 'satis5':
//                     cells['satis5'] = TrinaCell(value: p.satis3);
//                     break;
//                   case 'satis6':
//                     cells['satis6'] = TrinaCell(value: p.satis3);
//                     break;
//                   case 'alis':
//                     cells['alis'] = TrinaCell(value: p.alis);
//                     break;
//                   case 'alis0':
//                     cells['alis0'] = TrinaCell(value: p.alis0);
//                     break;
//                   // case 'alis1':
//                   //   cells['alis1'] = TrinaCell(value: p.alis1);
//                   //   break;
//                   // case 'alis2':
//                   //   cells['alis2'] = TrinaCell(value: p.alis2);
//                   //   break;
//                   case 'name':
//                     cells['name'] = TrinaCell(value: p.ad);
//                     break;
//                   case 'seri':
//                     cells['seri'] = TrinaCell(value: p.barkod);
//                     break;
//                   default:
//                     cells[c['key']] = TrinaCell(value: '');
//                     break;
//                 }
//               }
//
//               return cells;
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildKeyboard(BuildContext context, HereketPlaniController ctrl) {
//     // final height = MediaQuery.of(context).size.height;
//     // final isSmallScreen = height < 700;
//     // return SizedBox(
//     //   width: double.infinity,
//     //   height: isSmallScreen ? height * 0.35 : height * 0.45,
//     // padding: const EdgeInsets.symmetric(horizontal: 8),
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: NumberSymbolKeyboard(
//         onKeyPressed: (String key) {
//           final controller = ctrl.activeController;
//           if (controller == null) return;
//
//           final text = controller.text;
//           final selection = controller.selection;
//           final start = selection.start >= 0 ? selection.start : text.length;
//           final end = selection.end >= 0 ? selection.end : text.length;
//
//           switch (key) {
//             case '⌫':
//               if (start != end) {
//                 controller.text = text.replaceRange(start, end, '');
//                 controller.selection = TextSelection.fromPosition(
//                   TextPosition(offset: start),
//                 );
//               } else if (start > 0) {
//                 final newStart = start - 1;
//                 controller.text = text.replaceRange(newStart, start, '');
//                 controller.selection = TextSelection.fromPosition(
//                   TextPosition(offset: newStart),
//                 );
//               }
//               break;
//             case '✖':
//               controller.clear();
//               break;
//             case '⏎':
//             // controller.
//               break;
//             default:
//             // if (controller == ctrl.idController &&
//             //     !RegExp(r'\d').hasMatch(key))
//             //   return;
//
//               final newText = text.replaceRange(start, end, key);
//               controller.text = newText;
//               controller.selection = TextSelection.fromPosition(
//                 TextPosition(offset: start + key.length),
//               );
//           }
//         },
//       ),
//     );
//   }
// }
