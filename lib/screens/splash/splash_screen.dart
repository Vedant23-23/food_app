import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_shop_app/controllers/auth_controller.dart';
import 'package:flutter_e_commerce_shop_app/controllers/cart_controller.dart';
import 'package:flutter_e_commerce_shop_app/controllers/location_controller.dart';
import 'package:flutter_e_commerce_shop_app/controllers/product_controller.dart';
import 'package:flutter_e_commerce_shop_app/controllers/user_controller.dart';
import 'package:flutter_e_commerce_shop_app/controllers/wish_list_controller.dart';
import 'package:flutter_e_commerce_shop_app/routes/route_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_dimensions.dart';
import '../../controllers/splash_controller.dart';
import '../../uitls/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  bool _firstTime = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..forward();
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    Get.find<SplashController>().initSharedData();
   // _initializeConnectivityListener();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    _onConnectivityChanged.cancel();
    super.dispose();
  }


/*
  void _initializeConnectivityListener() {
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        if (isNotConnected) {
          _showSnackBar('no_connection', Colors.yellow, Duration(minutes: 10));
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          _showSnackBar('connected', Colors.green, Duration(seconds: 3));
          _routeToInitial();
        }
      }
      _firstTime = false;
    }) as StreamSubscription<ConnectivityResult>;
  }
*/

  void _showSnackBar(String message, Color backgroundColor, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      duration: duration,
      content: Text(message, textAlign: TextAlign.center),
    ));
  }

  void _routeToInitial() {
    Timer(Duration(seconds: 3), () => Get.offNamed(RouteHelper.getInitialRoute()));
  }

  void _navigateToNextScreen() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 3), () async {
          if (Get.find<AuthController>().isLoggedIn()) {
            Get.offNamed(RouteHelper.getInitialRoute());
            await Get.find<WishListController>().getWishList();
          } else {
            if (Get.find<SplashController>().showIntro() != null) {
              if (AppConstants.languages.length > 1) {
                Get.offNamed(RouteHelper.getLanguagePage('splash'));
              } else {
                Get.offNamed(RouteHelper.getSignInRoute());
              }
            } else {
              Get.offNamed(RouteHelper.getSignInRoute());
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(child: Image.asset("img/logo part 1.png", width: Dimensions.SPLASH_IMG_WIDTH)),
          ),
          Center(child: Image.asset("img/logo part 2.png", width: Dimensions.SPLASH_IMG_WIDTH)),
        ],
      ),
    );
  }
}
