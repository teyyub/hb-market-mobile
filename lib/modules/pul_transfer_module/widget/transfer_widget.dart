import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hbmarket/modules/common/widgets/drop_down_selector.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/pul_transfer_module/models/tranfer_request.dart';

class TransferWidget extends StatefulWidget {
  final TransferRequest? initialData;
  final void Function(TransferRequest request) onSubmit;

  const TransferWidget({super.key, this.initialData, required this.onSubmit});

  @override
  State<TransferWidget> createState() => _TransferWidgetState();
}

class _TransferWidgetState extends State<TransferWidget> {
  final kassaController = Get.find<KassaController>();
  late TextEditingController amountController;
  late TextEditingController noteController;

  Kassa? selectedTaker;
  Kassa? selectedGiver;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.initialData?.amount.toString() ?? '',
    );
    noteController = TextEditingController(
      text: widget.initialData?.note.toString() ?? '',
    );

    // preload selected kassa only once
    if (widget.initialData != null) {
      selectedTaker = kassaController.kassaAlan.firstWhereOrNull(
        (k) => k.id == widget.initialData!.taker,
      );
      selectedGiver = kassaController.kassaVeren.firstWhereOrNull(
        (k) => k.id == widget.initialData!.giver,
      );
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Məbləğ",
              border: OutlineInputBorder(),
            ),
          ),
          const Text("Veren"),
          const SizedBox(height: 8),
          GetBuilder<KassaController>(
            builder: (ctrl) {
              return DropdownSelector<Kassa>(
                label: 'Kassa'.tr,
                selectedValue: selectedGiver,
                items: ctrl.kassaVeren,
                itemLabel: (r) => r.ad,
                onChanged: (r) => setState(() => selectedGiver = r),
              );
            },
          ),
          const Text("Alan"),
          const SizedBox(height: 8),
          GetBuilder<KassaController>(
            builder: (ctrl) {
              return DropdownSelector<Kassa>(
                label: 'Kassa'.tr,
                selectedValue: selectedTaker,
                items: ctrl.kassaAlan,
                itemLabel: (r) => r.ad,
                onChanged: (r) => setState(() => selectedTaker = r),
              );
            },
          ),

          const SizedBox(height: 12),
          TextField(
            controller: noteController,
            // keyboardType: TextInputType,
            decoration: const InputDecoration(
              labelText: "Qeyd",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              debugPrint('1....${selectedTaker}');
              debugPrint('2....${amountController.text}');
              if (selectedTaker == null ||
                  selectedGiver == null ||
                  amountController.text.isEmpty) {
                Get.snackbar("Xəta", "Zəhmət olmasa bütün sahələri doldurun");
                return;
              }

              final request = TransferRequest(
                id: widget.initialData?.id,
                taker: selectedTaker!.id,
                giver: selectedGiver!.id,
                amount: Decimal.tryParse(amountController.text) ?? Decimal.zero,
                note: noteController.text.trim(),
              );
              debugPrint('request ...${request.toJson()}');
              widget.onSubmit(request);
              Get.back();
            },
            child: Text(
              widget.initialData == null
                  ? "Yadda saxla"
                  : "Düzəlişi yadda saxla",
            ),
          ),
        ],
      ),
    );
  }
}
