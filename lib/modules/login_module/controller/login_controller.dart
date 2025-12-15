import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hbmarket/http/api_class.dart';
import 'package:hbmarket/modules/common/api_response.dart';
import 'package:hbmarket/modules/common/utils/device_utils.dart';
import 'package:hbmarket/modules/login_module/login_service/device_service.dart';
import 'package:hbmarket/modules/login_module/login_service/login_service.dart';
import 'package:hbmarket/modules/login_module/model/device_login.dart';
import 'package:hbmarket/modules/login_module/model/saved_device.dart';
import 'package:hbmarket/modules/login_module/model/saved_user.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../common/login_data.dart';
import '../../common/user_check_res.dart';
import '../pages/db_selection_page.dart';
import 'db_selection_controller.dart';

class LoginController extends GetxController {


  String appVersion = '';
  String username = '';
  String password = '';
  bool isLoading = false;
  int _deviceId = 0;
  String? deviceMessage;
  String? deviceNote;

  final usernameController = TextEditingController();
  final deviceController = TextEditingController();
  final passwordController = TextEditingController();

  // bool isPasswordEnabled = false;

  late final LoginService service;
  late final DeviceService deviceService;
  SavedDevice? savedDevice;
  // Getter
  int get deviceId => _deviceId;



  Future<void> _initDeviceId() async {
    final int id = await DeviceUtils.getDeviceIdInt();
    deviceId = id;
    update();
  }

  // Setter
  set deviceId(int value) {
    _deviceId = value;
    deviceController.text = deviceId.toString();
    update(); // refresh UI if using GetX
  }


  void _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion = '${info.version}+${info.buildNumber}';
    final version = appVersion.split('+')[0];
    final shortVersion = version.split('.').sublist(0, 2).join('.');
    appVersion = shortVersion;
    debugPrint('App Version: $appVersion');
    update(); // UI varsa göstərmək üçün
  }


  @override
  void onInit() async {
    super.onInit();
    init();
  }

  Future<void> init() async {
    // _initDeviceId();
    deviceService = Get.find<DeviceService>();
    service = LoginService(client: ApiClient());
    // deviceService = DeviceService();
    // service = Get.find<LoginService>();

    await loadDevice();
    final DeviceLogin deviceLogin = DeviceLogin(
        deviceId: int.parse(deviceController.text),
        password: passwordController.text);
     _checkDevice(deviceLogin);

    _loadAppVersion();
    // loadUser();
  }

  Future<void> loadDevice() async {
    savedDevice = await deviceService.getSavedDevice();
    debugPrint('11111 ${savedDevice} ${deviceService}');
    String? deviceId ;
    if (savedDevice != null) {
       debugPrint('device....   ${savedDevice!.toJson()}');
       deviceId = savedDevice?.deviceId.toString();
       deviceController.text =  savedDevice!.deviceId.toString();
       passwordController.text = savedDevice!.password;
    } else {
      debugPrint('init........');
      await _initDeviceId();
      debugPrint('init........${deviceId}');
    }
    update();
  }

  Future<void> saveDevice() async {
    print('save clicked...');
    deviceId =  int.parse(deviceController.text);
    final error = _validateLogin(deviceId.toString(), password);

    if (error != null) {
      Get.snackbar('error'.tr, error);
      return;
    }
    final device = SavedDevice(
      deviceId: deviceId,
      password: password,
      dbList: [],
    );
    deviceService.saveDevice(device);
  }

  void loadUser() async {
    // SavedUser? user = await service.getSavedUser();
    // if (user != null) {
    //   username = user.username;
    //   password = user.password;
    //
    //   usernameController.text = username;
    //   passwordController.text = password;
    //   update();
    // }
  }

  void saveUser() async {
    print('save user clicked...');
    // print(username);
    // print(username.isEmpty);
    final error = _validateLogin(deviceId.toString(), password);

    if (error != null) {
      Get.snackbar('error'.tr, error);
      return;
    }
    final user = SavedUser(
      username: deviceId.toString(),
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

    // final error = _validateLogin(username, password);
    //
    // if (error != null) {
    //   Get.snackbar('error'.tr, error);
    //   return;
    // }
    // final user = UserLogin(username: username, password: password);
    //
    // final result = await service.login(user);
    //
    // if (result['success'] == true) {
    //   isLoading = false;
    //   deviceId = result['deviceId'] ?? '';
    //   update();
    //   final dbController = DbSelectionController.to;
    //   dbController.loadDbList();
    //   Get.to(() => DbSelectionPage());
    // } else if (result['isOtherDeviceLoggedIn'] == true) {
    //   // ⚠ Active session exists on another device
    //   isLoading = false;
    //   update();
    //
    //   Get.defaultDialog(
    //     title: 'activeSession'.tr,
    //     middleText: 'forceLogin'.tr,
    //     textConfirm: 'Force Login',
    //     textCancel: 'Cancel',
    //     onConfirm: () async {
    //       Get.back();
    //       // Retry login with forceLogin = true
    //       // await loginUserForce(email, password);
    //     },
    //   );
    // } else {
    //   //❌Invalid credentials
    //   isLoading = false;
    //   update();
    //   Get.snackbar('Error', result['message']);
    // }
  }

  void loginV1() async {


    // int deviceId = int.parse(deviceController.text);
    // try {
    //   final checkDevice = await deviceService.deviceCheck(deviceId);
    //   if (checkDevice['status'] != 'OK') {
    //     isLoading = false;
    //     update();
    //     Get.snackbar('Error', checkDevice['message'] ?? 'Device check failed');
    //   }
    // } catch (e) {
    //   isLoading = false;
    //   update();
    //   Get.snackbar('Error', e.toString()); // backend-dən gələn mesajı göstərmək
    // }


    // String password = passwordController.text;
    // final device = DeviceLogin(deviceId: deviceId,password: password);
    //
    //  final result = await deviceService.loginV1(device);
    // // debugPrint('result->...${result}');
    // if (result['success'] == true) {
    // //   isLoading = false;
    // //   // deviceId = result['deviceId'] ?? '';
    // //
    // //   final device = SavedDevice(
    // //     deviceId: int.parse(deviceController.text),
    // //     password: password,
    // //     dbList: result['userDbResponse'],
    // //   );
    // //   debugPrint('device->${device.toString()}');
    // //   deviceService.saveDevice(device);
    // //
    //   update();
    // //   final dbController = DbSelectionController.to;
    // //   dbController.loadDbList();
    // //   Get.to(() => DbSelectionPage());
    // }  else {
    //   //❌Invalid credentials
    //   isLoading = false;
    //   update();
    //   Get.snackbar('Error', result['message']);
    // }
  }

  // Device check metodunu ayrıca ayır
  // Future<void> checkDevice() async {
  //   // debugPrint('checkDevice... ${isPasswordEnabled}');
  //   isLoading = true;
  //   update();
  //   try {
  //     deviceId = int.parse(deviceController.text);
  //     final checkDevice = await service.check(deviceId);
  //
  //     if (checkDevice['status'] != 'OK') {
  //       // isPasswordEnabled = false;
  //       Get.snackbar(
  //         'Xəta',
  //         checkDevice['message'] ?? 'Cihaz yoxlanışı uğursuz oldu',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white,
  //       );
  //       isLoading = false;
  //       update();
  //       return;
  //     }
  //
  //     // Device OK-dirsə password sahəsini aktiv et
  //     // isPasswordEnabled = checkDevice['needPassword'] ?? true;
  //     isLoading = false;
  //     // debugPrint('checkDevice... ${isPasswordEnabled}');
  //     update();
  //   } catch (e) {
  //     isLoading = false;
  //     update();
  //     Get.snackbar(
  //       'Xəta',
  //       e.toString().replaceAll('Exception: ', ''),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
  //
  Future<void> _checkDevice(DeviceLogin deviceLogin) async {
    try {
      isLoading = true;
      update();
      debugPrint('deviceLogin ${deviceLogin}');
      final ApiResponse<String?> result = await service.check(deviceLogin);
      debugPrint('result->${result.success}');
      deviceMessage = result.message;
      debugPrint('result->${result.message}');
      debugPrint('result->${result.data}');
      if (result.data != null) {
        deviceNote = result.data!;
      } else {
        deviceNote = '';
      }

      debugPrint('result111->${deviceMessage}');
    } catch (e) {
      // deviceMessage = 'Xəta baş verdi';
      debugPrint('Error in check: $e');
    } finally {
      isLoading = false;
      update(); // UI yenilənir, progress gizlənir
    }
  }


  void loginV3() async {
    isLoading = true;
    update();

    int deviceId = int.parse(deviceController.text);

    try {
      String password = passwordController.text;
      final device = DeviceLogin(deviceId: deviceId, password: password);
      debugPrint('device ${device}');
       // _checkDevice(device);
      final ApiResponse<LoginData> result = await deviceService.loginV3(device);
      debugPrint('result login..${result.success}');
      if (result.success == true) {
        deviceMessage = result.message;
        deviceNote = result.data?.note?? '';
        isLoading = false;

        debugPrint('db: ${result.data}');
        final savedDevice = SavedDevice(
          deviceId: deviceId,
          password: password,
          dbList: result.data?.userDbResponse
              ?.map((e) => {"id": e.id, "biznes": e.biznes})
              .toList() ??
              [],
        );
        deviceService.saveDevice(savedDevice);

        update();
        final dbController = DbSelectionController.to;
        dbController.loadDbList();
        Get.to(() => DbSelectionPage());
      }
      else {
        deviceMessage = result.message;
        deviceNote = result.data?.note?? '';
        isLoading = false;
        update();
      }
    } catch (e) {
      // Backend-dən gələn xətaları user-friendly göstər
      isLoading = false;
      update();
      String msg = e.toString().replaceAll('Exception: ', '');
      // Get.snackbar(
      //   'Xəta',
      //   msg,
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      // );
    }
  }

}
