import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/invoices/controller/invoice_payment_controller.dart';

import 'package:rentitezy/utils/const/appConfig.dart';

import '../../razorpay_payment/model/razorpay_payment_response_model.dart';

class InvoicePaymentScreen extends StatelessWidget {
  final RazorpayPaymentResponseModel paymentResponseModel;

  const InvoicePaymentScreen({super.key, required this.paymentResponseModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoicePaymentController>(
      init: InvoicePaymentController(paymentResponseModel: paymentResponseModel),
      builder: (controller) {
        return PopScope(
          canPop: false,
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
