// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hbmarket/modules/common/utils/device_utils.dart';
// import 'package:hbmarket/modules/login_module/controller/login_controller.dart';

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   final LoginController controller = Get.put(LoginController());

//   final List<Map<String, String>> languages = [
//     {'name': 'English', 'code': 'en'},
//     {'name': 'Azərbaycan', 'code': 'az'},
//     {'name': 'Русский', 'code': 'ru'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final maxWidth = screenWidth < 600 ? screenWidth : 400.0;

//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: maxWidth),
//             child: GetBuilder<LoginController>(
//               builder: (_) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const FlutterLogo(size: 100),
//                     const SizedBox(height: 32),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: "username".tr,
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       onChanged: (value) => controller.email = value,
//                     ),
//                     const SizedBox(height: 16),
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: 'password'.tr,
//                         border: OutlineInputBorder(),
//                       ),
//                       obscureText: true,
//                       onChanged: (value) => controller.password = value,
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: controller.isLoading
//                             ? null
//                             : controller.login,
//                         child: controller.isLoading
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : Text('btnLogin'.tr),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextButton(
//                       onPressed: () {
//                         Get.snackbar('Info', 'Forgot password tapped');
//                       },
//                       child: const Text('Forgot Password?'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
                Text(
                  'HB Market',
                  style: const TextStyle(
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
                        .map(
                          (lang) => DropdownMenuItem(
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
                        // child: Image.network(
                        //   'https://via.placeholder.com/300x300.png?text=Logo',
                        //   width: 250,
                        // ),
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
                                if (isMobile) const FlutterLogo(size: 100),
                                const SizedBox(height: 32),
                                TextField(
                                  controller: controller.usernameController,
                                  decoration: InputDecoration(
                                    labelText: "username".tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) =>
                                      controller.username = value,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: controller.passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'password'.tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                  onChanged: (value) =>
                                      controller.password = value,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading
                                        ? null
                                        : controller.login,
                                    child: controller.isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text('btnLogin'.tr),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {
                                    controller.saveUser();
                                  },
                                  child: const Text('Yadda saxla'),
                                ),
                                const SizedBox(height: 24),
                                // ✅ Device ID display section
                                if (controller.deviceId != 0)
                                  Column(
                                    children: [
                                      Text(
                                        'Device ID:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SelectableText(
                                              controller.deviceId.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: Colors.blueGrey,
                                            ),
                                            tooltip: "Copy",
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(
                                                  text: controller.deviceId
                                                      .toString(),
                                                ),
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Copied to clipboard",
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Right side design for web
                // if (!isMobile)
                //   Expanded(
                //     child: Container(
                //       color: Colors.blue.shade50,
                //       child: Center(
                //         child: Text(
                //           'Welcome!\nPlease login to continue',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 22,
                //             color: Colors.blue.shade900,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
