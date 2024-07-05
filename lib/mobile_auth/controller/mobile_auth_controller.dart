import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rentitezy/mobile_auth/view/mobile_otp_screen.dart';

import '../../dashboard/view/dashboard_view.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';

class MobileAuthController extends GetxController{
  RIEUserApiService rieUserApiService = RIEUserApiService();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sentOTP() async {
    // Get.to(()=>MobileOtpScreen());
    // return;
    String url = AppUrls.sendOTP;
    log('ddd --${phoneController.text}');
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
      Get.offAll(() => const DashboardView());
    }
  }
  Future<void> resendOTP() async {
    String url = AppUrls.resendOTP;
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {

    }
  }
  Future<void> signInWithOTP() async {

    String url = AppUrls.otpSignIn;
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
      Get.offAll(() => const DashboardView());
    }
  }
}