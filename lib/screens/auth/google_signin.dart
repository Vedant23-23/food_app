import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/base/custom_loader.dart';
import 'package:flutter_e_commerce_shop_app/controllers/auth_controller.dart';

import '../../base/custom_snackbar.dart';
import '../../components/colors.dart';
import '../../routes/route_helper.dart';
import '../../widgets/big_text.dart';

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        // appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: GetBuilder<AuthController>(builder: (authController) {
          return authController.isLoading
              ? CustomLoader()
              : CustomScrollView(scrollDirection: Axis.vertical, slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      width: w,
                      height: h * 0.2,
                      margin: EdgeInsets.only(
                          top: 40, left: 40, right: 40, bottom: 20),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("img/logo part 1.png"),
                              fit: BoxFit.fitHeight)),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello",
                            style: TextStyle(
                                fontSize: 70, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "sign_into_your_account".tr,
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[500]),
                          ),
                          //  SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ),
                  /*SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  sliver: SliverToBoxAdapter(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 55,
                                padding: EdgeInsets.only(bottom: 5),
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: authController.isEmail
                                              ? Color(0xFF4285f4)
                                              : Color(0xFF333333),
                                          )),
                                ),
                                child: Text(
                                  "email".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: authController.isEmail
                                          ? Color(0xFF4285f4)
                                          : Color(0xFF333333),
                                      fontSize: 17
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (!authController.isEmail) {
                                  authController.isEmail = true;
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                width: 55,
                                padding: EdgeInsets.only(bottom: 5),
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: authController.isEmail
                                          ? Color(0xFF4285f4)
                                          : Color(0xFF333333))),
                                ),
                                child: Text(
                                  "phone".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: authController.isEmail
                                          ? Color(0xFF4285f4)
                                          : Color(0xFF333333),
                                      fontSize: 17
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (authController.isEmail) {
                                  authController.isEmail = false;
                                }
                              },
                            )
                          ],
                        ),
                      ))),*/
                  SliverVisibility(
                      visible: authController.isEmail,
                      replacementSliver: SliverToBoxAdapter(
                          child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: Container(
                                      height: 48,
                                      width: 50,
                                      margin:
                                          EdgeInsets.only(bottom: 0, top: 15),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF8F8F8),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            bottomLeft: Radius.circular(6)),
                                      ),
                                      child: Text(
                                        "${authController.dialCode}",
                                        style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 15,
                                        ),
                                      )),
                                  onTap: () {
                                    Get.bottomSheet(
                                      Container(
                                        height: 230,
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  "dialcode".tr,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: ListTile(
                                                leading:
                                                    Icon(Icons.ac_unit_rounded),
                                                title: Text("+1"),
                                                onTap: () {
                                                  authController.dialCode =
                                                      "+1";
                                                  Get.back();
                                                },
                                              ),
                                            ),
                                            Expanded(
                                                child: Divider(
                                              height: 1,
                                              indent: 0,
                                              color: Color(0xFF999999),
                                            )),
                                            Center(
                                              child: ListTile(
                                                leading:
                                                    Icon(Icons.abc_rounded),
                                                title: Text("+86"),
                                                onTap: () {
                                                  authController.dialCode =
                                                      "+86";
                                                  print(
                                                      "my code is ${authController.dialCode}");
                                                  Get.back();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  height: 48,
                                  width: 1,
                                  color: Color(0xFFF8F8F8),
                                  margin: EdgeInsets.only(bottom: 0, top: 15),
                                  child: Container(
                                    height: 20,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 1,
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                                Container(
                                    width: 284,
                                    height: 48,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    margin: EdgeInsets.only(bottom: 0, top: 15),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF8F8F8),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (value) {
                                        authController.phone = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "phone".tr,
                                        hintStyle: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      autocorrect: false, // 自动纠正
                                      obscureText: false, // 隐藏输入内容, 密码框
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 200,
                                    height: 48,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    margin: EdgeInsets.only(bottom: 0, top: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          bottomLeft: Radius.circular(6)),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (value) {
                                        authController.code = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "code".tr,
                                        hintStyle: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      autocorrect: false, // 自动纠正
                                      obscureText: false, // 隐藏输入内容, 密码框
                                    )),
                                Container(
                                    height: 48,
                                    width: 135,
                                    margin: EdgeInsets.only(bottom: 0, top: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF8F8F8),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(6),
                                          bottomRight: Radius.circular(6)),
                                    ),
                                    child: GestureDetector(
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: 0, top: 0),
                                          decoration: BoxDecoration(
                                            color: authController.isSendCode
                                                ? Color(0xFF999999)
                                                : Color(0xFF1EBC9C),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            authController.isSendCode
                                                ? "code sent".tr
                                                : "get code".tr,
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 13),
                                          )),
                                      onTap: () {
                                        authController.sendCode();
                                      },
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            GestureDetector(
                              child: Center(
                                child: Container(
                                  width: w * 0.5,
                                  height: h * 0.08,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.mainColor),
                                  child: Center(
                                    child: BigText(
                                      text: 'sign_in'.tr,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                //controller.handleSignIn("phone");
                                _login(authController, "phone");
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 60,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      sliver: SliverToBoxAdapter(
                        child: Container(),
                      )),
                ]);
        }));
  }

  void _login(AuthController authController, String type) async {
    if (type == "phone") {
      String smsCode = authController.code;
      Get.focusScope?.unfocus();
      var phoneAuthCredential = await PhoneAuthProvider.credential(
          verificationId: authController.verificationId, smsCode: smsCode);
      var credential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if (credential.user == null) {
        showCustomSnackBar('There is no phone number');
        // return Future<void>;
      }
      String? id_token = await credential.user!.getIdToken()!;
      print('---social id token ${id_token}');
      authController.socialLogin(type, id_token!).then((status) async {
        if (status.isSuccess) {
          authController.saveUserNumberAndPassword(
              authController.phone, "firebase");
          String _token = status.message.substring(1, status.message.length);

          Get.offNamedUntil(RouteHelper.getInitialRoute(), (route) => false);
        } else {
          // Get.snackbar("Wrong", status.message);
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
