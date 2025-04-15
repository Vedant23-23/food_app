import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_e_commerce_shop_app/data/repos/auth_repo.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/models/response_model.dart';
import 'package:flutter_e_commerce_shop_app/models/signup_body.dart';
import 'package:flutter_e_commerce_shop_app/uitls/app_constants.dart';

import '../base/custom_snackbar.dart';
class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  bool _isEmail = false;

  String _dialCode = "1";

  bool get isLoading => _isLoading;

  bool get notification => _notification;

  bool get acceptTerms => _acceptTerms;

  bool get isEmail => _isEmail;

  set isEmail(value) => _isEmail = value;

  String get dialCode => _dialCode;

  set dialCode(value) {
    _dialCode = value;
    update();
  }

  String _phone = "";

  String get phone => _phone;

  set phone(value) {
    _phone = value;
    update();
  }

  String _email = "";

  String get email => _email;

  set email(value) {
    _email = value;
    update();
  }

  String _code = "";

  String get code => _code;

  set code(value) {
    _code = value;
    update();
  }

  String _password = "";

  String get password => _password;

  set password(value) {
    _password = value;
    update();
  }

  bool _isSendCode = false;

  bool get isSendCode => _isSendCode;

  set isSendCode(value) {
    _isSendCode = value;
    update();
  }




  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {

        authRepo.saveUserToken(response.body["token"]);
        //await authRepo.updateToken();

      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.body["errors"]!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verification(VerificationBody verificationBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.send_verification(verificationBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print(response.body["data"]);
      responseModel = ResponseModel(true, response.body["data"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone, password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {

        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();

      responseModel = ResponseModel(true,
          response.body['token']);
    } else {
      responseModel = ResponseModel(false, response.body["errors"][0]["message"]!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
  Future<ResponseModel> socialLogin(String type, String id_token) async {
    _isLoading = true;
    ResponseModel responseModel;
    update();

    Response response = await authRepo.socialLogin(type, id_token);

    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      await authRepo.updateToken();

      responseModel = ResponseModel(true, response.body['token']);
    } else {
      responseModel =
          ResponseModel(false, response.body["errors"][0]["message"]);
    }

    _isLoading = false;
    update();
    return responseModel;
  }
  bool clearSharedData() {
    return authRepo.clearSharedData();
  }
  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }
  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }
  String getUserToken() {
    return authRepo.getUserToken();
  }
  Future<void> updateToken() async {
    await authRepo.updateToken();
  }


  String verificationId = "";

  sendCode() async {
    if (isSendCode) {
      update();
      return;
    }
    try {
      String phone = _phone.trim();
      Get.focusScope?.unfocus();
      if (phone.isEmpty) {
        //toastInfo(msg: "phone number not empty!");
        showCustomSnackBar("phone number not empty");
        return;
      }
      String dialCode = _dialCode;
      print(phone);
      print(dialCode);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${dialCode} ${phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("verificationCompleted----");
          // toastInfo(msg: 'verificationCompleted');
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed----${_dialCode} ${phone}");
          print(e);
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          print('---my error ${e.code.toString()}');
          // toastInfo(msg: 'verificationFailed');
          isSendCode = false;
        },
        codeSent: (String verifiId, int? resendToken) async {
          //  forceResendingToken: resendToken;
          print('codeSent----------');
          print(verifiId);
          verificationId = verifiId;
          // toastInfo(msg: 'verification Code Sent');
          isSendCode = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('codeAutoRetrievalTimeout-------------');
          print(verificationId);
          isSendCode = false;
        },
        timeout: Duration(seconds: 30),
      );

      Future.delayed(Duration(seconds: 30), (){
        isSendCode = false;
        update();
      });
    } catch (error) {
      //toastInfo(msg: 'login error');
      showCustomSnackBar("login error");
      print("Login--------------------------");
      print(error);
    }
  }
}