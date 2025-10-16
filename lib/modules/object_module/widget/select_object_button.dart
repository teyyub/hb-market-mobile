import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';
import 'package:hbmarket/modules/object_module/widget/obyekt_widget.dart';

class SelectObjectButton extends StatelessWidget {
  final ObyektController obyCtrl;
  final VoidCallback? onPressed;

  const SelectObjectButton({super.key, required this.obyCtrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ObyektController>(
      init: obyCtrl,
      builder: (_) {
        return ElevatedButton(
          onPressed: onPressed ?? () => ObyektWidget.show(context, obyCtrl),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            obyCtrl.selectedObyektLabel,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
