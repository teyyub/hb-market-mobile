import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/common/widgets/column_visibility_menu.dart';
import 'package:hbmarket/modules/common/widgets/custom_table2.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/common/widgets/trina_grid_widget.dart';
import 'package:hbmarket/modules/hereket_module/models/hereket_reponse.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/mal_hereketi.dart';
import 'package:hbmarket/modules/mal_hereketi_module/models/odenis_request.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/controller/mal_yoxla_controller.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/mal_yoxla.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/widgets/add_barcode.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/widget/obyekt_widget.dart';
import 'package:hbmarket/modules/object_module/widget/select_object_button.dart';
import 'package:hbmarket/modules/partnyor_module/controller/partnyor_controller.dart';
import 'package:hbmarket/modules/partnyor_module/pages/barcode_scanner_page.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../hereket_module/models/hereket_request.dart';
import '../../hereket_module/widget/work_widget_bkp1.dart';
import '../../kassa_module/controller/kassa_controller.dart';
import '../../kassa_module/models/kassa_model.dart';
import '../controller/mal_hereketi_controller.dart';
import '../models/pul_hereketi_bax.dart';

class PayOperWidget extends StatefulWidget {

  final void Function(OdenisRequestDto dto) onSave;

  // final ObyektController obyController = Get.find<ObyektController>();
  // final MalHereketiController malHereketiController = Get.find<MalHereketiController>();
  OdenisRequestDto? initialDto;
  int qdaxil;
  int? pulal;
  PayOperWidget({
    super.key,
    required this.onSave,
    this.initialDto,
    required this.qdaxil,
    this.pulal
});
  @override
  State<PayOperWidget> createState() => _PayOperWidgetState();
}
class _PayOperWidgetState extends State<PayOperWidget> {
  final KassaController kassaCtrl = Get.find<KassaController>();
  final amountController = TextEditingController();
  late int kassaId;

  @override
  void initState() {
    super.initState();

    // Edit mode varsa, field-ləri doldur
    if (widget.initialDto != null) {
      debugPrint('init: ${widget.initialDto?.toJson()}');
      amountController.text = widget.initialDto!.mebleg.toString() ;
      kassaId = widget.initialDto!.kassaId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final match = kassaCtrl.kassa.firstWhereOrNull((k) => k.id == kassaId);
        if (match != null) {
          kassaCtrl.setSelectedKassa(match);
        }
      });
    } else {
      amountController.text = widget.pulal?.toString() ?? '0';
      kassaId = 0; // default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<KassaController>(
          builder: (KassaController ctrl) {
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

        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            // optional: allows up to 2 decimal places
          ],
          decoration: InputDecoration(
            labelText: 'amount'.tr,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text('Yadda saxla'.tr),
              onPressed: () {
                final amount =  double.tryParse(amountController.text.trim()) ?? .0;
                final kassaId = kassaCtrl.selectedKassa?.id;
                if (amount == null ||  kassaId == null ) {
                  Get.snackbar('Error', 'Məlumatları düzgün doldurun!');
                  return;
                }

                final dto = OdenisRequestDto(
                  // id: initial?.id,
                  pulal: widget.initialDto!.pulal,
                  qdaxil: widget.qdaxil,
                  kassaId: kassaId,
                  mebleg: amount,
                );
                widget.onSave(dto);
                Get.back();
              },
            ),
            const SizedBox(width: 12),
            TextButton(onPressed: () => Get.back(), child: Text('Ləğv et'.tr)),
          ],
        ),
      ],
    );
  }
}
