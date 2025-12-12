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

class FilterKassa extends StatefulWidget {
  final void Function(String? name, String? aktiv) onSave;

  const FilterKassa({Key? key, required this.onSave}) : super(key: key);

  @override
  State<FilterKassa> createState() => _FilterKassaState();
}
class _FilterKassaState extends State<FilterKassa> {
  final nameFocusNode = FocusNode();
  final nameController = TextEditingController();
  final kassaCtrl = Get.find<KassaController>(); // Get the existing controller
  // bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    kassaCtrl.fetchKassa();
    // Widget render edildikdən sonra data yüklə
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // FocusScope.of(context).requestFocus(nameFocusNode);

    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KassaController>(
        builder: (KassaController ctrl) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    focusNode: nameFocusNode,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Ad'.tr,
                      border: const OutlineInputBorder(),
                      suffixIcon: nameController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ctrl.setFilter('');
                          nameController.clear();
                          FocusScope.of(context).requestFocus(nameFocusNode);
                        },
                      )
                          : null,
                    ),
                    onChanged: (String value) => ctrl.setFilter(value),
                    onSubmitted: (_) {
                      _applyFilter(); // Enter basanda Apply funksiyasını çağırır
                    },
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Get.back(),
                          child: Text('Ləğv et'.tr)),
                      ElevatedButton(
                        onPressed:
                        _applyFilter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .blue, // Apply üçün accent rəng
                        ),
                        child: Text('Yadda saxla'.tr),
                      ),
                    ],
                  ),
                ],
              )
          );
        });
  }
  //later
  // void _applyFilter() {
  //   final filterData = {
  //     'name': nameController.text.trim(),
  //     // 'minAmount': minAmountController.text,
  //     // 'maxAmount': maxAmountController.text,
  //   };
  //   widget.onSave(filterData);
  //   Get.back();
  // }

  void _applyFilter() {
    final name = nameController.text.trim();
    widget.onSave(name, '+'); // sənin hazır onSave callback
    Get.back(); // BottomSheet-i bağlayır
  }

  double? _toDoubleOrNull(String text) {
    if (text.trim().isEmpty) return null;
    return double.tryParse(text.trim());
  }
}
