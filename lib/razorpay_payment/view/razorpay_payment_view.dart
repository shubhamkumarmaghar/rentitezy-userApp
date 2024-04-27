import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rentitezy/utils/const/appConfig.dart';

import '../controller/razorpay_controller.dart';
import '../model/razorpay_payment_response_model.dart';

class RazorpayPaymentView extends StatelessWidget {
  final RazorpayPaymentResponseModel paymentResponseModel;

  const RazorpayPaymentView({super.key, required this.paymentResponseModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RazorpayController>(
      init: RazorpayController(paymentResponseModel: paymentResponseModel),
      builder: (controller) {
        return PopScope(
          canPop:false ,
          child: Scaffold(
            body: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Payment processing...',
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontFamily: Constants.fontsFamily,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
