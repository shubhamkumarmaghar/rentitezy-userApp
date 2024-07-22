import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import '../../../utils/services/rie_user_api_service.dart';
import '../../razorpay_payment/model/razorpay_payment_response_model.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';


class InvoicePaymentController extends GetxController {
  final Razorpay _razorpay = Razorpay();

  final RazorpayPaymentResponseModel paymentResponseModel;
  RIEUserApiService apiService = RIEUserApiService();

  InvoicePaymentController({required this.paymentResponseModel});

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
    await Future.delayed(const Duration(seconds: 4));
    Get.find<DashboardController>().setIndex(0);
    Get.offAll(() => const DashboardView());
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    showImageDialogAlert(
        context: Get.context!,
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
          size: 40,
        ),
        description: response.message ?? 'Something went wrong!',
        subText: const Text(
          'Navigating to dashboard...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        textColor: CustomTheme.errorColor);
    await Future.delayed(const Duration(seconds: 2));

    Get.find<DashboardController>().setIndex(0);
    Get.offAll(() => const DashboardView());
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
