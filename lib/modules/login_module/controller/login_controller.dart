import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/login_module/controller/db_selection_controller.dart';
import 'package:hbmarket/modules/login_module/login_service/login_service.dart';
import 'package:hbmarket/modules/login_module/model/saved_user.dart';
import 'package:hbmarket/modules/login_module/model/user_login.dart';
import 'package:hbmarket/modules/login_module/pages/db_selection_page.dart';
import 'package:hbmarket/routes/route_helper.dart';

class LoginController extends GetxController {
  String username = '';
  String password = '';
  bool isLoading = false;
  int _deviceId = 0;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  late final LoginService service;
  // Getter
  int get deviceId => _deviceId;

  void _initDeviceId() async {
    int id = await DeviceUtils.getDeviceIdInt();
    deviceId = id;
    update();
  }

  // Setter
  set deviceId(int value) {
    _deviceId = value;
    update(); // refresh UI if using GetX
  }

  @override
  void onInit() {
    super.onInit();
    _initDeviceId();
    service = LoginService(client: ApiClient());
    loadUser();
  }

  void loadUser() async {
    SavedUser? user = await service.getSavedUser();
    if (user != null) {
      username = user.username;
      password = user.password;

      usernameController.text = username;
      passwordController.text = password;
      update();
    }
  }

  void saveUser() async {
    print('save user clicked...');
    print(username);
    print(username.isEmpty);
    final error = _validateLogin(username, password);

    if (error != null) {
      Get.snackbar('error'.tr, error);
      return;
    }
    final user = SavedUser(
      username: username,
      password: password,
      token: null,
      dbList: [],
    );
    service.saveUser(user);
  }

  String? _validateLogin(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      return 'userPass'.tr; // username or password empty
    }

    if (password.length < 4) {
      return 'passValid'.tr; // password too short
    }

    // optional: add more validation
    if (!GetUtils.isUsername(username)) {
      return 'userValid'.tr; // invalid username format
    }

    return null; // ✅ everything is valid
  }

  void login() async {
    // if (username.isEmpty || password.isEmpty) {
    //   Get.snackbar('error'.tr, 'userPass'.tr);
    //   return;
    // }
    // if (!GetUtils.isUsername(email)) {
    //   Get.snackbar('error'.tr, 'userValid'.tr);
    //   return;
    // }
    // if (password.length < 4) {
    //   Get.snackbar('error'.tr, 'passValid'.tr);
    //   return;
    // }

    final error = _validateLogin(username, password);

    if (error != null) {
      Get.snackbar('error'.tr, error);
      return;
    }
    final user = UserLogin(username: username, password: password);

    final result = await service.login(user);

    if (result['success'] == true) {
      // ✅ Login successful
      // final token = result['jwtToken'];
      // Save token locally (e.g., SharedPreferences)
      // await storage.write('jwt', token);
      // print('data...${result['userDbResponse']}');
      isLoading = false;
      deviceId = result['deviceId'] ?? '';
      update();
      // // final userDbList = result['userDbResponse'];
      // final userDbList = (result['userDbResponse'] as List?) ?? [];
      // if (userDbList.isEmpty) {
      //   // Show an error message or snackbar
      //   Get.snackbar('Error', 'No databases available for this user.');
      //   return; // Stop further execution
      // }
      // Get.offAllNamed(RouteHelper.home);
      // Get.offAllNamed(RouteHelper.user_db, arguments: result['userDbResponse']);
      final dbController = DbSelectionController.to;
      // dbController.handleDbSelection();
      dbController.loadDbList();
      Get.to(() => DbSelectionPage());
    } else if (result['isOtherDeviceLoggedIn'] == true) {
      // ⚠ Active session exists on another device
      isLoading = false;
      update();

      Get.defaultDialog(
        title: 'activeSession'.tr,
        middleText: 'forceLogin'.tr,
        textConfirm: 'Force Login',
        textCancel: 'Cancel',
        onConfirm: () async {
          Get.back();
          // Retry login with forceLogin = true
          // await loginUserForce(email, password);
        },
      );
    } else {
      //❌Invalid credentials
      isLoading = false;
      update();
      Get.snackbar('Error', result['message']);
    }
    // if (email == 'test2' && password == 'test2') {
    //   isLoading = true;
    //   update();

    //   // Simulate API call
    //   Future.delayed(const Duration(seconds: 2), () {
    //     isLoading = false;
    //     update();
    //     Get.offAllNamed(RouteHelper.home);
    //   });
    // } else {
    //   Get.snackbar('error'.tr, 'Invalid credentials');
    // }
  }
}
