import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import '../../../utils/services/rie_user_api_service.dart';
import '../../add_kyc/view/add_kyc_screen.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';
import '../model/razorpay_payment_response_model.dart';

class RazorpayController extends GetxController {
  final Razorpay _razorpay = Razorpay();

  final RazorpayPaymentResponseModel paymentResponseModel;
  final int guestCount;
  RIEUserApiService apiService = RIEUserApiService();

  RazorpayController({required this.paymentResponseModel,required this.guestCount});

  @override
  void onInit() {
    super.onInit();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onPay();
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    showImageDialogAlert(
        context: Get.context!,
        icon: const Icon(
          Icons.check,
          color: Colors.white,
          size: 40,
        ),
        description: 'Payment Successful.',
        subText: const Text(
          'Navigating to dashboard...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        textColor: CustomTheme.myFavColor);

    _paymentCallback(
        razorpayOrderId: response.orderId ?? '',
        paymentId: response.paymentId,
        razorpayPaymentId: response.paymentId,
        razorpaySignature: response.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    showImageDialogAlert(
        context: Get.context!,
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
          size: 40,
        ),
        description: response.message ?? '',
        subText: const Text(
          'Navigating to dashboard...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        textColor: CustomTheme.errorColor);
    await Future.delayed(const Duration(seconds: 4));

    Get.find<DashboardController>().setIndex(0);
    Get.offAll(() => const DashboardView());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('ExternalWallet Error :: ${response.toString()}');
  }

  void _paymentCallback(
      {required String razorpayOrderId,
      String? paymentId,
      String? razorpayPaymentId,
      String? razorpaySignature}) async {
    final response = await apiService.postApiCall(endPoint: AppUrls.paymentCallback, bodyParams: {
      'paymentId': paymentResponseModel.paymentId.toString(),
      'razorpayPaymentId': razorpayPaymentId,
      'razorpayOrderId': razorpayOrderId,
      'razorpaySignature': razorpaySignature,
    });
    if (response != null && response['data'] != null ) {
      Get.offAll(() => AddKycScreen(
            guestCount: guestCount,
            fromPayment: true,
            bookingId: response['data']['id'],
          ));
    }
  }

  void onPay() {
    var options = {
      'key': paymentResponseModel.key,
      'amount': paymentResponseModel.amount,
      'name': paymentResponseModel.prefill?.name,
      'description': paymentResponseModel.description,
      'retry': {'enabled': true, 'max_count': 1},
      'order_id': paymentResponseModel.orderId,
      'send_sms_hash': true,
      'prefill': {'contact': paymentResponseModel.prefill?.contact, 'email': paymentResponseModel.prefill?.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    _razorpay.open(options);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
