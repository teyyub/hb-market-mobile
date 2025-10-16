import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/main_page.dart';
import 'package:hbmarket/modules/temizlenme_module/controller/temizlenme_controller.dart';

class TemizlenmePage extends StatelessWidget {
  TemizlenmePage({Key? key}) : super(key: key);

  final TemizlenmeController controller = Get.put(TemizlenmeController());

  Future<void> pickDateTime(BuildContext context, int index) async {
    // Access item data directly from controller
    final id = controller.temizlenmeList[index].id;
    final date = controller.temizlenmeList[index].date;
    final temizlenDto = controller.temizlenmeList[index];
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );

      if (time != null) {
        DateTime newDate = DateTime(
          selected.year,
          selected.month,
          selected.day,
          time.hour,
          time.minute,
        );

        await controller.updateDate(temizlenDto, newDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Temizlenme List')),
    return MainLayout(
      title: 'Temizlenme',
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.temizlenmeList.isEmpty) {
          return const Center(child: Text('No records found'));
        }

        return ListView.builder(
          itemCount: controller.temizlenmeList.length,
          itemBuilder: (context, index) {
            final item = controller.temizlenmeList[index];
            return ListTile(
              title: Text('ID: ${item.id}'),
              subtitle: Text(
                'Date: ${item.date.toLocal().toString().split('.').first}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => pickDateTime(context, index),
              ),
            );
          },
        );
      }),
    );
  }
}
