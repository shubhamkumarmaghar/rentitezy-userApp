
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:rentitezy/mobile_auth/controller/mobile_auth_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import '../../utils/const/widgets.dart';

class MobileOtpScreen extends StatelessWidget {
  final controller = Get.find<MobileAuthController>();

  MobileOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: Constants.primaryColor.withOpacity(0.1),
        padding: EdgeInsets.only(left: 16, right: 16, top: screenHeight * 0.08),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'OTP Verification',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
             SizedBox(
                height: screenHeight * 0.1,
              ),
              SizedBox(
                  height: 100, child: Image.network('https://cdn.templates.unlayer.com/assets/1636374086763-hero.png')),

              SizedBox(
                height: screenHeight * 0.1,
              ),
              SizedBox(
                  width: screenWidth * 0.5,
                  child: Text(
                    'We have send you one time password (OTP) to ${controller.phoneController.text}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                  )),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              OTPTextField(
                controller: OtpFieldController(),
                keyboardType: TextInputType.number,
                isDense: false,
                margin: const EdgeInsets.all(5),
                length: 6,
                width: screenWidth * 0.85,
                fieldWidth: screenWidth * 0.1,
                fieldStyle: FieldStyle.underline,
                outlineBorderRadius: 10,
                contentPadding: const EdgeInsets.all(12),
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: Colors.white,
                  focusBorderColor: Constants.primaryColor,
                  enabledBorderColor: Constants.primaryColor,
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (pin) {
                  controller.otpController.text = pin;
                },
                onCompleted: (pin) {
                  controller.otpController.text = pin;
                },
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {},
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Don\'t receive the ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'OTP',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: ' ?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: ' RESEND OTP',
                        style: TextStyle(color: CustomTheme.appThemeContrast),
                      ),
                    ],
                  ),
                  textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.3,
              ),
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.8,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: controller.signInWithOTP,
                    child: const Text(
                      'Verify OTP',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
