import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/yonlendirme_module/controller/yonlendirme_controller.dart';
import 'package:hbmarket/modules/yonlendirme_module/service/yonlendirme_service.dart';

class YonlendirmePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<YonlendirmeController>(
      init: YonlendirmeController(),
      builder: (controller) {
        // return Scaffold(
        // appBar: AppBar(title: Text('Yonlendirme')),
        return MainLayout(
          title: 'Yonlendirme',
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.yonlendirmeList.length,
                  itemBuilder: (context, index) {
                    final item = controller.yonlendirmeList[index];
                    return ListTile(
                      title: Text(
                        item.kecidOk! ? 'Yonlendirilib' : 'Yonendirilmeyib',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Checkbox for kecidOk
                          Checkbox(
                            value: item.kecidOk,
                            onChanged: (val) {
                              if (val != null) {
                                controller.updateKecidOk(item, val);
                              }
                            },
                          ),
                          // Activate button
                          ElevatedButton(
                            onPressed: () =>
                                controller.updateKecidOk(item, true),
                            child: Text('Aktiv'),
                          ),
                          const SizedBox(width: 8),
                          // Disable button
                          ElevatedButton(
                            onPressed: () =>
                                controller.updateKecidOk(item, false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text('Passiv'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
