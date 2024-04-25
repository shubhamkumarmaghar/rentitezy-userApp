import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../../../utils/services/rie_user_api_service.dart';
import '../model/razorpay_payment_response_model.dart';

class RazorpayController extends GetxController {
  final Razorpay _razorpay = Razorpay();

  final RazorpayPaymentResponseModel paymentResponseModel;

  RIEUserApiService apiService = RIEUserApiService();

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
    await sendPaymentResponse(status: 'success', successResponse: response);
  }

  Future<void> sendPaymentResponse(
      {required String status,
      PaymentSuccessResponse? successResponse,
      PaymentFailureResponse? failureResponse}) async {
    showImageDialogAlert(
        context: Get.context!,
        icon: Icon(
          status == 'success' ? Icons.check : Icons.clear,
          color: Colors.white,
          size: 40,
        ),
        description: status == 'success' ? 'Payment Successful.' : failureResponse?.message ?? '',
        subText: const Text(
          'Navigating to dashboard...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        textColor: status == 'success' ? const Color(0XFF7AB02A) : const Color(0XFFFF0000));

    _paymentCallback(
        status: status,
        razorpayOrderId: paymentResponseModel.orderId ?? '',
        paymentId: successResponse?.paymentId,
        razorpayPaymentId: successResponse?.paymentId,
        razorpaySignature: successResponse?.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    log('Payment Error :: ${response.message} err :: ${response.error}');
    await sendPaymentResponse(status: 'failure', failureResponse: response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('ExternalWallet Error :: ${response.toString()}');
  }

  void _paymentCallback(
      {required String status,
      required String razorpayOrderId,
      String? paymentId,
      String? razorpayPaymentId,
      String? razorpaySignature}) async {
    final response = await apiService.postApiCall(endPoint: AppUrls.paymentCallback, bodyParams: {
      'status': status,
      'paymentId': paymentId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpayOrderId': razorpayOrderId,
      'razorpaySignature': razorpaySignature,
    });
    if (response != null) {
      log('payment callback response :: $response');
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(const DashboardView());
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
