import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/kassa_module/controller/kassa_controller.dart';
import 'package:hbmarket/modules/kassa_module/models/kassa_model.dart';
import 'package:hbmarket/modules/mal_yoxlanisi_module/models/search_item.dart';

class SelectKassaDropdown extends StatelessWidget {
  final KassaController kassaCtrl;

  const SelectKassaDropdown({super.key, required this.kassaCtrl});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KassaController>(
      init: kassaCtrl,
      builder: (ctrl) {
        return DropdownButtonFormField<Kassa>(
          decoration: const InputDecoration(
            labelText: 'Kassa seçin',
            border: OutlineInputBorder(),
          ),
          value: ctrl.selectedKassa,
          items: ctrl.kassa
              .map(
                (item) =>
                    DropdownMenuItem<Kassa>(value: item, child: Text(item.ad)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) ctrl.setSelectedKassa(value);
          },
        );
      },
    );
  }
}
