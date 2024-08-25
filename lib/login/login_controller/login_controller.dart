import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/const/widgets.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';
import '../model/login_response_model.dart';

class LoginController extends GetxController {
  bool isLoading = false;
  RxBool obscureText = true.obs;
  RIEUserApiService rieUserApiService = RIEUserApiService();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> login() async {
    String url = AppUrls.userLogin;
    showProgressLoader(Get.context!);
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
          'password': passwordController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('welcome') && data['data'] != null) {
      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(data['data']);
      RIEWidgets.getToast(message: data['message'].toString(), color: Constants.primaryColor);
      GetStorage().write(Constants.isLogin, true);
      GetStorage().write(Constants.userId, loginResponseModel.id.toString());
      GetStorage().write(Constants.phonekey, loginResponseModel.phone);
      GetStorage().write(Constants.token, loginResponseModel.token);
      GetStorage().write(Constants.profileUrl, loginResponseModel.image);
      GetStorage().write(Constants.usernamekey, '${loginResponseModel.firstName} ${loginResponseModel.lastName}');
      GetStorage().write(Constants.firstName, loginResponseModel.firstName);
      GetStorage().write(Constants.lastName, loginResponseModel.lastName);
      GetStorage().write(Constants.emailkey, loginResponseModel.email);
      cancelLoader();
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(() => const DashboardView());
    } else {
      cancelLoader();
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.errorColor);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        showProgressLoader(Get.context!);
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        cancelLoader();
        if (userCredential.user != null) {
          final googleIdToken = await userCredential.user?.getIdTokenResult();
          _googleSignInApi(googleIdToken?.token ?? '');
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }

  Future<void> _googleSignInApi(String googleUid) async {
    log('uid :: $googleUid');
    String url = AppUrls.googleSignIn;
    showProgressLoader(Get.context!);
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'token': googleUid,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('welcome') && data['data'] != null) {
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.myFavColor);
      GetStorage().write(Constants.isLogin, true);
      cancelLoader();
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(() => const DashboardView());
    } else {
      cancelLoader();
    }
  }

  Future<void> signInWithApple() async {
    try {
      bool isAppleSignInAvailable = await SignInWithApple.isAvailable();
      log('apple signIn available :: $isAppleSignInAvailable');
      if (await SignInWithApple.isAvailable()) {
        final appleData = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        log('apple ${appleData.email}--${appleData.authorizationCode}--${appleData.familyName}--${appleData.givenName}--${appleData.identityToken}--${appleData.state}--${appleData.userIdentifier} ');
      }
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // void showPhoneDialog() {
  //   AlertDialog alert = AlertDialog(
  //     backgroundColor: Colors.transparent,
  //     contentPadding: EdgeInsets.zero,
  //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //     content: Container(
  //       height: screenHeight * 0.42,
  //       width: screenWidth,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       padding: const EdgeInsets.only(
  //         left: 30,
  //         right: 30,
  //       ),
  //       child: Column(
  //         children: [
  //           Container(
  //             child: Image.asset(
  //               'assets/images/app_logo.png',
  //               fit: BoxFit.cover,
  //               height: screenHeight * 0.08,
  //               width: screenWidth * 0.45,
  //             ),
  //           ),
  //           SizedBox(
  //             height: screenHeight * 0.06,
  //             child: const Row(
  //               children: [
  //                 Text(
  //                   '(+91)  ',
  //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
  //                 ),
  //                 Text(
  //                   'India',
  //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
  //                 ),
  //                 Spacer(),
  //                 Icon(
  //                   Icons.arrow_drop_down_sharp,
  //                   size: 20,
  //                   color: Colors.black,
  //                 )
  //               ],
  //             ),
  //           ),
  //           Container(
  //             height: 1,
  //             color: Colors.black54,
  //           ),
  //           SizedBox(
  //             height: screenHeight * 0.02,
  //           ),
  //           TextField(
  //             keyboardType: TextInputType.phone,
  //             maxLength: 10,
  //             style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
  //             controller: phoneController,
  //             decoration: InputDecoration(
  //               hintText: 'Enter your mobile number',
  //               hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
  //             ),
  //           ),
  //           SizedBox(
  //             height: screenHeight * 0.01,
  //           ),
  //           SizedBox(
  //               width: screenWidth * 0.5,
  //               child: const Text(
  //                 'We will send you one time password  (OTP)',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
  //               )),
  //           SizedBox(
  //             height: screenHeight * 0.04,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SizedBox(
  //                 height: screenHeight * 0.045,
  //                 width: screenWidth * 0.27,
  //                 child: OutlinedButton(
  //                     style: OutlinedButton.styleFrom(
  //                       backgroundColor: CustomTheme.white,
  //                       side: const BorderSide(
  //                         width: 1.0,
  //                         color: Colors.black,
  //                       ),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(
  //                           5,
  //                         ),
  //                       ),
  //                     ),
  //                     onPressed: () => Get.back(),
  //                     child: const Text(
  //                       'Cancel',
  //                       style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
  //                     )),
  //               ),
  //               width(0.05),
  //               SizedBox(
  //                 height: screenHeight * 0.045,
  //                 width: screenWidth * 0.27,
  //                 child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                         backgroundColor: Constants.primaryColor,
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
  //                     onPressed: () {},
  //                     child: const Text(
  //                       'Send OTP',
  //                       style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
  //                     )),
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(
  //     barrierDismissible: false,
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

}
