import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hbmarket/modules/common/widgets/auto_complete_selector.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/radio_group.dart';
import 'package:hbmarket/modules/hereket_module/controller/hereket_plani_controller.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_dto.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_request.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/models/obyekt_model.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/models/category_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/partnyor_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/qeyd_model.dart';
import 'package:hbmarket/modules/partnyor_module/models/xerc_request_dto.dart';
import 'package:hbmarket/modules/xerc_qazanc_module/controller/xercqazanc_controller.dart';

import '../../common/utils/validator.dart';

class HereketWidget extends StatefulWidget {
  final void Function(HereketRequest dto) onSave;

  final int? id;
  final HereketRequest? initial;
  const HereketWidget({super.key, this.id, required this.onSave, this.initial});
  @override
  State<HereketWidget> createState() => _HereketWidgetState();
}

class _HereketWidgetState extends State<HereketWidget> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final PartnyorController partnyorCtrl =
      Get.find<PartnyorController>();
  final XercQazancController xercQazancController =
      Get.find<XercQazancController>();
  final ObyektController obyektCtrl = Get.find<ObyektController>();
  final HereketPlaniController hereketCtrl = Get.find<HereketPlaniController>();

  List<String> validateInputs() {
    final List<String> errors = [];

    final input = amountController.text.isEmpty ? '0' : amountController.text;

    // Validate percentage
    if (!Validators.validatePercentage(input)) {
      errors.add('Dəyər -9999 ilə 100 arasında olmalıdır');
    }

    // Validate dropdown selections
    if (hereketCtrl.selectedHereketDto == null) {
      errors.add('Zəhmət olmasa bir "Hereket" seçin');
    }

    if (hereketCtrl.selectedObyekt == null) {
      errors.add('Zəhmət olmasa bir "Oby." seçin');
    }

    if (hereketCtrl.selectedPartnyor == null) {
      errors.add('Zəhmət olmasa bir "Partnyor" seçin');
    }

    return errors;
  }
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    // ✅ Run async setup after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        partnyorCtrl.fetchPartnors(),
        hereketCtrl.fetchHereketDto(),
        obyektCtrl.fetchObyekts(),

      ]);
      _initFromInitial();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _initFromInitial() {

    debugPrint('widget.initial .. ${widget.initial?.toJson()}');
    final initial = widget.initial;
    if (initial == null) return;

    amountController.text = initial.percentage.toString();
    noteController.text = initial.note.toString();

    final selectedHereket = hereketCtrl.hereketDtos.firstWhereOrNull(
      (h) => h.id == initial.hereketId,
    );
    final selectedObyekt = obyektCtrl.obyekts.firstWhereOrNull(
      (o) => o.id == initial.obyektId,
    );
    final selectedPartnyor = partnyorCtrl.partnyors.firstWhereOrNull(
      (p) => p.id == initial.partnyorId,
    );

    if (selectedHereket != null) {
      hereketCtrl.setSelectedHereketDto(selectedHereket);
    }
    if (selectedObyekt != null) {
      hereketCtrl.setSelectedObyekt(selectedObyekt);
    }
    if (selectedPartnyor != null) {
      hereketCtrl.setSelectedPartnyor(selectedPartnyor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<HereketPlaniController>(
          builder: (HereketPlaniController ctrl) {
            return DropdownSelector<HereketDto>(
              label: 'Hereket'.tr,
              selectedValue: ctrl.selectedHereketDto,
              items: ctrl.hereketDtos,
              itemLabel: (r) => r.name,
              onChanged: (r) => ctrl.setSelectedHereketDto(r),
            );
          },
        ),
        const SizedBox(height: 12),
        GetBuilder<ObyektController>(
          builder: (ObyektController objCtrl) {
            final HereketPlaniController hereketCtrl = Get.find<HereketPlaniController>();
            return DropdownSelector<Obyekt>(
              label: 'Oby.'.tr,
              selectedValue: hereketCtrl.selectedObyekt,
              items: objCtrl.obyekts,
              itemLabel: (r) => r.name,
              onChanged: (r) => hereketCtrl.setSelectedObyekt(r),
            );
          },
        ),
        const SizedBox(height: 12),
        GetBuilder<PartnyorController>(
          builder: (PartnyorController ctrl) {
            final HereketPlaniController hereketCtrl = Get.find<HereketPlaniController>();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0), // optional
              child: DropdownSelector<Partnyor>(
                label: 'Partnyor.'.tr,
                selectedValue: hereketCtrl.selectedPartnyor,
                items: partnyorCtrl.partnyors,
                itemLabel: (p) => p.ad,
                searchable: true,
                onChanged: (p) => hereketCtrl.setSelectedPartnyor(p),
              ),
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  // optional: allows up to 2 decimal places
                ],
                decoration: InputDecoration(
                  labelText: 'percentage'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: TextField(
                controller: noteController,
                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Qeyd'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: TextButton(onPressed: () => Get.back(), child: Text('Ləğv et'.tr))),
            Flexible(child: ElevatedButton(
              onPressed: () {
                // final input = amountController.text.isEmpty ? '0' : amountController.text;
                final errors = validateInputs();
                if (errors.isNotEmpty) {
                  Get.snackbar(
                    'Xətalar',
                    errors.join('\n'),
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 8,
                    duration: const Duration(seconds: 4),
                  );
                  return; // Stop execution if invalid
                }
                final double amount =
                    double.tryParse(amountController.text.trim()) ?? .0;
                final int? hereketId = hereketCtrl.selectedHereketDto?.id;
                final int? obyektId = hereketCtrl.selectedObyekt?.id;
                final int? partnyorId = hereketCtrl.selectedPartnyor?.id;

                final HereketRequest dto = HereketRequest(
                  id: widget.initial?.id,
                  hereketId: hereketId,
                  obyektId: obyektId,
                  partnyorId: partnyorId,
                  subPartnyorId: null,
                  percentage: Decimal.parse(
                    amount.toString(),
                  ), //Decimal.parse(amount.toString()),
                  note: noteController.text.trim(),
                );
                debugPrint("dto->${dto.toJson()}");
                widget.onSave(dto);
                Get.back(); // close dialog
              },
              child: Text('Yadda saxla'.tr),
            ),)
          ],
        ),
      ],
    );
  }
}
