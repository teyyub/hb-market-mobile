import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/radio_group.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/category_model.dart';

class YeniXercDialog extends StatelessWidget {
  final amountController = TextEditingController();
  final paysController = TextEditingController();
  // final phoneController = TextEditingController();
  final partnyorCtrl =
      Get.find<PartnyorController>(); // Get the existing controller
  final KassaController kassaController = Get.put(KassaController());
  final void Function(int mustId, double amount, String tip, int kassaId)
  onSave;
  final int mustId;
  YeniXercDialog({super.key, required this.mustId, required this.onSave});

  @override
  Widget build(BuildContext context) {
    String selectedRadio = '+';
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
        GetBuilder<CategoryController>(
          builder: (ctrl) {
            return DropdownSelector<Category>(
              label: 'Kat.'.tr,
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
            return DropdownSelector<Kassa>(
              label: 'Alt k.'.tr,
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
            return DropdownSelector<Kassa>(
              label: 'Sebeb'.tr,
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
            return DropdownSelector<Kassa>(
              label: 'Qeyd'.tr,
              selectedValue: ctrl.selectedKassa,
              items: ctrl.kassa,
              itemLabel: (r) => r.ad,
              onChanged: (r) => ctrl.setSelectedKassa(r),
            );
          },
        ),
        const SizedBox(height: 12),
        TextField(
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

        const SizedBox(height: 12),

        TextField(
          controller: amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            // optional: allows up to 2 decimal places
          ],
          decoration: InputDecoration(
            labelText: 'Odenen'.tr,
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        GetBuilder<PartnyorController>(
          builder: (ctrl) {
            return RadioGroupComponent<String>(
              value: ctrl.selectedRadio,
              onChanged: (val) => ctrl.setSelectedRadio(val),
              items: const [
                RadioGroupItem(label: 'Qazanc', value: '+'),
                RadioGroupItem(label: 'Xerc', value: '-'),
              ],
              direction: Axis.horizontal,
            );
          },
        ),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => Get.back(), child: Text('Ləğv et'.tr)),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                final kassaId = kassaController.selectedKassa?.id;
                if (amount == null || kassaId == null) {
                  Get.snackbar('Error', 'Məlumatları düzgün doldurun!');
                  return;
                }
                print('amount ${amount}');
                print('kassaId ${kassaId}');
                print('mustId ${mustId}');
                onSave(mustId, amount, selectedRadio, kassaId);
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
