import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/object_module/controller/obyekt_controller.dart';

class ObyektWidget {
  static void show(BuildContext context, ObyektController ctrl) {
    final isMobile = DeviceUtils.isMobile(context);
    final content = Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildBody(isMobile)),
        _buildFooter(),
        // _buildDialogContent(context, isMobile),
      ],
    );

    if (isMobile) {
      Get.bottomSheet(
        Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: content,
        ),
      );
    } else {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: content,
        ),
      );
    }
  }

  static Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Text(
        "selectObject".tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget _buildFooter() {
    return // Footer
    Padding(
      padding: const EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  static Widget _buildBody(bool isMobile) {
    return GetBuilder<ObyektController>(
      builder: (ctrl) {
        if (ctrl.isLoading)
          return const Center(child: CircularProgressIndicator());
        if (ctrl.errorMessage.isNotEmpty)
          return Center(child: Text(ctrl.errorMessage));
        if (ctrl.obyekts.isEmpty)
          return const Center(child: Text('No objects found'));

        // Use the same ScrollController for Scrollbar and ListView
        return Scrollbar(
          thumbVisibility:
              !isMobile, // show thumb on desktop/web, hide on mobile
          child: ListView.separated(
            itemCount: ctrl.obyekts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final foo = ctrl.obyekts[index];
              return ListTile(
                leading: const Icon(Icons.store, color: Colors.blue),
                title: Text(foo.name),
                subtitle: Text(foo.id != -1 ? "Details: ${foo.name}" : ""),
                onTap: () {
                  ctrl.setSelectedObyekt(foo);
                  Get.back();
                },
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildDialogContent(BuildContext context, bool isMobile) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildBody(isMobile)),
        _buildFooter(),
      ],
    );
  }
}
