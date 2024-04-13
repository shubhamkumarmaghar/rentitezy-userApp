import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../model/razorpay_payment_response_model.dart';

class RazorpayController extends GetxController {
  final Razorpay _razorpay = Razorpay();

  final RazorpayPaymentResponseModel paymentResponseModel;

  RazorpayController({required this.paymentResponseModel});

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
    log('Payment Success :: ${response.data}--- oder id :: ${response.orderId} -- ${response.paymentId} -- signature :: ${response.signature}');
    await sendSuccessPaymentResponse();
  }

  Future<void> sendSuccessPaymentResponse() async {
    showImageDialogAlert(
        context: Get.context!,
        icon: const Icon(
          Icons.check,
          color: Colors.white,
          size: 40,
        ),
        description: 'Payment Successful.',
        subText: const Text('Navigating to dashboard...',style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
            color: Colors.black54
        ),),
        textColor: const Color(0XFF7AB02A));
    await Future.delayed(const Duration(seconds: 4));
    Get.find<DashboardController>().setIndex(0);
    Get.offAll(DashboardView());
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    log('Payment Error :: ${response.message} err :: ${response.error}');

    showImageDialogAlert(
        context: Get.context!,
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
          size: 40,
        ),
        subText: const Text('Navigating to dashboard...',style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54
        ),),
        description: '${response.message}.',
        textColor: const Color(0XFFFF0000));
    await Future.delayed(const Duration(seconds: 5));
    Get.find<DashboardController>().setIndex(0);
    Get.offAll(DashboardView());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('ExternalWallet Error :: ${response.toString()}');
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
