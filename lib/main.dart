import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_e_commerce_shop_app/controllers/cart_controller.dart';
import 'package:flutter_e_commerce_shop_app/controllers/product_controller.dart';
import 'package:flutter_e_commerce_shop_app/helper/helper_notifications.dart';
import 'package:flutter_e_commerce_shop_app/routes/route_helper.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_constants.dart';
import 'package:flutter_e_commerce_shop_app/uitls/message.dart';
import 'package:flutter_e_commerce_shop_app/uitls/scroll_behavior.dart';
import 'components/colors.dart';
import 'controllers/localization_controller.dart';
import 'helper/get_dependecies.dart' as dep;
import 'package:get/get.dart';

import 'firebase_options.dart'; // ✅ Correct import

// 🔔 Background message handler
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

// 🔔 Local notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase initialization with correct options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Map<String, Map<String, String>> _languages = await dep.init();

  int? _orderID;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        _orderID = remoteMessage.notification?.titleLocKey != null
            ? int.parse(remoteMessage.notification!.titleLocKey!)
            : null;
      }
      await HelperNotification.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {
    print("Error during Firebase setup: $e");
  }

  runApp(MyApp(languages: _languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  MyApp({required this.languages});

  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartsData();
    return GetBuilder<ProductController>(builder: (_) {
      return GetBuilder<LocalizationController>(
          builder: (localizationController) {
        return GetMaterialApp(
          scrollBehavior: AppScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: AppColors.mainColor,
            fontFamily: "Lato",
          ),
          locale: localizationController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(
            AppConstants.languages[0].languageCode,
            AppConstants.languages[0].countryCode,
          ),
          initialRoute: RouteHelper.getSplashRoute(),
          getPages: RouteHelper.routes,
          defaultTransition: Transition.topLevel,
        );
      });
    });
  }
}
