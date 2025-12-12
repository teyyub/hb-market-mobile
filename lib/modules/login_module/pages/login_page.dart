import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/lang_module/language_service.dart';
import 'package:hbmarket/modules/login_module/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.put(LoginController());

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Azərbaycan', 'code': 'az'},
    {'name': 'Русский', 'code': 'ru'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = DeviceUtils.isMobile(context);
    final maxWidth = isMobile ? screenWidth * 0.9 : 400.0;

    return Scaffold(
      body: Column(
        children: [
          // Top header
          Container(
            height: 80,
            width: double.infinity,
            color: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'HB Market',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (kIsWeb)
                  DropdownButton<String>(
                    value: Get.locale?.languageCode ?? 'en',
                    dropdownColor: Colors.white,
                    underline: const SizedBox(),
                    items: languages
                        .map((lang) => DropdownMenuItem(
                                value: lang['code'],
                            child: Text(lang['name']!),
                          ),
                        )
                        .toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        await LanguageService.saveLanguage(value);
                        Get.updateLocale(Locale(value));
                      }
                    },
                  ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                // Left design for web
                if (!isMobile)
                  Expanded(
                    child: Container(
                      color: Colors.blue.shade100,
                      child: Center(
                        child: Image.network(
                          'assets/icon.png',
                          width: 250,
                        ),
                      ),
                    ),
                  ),

                // Login form
                Expanded(
                  flex: isMobile ? 1 : 1,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: GetBuilder<LoginController>(
                          builder: (_) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isMobile)
                                Image.asset(
                                  'assets/icon.png', // sənin iconun yolu
                                  width: 100,                  // ölçü FlutterLogo kimi
                                  height: 100,
                                ),
                                const SizedBox(height: 132),
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child:   Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [

                                        if (controller.isLoading)
                                          const CircularProgressIndicator()
                                        else if (controller.deviceMessage != null)
                                          Text(
                                            controller.deviceMessage??'',
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        if (controller.deviceNote != null)
                                          const SizedBox(height: 6,),
                                          Text(
                                            controller.deviceNote??'',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12,),
                                TextField(
                                  controller: controller.deviceController,
                                  readOnly:true,
                                  decoration: InputDecoration(
                                    labelText: "Kod".tr,
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: () {
                                        // Clipboard-a text kopyalamaq
                                        Clipboard.setData(
                                          ClipboardData(text: controller.deviceController.text),
                                        );
                                        // İstəyə görə toast/snackbar ilə mesaj göstərə bilərsən
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Kopyalandı')),
                                        );
                                      },
                                    ),
                                  ),


                                  onChanged: (value) =>
                                  controller.deviceId = int.parse(value),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: controller.passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'password'.tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                  // readOnly: !controller.isPasswordEnabled,
                                  onChanged: (value) =>
                                      controller.password = value,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:controller.loginV3,
                                    child: controller.isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text('btnLogin'.tr),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () async {
                                   await controller.saveDevice();
                                  },
                                  child: const Text('Yadda saxla'),
                                ),
                                const SizedBox(height: 24),
                                Text('Versiya: ${controller.appVersion.split('+')[0]}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, // ✅ Bold etmək üçün
                                    fontSize: 16,                // opsional: ölçü təyin edə bilərsən
                                  ),),

                                const SizedBox(height: 24),
                                // ✅ Device ID display section
                                // if (controller.deviceId != 0)
                                //   Column(
                                //     children: [
                                //       Text(
                                //         'Device ID:',
                                //         style: TextStyle(
                                //           fontWeight: FontWeight.bold,
                                //           color: Colors.grey.shade700,
                                //         ),
                                //       ),
                                //       const SizedBox(height: 4),
                                //       Row(
                                //         children: [
                                //           Expanded(
                                //             child: SelectableText(
                                //               controller.deviceId.toString(),
                                //               style: const TextStyle(
                                //                 fontSize: 16,
                                //                 color: Colors.black87,
                                //               ),
                                //             ),
                                //           ),
                                //           IconButton(
                                //             icon: const Icon(
                                //               Icons.copy,
                                //               size: 20,
                                //               color: Colors.blueGrey,
                                //             ),
                                //             tooltip: "Copy",
                                //             onPressed: () {
                                //               Clipboard.setData(
                                //                 ClipboardData(
                                //                   text: controller.deviceId
                                //                       .toString(),
                                //                 ),
                                //               );
                                //               ScaffoldMessenger.of(
                                //                 context,
                                //               ).showSnackBar(
                                //                 const SnackBar(
                                //                   content: Text(
                                //                     "Copied to clipboard",
                                //                   ),
                                //                 ),
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
