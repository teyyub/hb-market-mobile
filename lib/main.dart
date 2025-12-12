import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hbmarket/internet_check.dart';
import 'package:hbmarket/modules/common/app_binding.dart';
import 'package:hbmarket/routes/route_helper.dart';
import 'package:hbmarket/thema/theme.dart';
import 'package:hbmarket/thema/theme_controller.dart';
import 'package:hbmarket/translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/common/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Logger hazırdır
  // final log = AppLogger().logger;
  // log.i("App başlatıldı");

  Get.put(ThemeController());
  debugPaintSizeEnabled = false;
  final jsonTrans = JsonTranslations();
  await jsonTrans.load();
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('lang'); // stored language
  final jwtToken = prefs.getString('jwt_token'); // stored token
  final loggedIn = jwtToken != null && jwtToken.isNotEmpty;
  // Compute initial route here
  String initialRoute;
  if (loggedIn) {
    final dbName = prefs.getString('db_name');
    initialRoute = (dbName != null && dbName.isNotEmpty)
        ? RouteHelper.dashboard
        : RouteHelper.user_db;
  // }
  // else if (savedLang == null) {
  //   initialRoute = '/language';
  } else {
    initialRoute = RouteHelper.login;
  }

  runApp(
    MyApp(
      translate: jsonTrans,
      initialLang: savedLang ?? 'az',
      loggedIn: loggedIn,
      initialRoute: initialRoute,
    ),
  );
}

class MyApp extends StatelessWidget {
  final JsonTranslations translate;
  final String? initialLang;
  final bool loggedIn;
  final String initialRoute;

  const MyApp({
    required this.translate,
    this.initialLang,
    required this.loggedIn,
    required this.initialRoute,
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final ThemeController themeController = Get.put(ThemeController());
    return GetBuilder<ThemeController>(
        builder: (ThemeController themeController) => GetMaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      translations: translate,
      locale: initialLang != null ? Locale(initialLang!) : const Locale('az'),
      fallbackLocale: Locale('en'),
      supportedLocales: const [Locale('en'), Locale('az')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // initialRoute: RouteHelper.login,
      initialRoute: initialRoute,
      getPages: RouteHelper.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
      themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (BuildContext context, Widget? child) {
        return InternetBanner(child: child ?? const SizedBox());
      },
      initialBinding: AppBindings(),
    ));
  }
}
