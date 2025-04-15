import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/base/go_to_sign_in_page.dart';
import 'package:flutter_e_commerce_shop_app/components/colors.dart';
import 'package:flutter_e_commerce_shop_app/controllers/auth_controller.dart';
import 'package:flutter_e_commerce_shop_app/screens/wishlist/widget/fav_item_view.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_dimensions.dart';
import 'package:flutter_e_commerce_shop_app/uitls/styles.dart';

class WishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('favourite'.tr),
        backgroundColor: AppColors.mainColor,
      ),
      body: Get.find<AuthController>().isLoggedIn()
          ? SafeArea(
        child: Column(
          children: [
            // Remove TabBar and TabBarView, directly showing FavItemView
            Expanded(
              child: FavItemView(),
            ),
          ],
        ),
      )
          : GoToSignInPage(),
    );
  }
}
