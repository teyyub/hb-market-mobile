import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hbmarket/modules/common/widgets/auto_complete_selector.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/radio_group.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/category_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/qeyd_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/controller/xercqazanc_controller.dart';

class YeniXercDialog extends StatelessWidget {
  final amountController = TextEditingController();
  final paysController = TextEditingController();
  // final phoneController = TextEditingController();
  final partnyorCtrl =
      Get.find<PartnyorController>(); // Get the existing controller
  // final KassaController kassaController = Get.put(KassaController());
  final XercQazancController xercQazancController =
      Get.find<XercQazancController>();
  final KassaController kassaController = Get.find<KassaController>();
  final void Function(XercRequestDto dto) onSave;
  final int mustId;
  final XercRequestDto? initial;
  YeniXercDialog({
    super.key,
    required this.mustId,
    required this.onSave,
    this.initial,
  }) {
    amountController.addListener(() {
      paysController.text = amountController.text;
    });
  }
  @override
  Widget build(BuildContext context) {
    // if (initial != null) {
    //   amountController.text = initial!.amount?.toString() ?? '';
    //   paysController.text = initial!.pays?.toString() ?? '';
    // }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<KassaController>(
          builder: (ctrl) {
            return DropdownSelector<Kassa>(
              label: 'selectKassa'.tr,
              selectedValue: ctrl.selectedKassa,
              items: ctrl.kassa,
              itemLabel: (r) => r.ad,
              onChanged: (r) => ctrl.setSelectedKassa(r),
            );
          },
        ),
        const SizedBox(height: 12),
        GetBuilder<KassaController>(
          builder: (ctrl) {
            return DropdownSelector<Category>(
              label: 'Kat.'.tr,
              selectedValue: ctrl.selectedCategory,
              items: ctrl.categories,
              itemLabel: (r) => r.ad,
              onChanged: (r) => ctrl.setSelectedCategory(r),
            );
          },
        ),
        const SizedBox(height: 12),
        GetBuilder<KassaController>(
          builder: (ctrl) {
            return DropdownSelector<Category>(
              label: 'Alt k.'.tr,
              selectedValue: ctrl.selectedSubCategory,
              items: ctrl.subCategories,
              itemLabel: (r) => r.ad,
              onChanged: (r) => ctrl.setSelectedSubCategory(r),
            );
          },
        ),
        const SizedBox(height: 12),
        GetBuilder<KassaController>(
          builder: (ctrl) {
            return AutocompleteSelector<Qeyd>(
              label: 'Səbəb'.tr,
              selectedItem: ctrl.selectedSebeb,
              items: ctrl.sebebs,
              itemLabel: (r) => r.ad,
              onSelected: (r) => ctrl.setSelectedSebeb(r),
              onNewItem: (typedText) {
                print(typedText);
                ctrl.setTypedSebeb(typedText); // 👈 new method
              },
            );
          },
        ),

        const SizedBox(height: 12),
        GetBuilder<KassaController>(
          builder: (ctrl) {
            final currentQeyd =
                ctrl.selectedQeyd ??
                (ctrl.typedQeyd != null
                    ? Qeyd(id: 0, ad: ctrl.typedQeyd!)
                    : null);
            return AutocompleteSelector<Qeyd>(
              label: 'Qeyd'.tr,
              items: ctrl.qeyds,
              selectedItem: currentQeyd,
              itemLabel: (r) => r.ad,
              onSelected: (r) => ctrl.setSelectedQeyd(r),

              onNewItem: (typedText) {
                print(typedText);
                ctrl.setTypedQeyd(typedText); // 👈 new method
              },
            );
          },
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  // optional: allows up to 2 decimal places
                ],
                decoration: InputDecoration(
                  labelText: 'amount'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: paysController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  // optional: allows up to 2 decimal places
                ],
                decoration: InputDecoration(
                  labelText: 'Ödənən'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: GetBuilder<PartnyorController>(
                builder: (ctrl) {
                  return RadioGroupComponent<String>(
                    value: ctrl.selectedRadio,
                    onChanged: (val) => ctrl.setSelectedRadio(val),
                    items: const [
                      RadioGroupItem(label: 'Qazanc', value: '+'),
                      RadioGroupItem(label: 'Xərc', value: '-'),
                    ],
                    direction: Axis.horizontal,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => Get.back(), child: Text('Ləğv et'.tr)),
            ElevatedButton(
              onPressed: () {
                final amount =
                    double.tryParse(amountController.text.trim()) ?? .0;
                final pays = double.tryParse(paysController.text.trim()) ?? .0;
                final kassaId = kassaController.selectedKassa?.id;
                // final mustId = xercQazancController.selectedItem?.musId;
                final categoryId = kassaController.selectedCategory?.id;
                final subCategoryId = kassaController.selectedSubCategory?.id;
                String? sebeb =
                    kassaController.selectedSebeb?.ad ??
                    kassaController.typedSebeb;
                String? qeyd =
                    kassaController.selectedQeyd?.ad ??
                    kassaController.typedQeyd;
                final sing = partnyorCtrl.selectedRadio;
                print('sign...${sing}');
                print('pays....${pays}');
                if (amount == null ||
                    kassaId == null ||
                    pays == null ||
                    sing == '') {
                  Get.snackbar('Error', 'Məlumatları düzgün doldurun!');
                  return;
                }

                final dto = XercRequestDto(
                  id: initial?.id,
                  mustId: mustId!,
                  kassaId: kassaId,
                  amount: amount,
                  pays: pays,
                  sign: partnyorCtrl.selectedRadio,
                  categoryId: categoryId,
                  subCategoryId: subCategoryId,
                  sebeb: sebeb,
                  qeyd: qeyd,
                );
                onSave(dto);
                Get.back(); // close dialog
              },
              child: Text('Yadda saxla'.tr),
            ),
          ],
        ),
      ],
    );
  }
}
