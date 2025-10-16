import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/pages/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbController = DbSelectionController.to;
    final dbList = dbController.dbList;
    // final userDbResponse = (Get.arguments as List?) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Biznesi seçin"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Go to previous page
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: dbList.isEmpty
            ? const Center(
                child: Text(
                  "No databases available for your account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.separated(
                itemCount: dbList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final db = dbList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.storage, color: Colors.blue),
                      title: Text(
                        db["biznes"] ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text("ID: ${db["id"]}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () async {
                        // show loading dialog
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );
                        await dbController.saveDb(db);
                        Get.back(); // close loading
                        Get.to(() => DashboardPage());
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
