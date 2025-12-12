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
import 'package:hbmarket/modules/partnyor_module/models/partnyor_light.dart';

class FilterPartnyor extends StatefulWidget {
  final void Function(String? name, double? minAmount, double? maxAmount, int? tip, String? aktiv) onSave;

  const FilterPartnyor({Key? key, required this.onSave}) : super(key: key);

  @override
  State<FilterPartnyor> createState() => _FilterPartnyorState();
}
class _FilterPartnyorState extends State<FilterPartnyor> {
  final nameController = TextEditingController();
  final minAmountController = TextEditingController();
  final maxAmountController = TextEditingController();
  final partnyorCtrl = Get.find<PartnyorController>(); // Get the existing controller
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Widget render edildikdən sonra data yüklə
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await partnyorCtrl.fetchPartnorTypes();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // String selectedRadio = '+';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [


        TextField(
          controller: nameController,
          // keyboardType: const TextInputType.numberWithOptions(decimal: true),
          // inputFormatters: [
          //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          //   // optional: allows up to 2 decimal places
          // ],
          decoration: InputDecoration(
            labelText: 'Ad'.tr,
            border: const OutlineInputBorder(),
            suffixIcon: nameController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                nameController.clear();
                // optional: setState() çağırıb UI-ni yeniləyə bilərsən
                // setState(() {});
              },
            )
                : null,
          ),
          onChanged: (String value) {
            setState(() {}); // icon-un görünməsini yeniləmək üçün
          },
        ),
        const SizedBox(height: 12),
        const Text('Borc intervali'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child:
          TextField(
            controller: minAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              // optional: allows up to 2 decimal places
            ],
            decoration: InputDecoration(
              labelText: ''.tr,
              border: const OutlineInputBorder(),
              suffixIcon: minAmountController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  minAmountController.clear();
                  // optional: setState() çağırıb UI-ni yeniləyə bilərsən
                  // setState(() {});
                },
              )
                  : null,
            ),
            onChanged: (String value) {
              setState(() {}); // icon-un görünməsini yeniləmək üçün
            },
          ),),

          const SizedBox(width: 12),
          Expanded(child:
          TextField(
            controller: maxAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              // optional: allows up to 2 decimal places
            ],
            decoration: InputDecoration(
              labelText: ''.tr,
              border: const OutlineInputBorder(),
              suffixIcon: maxAmountController.text.isNotEmpty
                  ? IconButton(
                  icon: const Icon(Icons.clear),
                      onPressed: () {
                      maxAmountController.clear();
                      // optional: setState() çağırıb UI-ni yeniləyə bilərsən
                      // setState(() {});
                      },
                  )
                  : null,
              ),
            onChanged: (String value) {
              setState(() {}); // icon-un görünməsini yeniləmək üçün
            },
          ),
          ),
        ],),

        const SizedBox(height: 12),
        GetBuilder<PartnyorController>(
          builder: (PartnyorController ctrl) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return DropdownSelector<PartnyorLight>(
              label: 'Tip'.tr,
              selectedValue: ctrl.selectedPartnyorType,
              items: ctrl.partnyorTypes,
              itemLabel: (r) => r.ad ?? '',
              onChanged: (r) => ctrl.setSelectedPartnyorType(r),
            );
          },
        ),
        const SizedBox(height: 12),



        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => Get.back(), child: Text('Ləğv et'.tr)),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final double? minAmount = _toDoubleOrNull(minAmountController.text);
                final double? maxAmount = _toDoubleOrNull(maxAmountController.text);
                final int? tip = partnyorCtrl.selectedPartnyorType?.id;
                print('amount ${name}');
                // print('kassaId ${kassaId}');
                // print('mustId ${mustId}');
                widget.onSave( name, minAmount,maxAmount,tip, '+');
                Get.back(); // close dialog
              },
              child: Text('Yadda saxla'.tr),
            ),
          ],
        ),
      ],
    );
  }


  double? _toDoubleOrNull(String text) {
    if (text.trim().isEmpty) return null;
    return double.tryParse(text.trim());
  }
}
