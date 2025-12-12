import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/common/utils/validator.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/hereket_module/controller/hereket_work_controller.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_request.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/BarcodeAddDto.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import '../../common/widgets/custom_keyboard.dart';
import '../models/mal_yoxla.dart';


class AddBarcodeWidget extends StatefulWidget {
  final void Function(HereketRequest dto) onSave;
  final int id;
  final String barcode;
  final String name;
  final MalYoxla malYoxla;
  const AddBarcodeWidget({
    super.key,
    required this.id,
    required this.barcode,
    required this.name,
    required this.malYoxla,
    required this.onSave,

  });
  @override
  State<AddBarcodeWidget> createState() => _AddBarcodeWidgetState();
}

class _AddBarcodeWidgetState extends State<AddBarcodeWidget> {
  final FocusNode searchFocusNode = FocusNode();
  final amountFocus = FocusNode();
  final priceFocus = FocusNode();


  final amountController = TextEditingController();
  final priceCtrl = TextEditingController();
  final searchItemCtrl = TextEditingController();


  final malCtrl = Get.find<MalYoxlaController>();
  final obyektCtrl = Get.find<ObyektController>();



  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      amountFocus.requestFocus();   // 🔥 açılan kimi fokus buradadır
      malCtrl.setActiveController(amountController);
      if (priceCtrl!.text.isEmpty && malCtrl.selectedMalYoxla != null) {
        final field = malCtrl.fieldMapping[malCtrl.selectedBasliqItem];
        priceCtrl!.text = malCtrl.getSelectedPriceValue(field);
      }
      malCtrl.setActiveController(amountController);

    amountFocus.addListener(() {
      if (amountFocus.hasFocus) {
        malCtrl.setActiveController(amountController);
      }
    });

    priceFocus.addListener(() {
      if (priceFocus.hasFocus) {
        malCtrl.setActiveController(priceCtrl);
      }
    });

    });
  }


  void _initFromInitial() {
    // debugPrint('widget.initial .. ${widget.initial?.toJson()}');
    // final initial = widget.initial;
    // if (initial == null) return;

    // amountController.text = initial.percentage.toString();
    // noteController.text = initial.note.toString();

    // final selectedHereket = hereketCtrl.hereketDtos.firstWhereOrNull(
    //   (h) => h.id == initial.hereketId,
    // );
    // final selectedObyekt = obyektCtrl.obyekts.firstWhereOrNull(
    //   (o) => o.id == initial.obyektId,
    // );
    // final selectedPartnyor = partnyorCtrl.partnyors.firstWhereOrNull(
    //   (p) => p.id == initial.partnyorId,
    // );

    // if (selectedHereket != null) {
    //   hereketCtrl.setSelectedHereketDto(selectedHereket);
    // }
    // if (selectedObyekt != null) {
    //   hereketCtrl.setSelectedObyekt(selectedObyekt);
    // }
    // if (selectedPartnyor != null) {
    //   hereketCtrl.setSelectedPartnyor(selectedPartnyor);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.9;

    return SizedBox(
      height: height, // bounded height
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 2),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: amountController,
                    focusNode: amountFocus,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                      // optional: allows up to 2 decimal places
                    ],
                    decoration: InputDecoration(
                      hintText: 'Say'.tr,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 2,
                  child: GetBuilder<MalYoxlaController>(
                    builder: (MalYoxlaController ctrl) {
                      return DropdownSelector<String>(
                        label: 'Qiymət'.tr,
                        selectedValue: ctrl.selectedBasliqItem,
                        items: ctrl.fieldMapping.keys.toList(),
                        itemLabel: (r) => r,
                        onChanged: (r) {
                            ctrl.setSelectedBasliqItem(r);
                            final field = ctrl.fieldMapping[r];
                            priceCtrl?.text = ctrl.getSelectedPriceValue(field);
                        }
                      );
                    },
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: priceCtrl,
                    focusNode: priceFocus,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                      // optional: allows up to 2 decimal places
                    ],
                    decoration: InputDecoration(
                      hintText: 'Qiymət'.tr,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child:GetBuilder<MalYoxlaController>(
                      builder: (MalYoxlaController ctrl) {
                        return CustomKeyboard(
                              controller: ctrl.activeController!,
                              onSubmit: (String value) {
                              },
                            );
                        })

                ),
                const SizedBox(width: 8),
                Expanded(child: _rightSideOfKeyboard()),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void performSearch(String query) {
    // hereketWorkCtrl.setSelectedObyektId = widget.obyektId;
    // hereketWorkCtrl.setSearchQuery(query);
  }

  Widget _rightSideOfKeyboard() {
    return GetBuilder<MalYoxlaController>(
      builder: (MalYoxlaController ctrl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {



                  if (!Validators.number(amountController, "Miqdar düzgün daxil edilməyib!")) return;

                    if (!Validators.number(priceCtrl, "Qiymət düzgün daxil edilməyib!")) return;


                  //if (!Validators.show(ctrl.selectedQaimeDto != null, "Əməliyyat üçün mal seçilməyib!",)) return;

                  final int? amount = int.tryParse(amountController.text);
                  final double? price = double.tryParse(priceCtrl.text);


                  final BarcodeAddDto dto = BarcodeAddDto(
                      id:widget.id,
                      amount: amount,
                      barcode: widget.barcode,
                      name: widget.name,
                      price:price,
                      oz1: widget.malYoxla.oz1,
                      oz2: widget.malYoxla.oz2,
                      oz3: widget.malYoxla.oz3,
                      oz4: widget.malYoxla.oz4,
                  );
                  ctrl.add(dto);
                  Get.back();
              },
              child: const Text('ok'),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
            onPressed: () {
              Get.back();
            },
              child: const Text('Çıx'),
            )
          ],
        );
      },
    );
  }



}
