import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/mobile_auth/controller/mobile_auth_controller.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';

class MobileAuthScreen extends StatelessWidget {
  const MobileAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MobileAuthController>(
      init: MobileAuthController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.15,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Constants.primaryColor),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'to',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Constants.primaryColor),
                  ),
                  Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.cover,
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.5,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SizedBox(
                    height: screenHeight * 0.06,
                    child: const Row(
                      children: [
                        Text(
                          '(+91)  ',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                        Text(
                          'India',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 20,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                    controller: controller.phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your mobile number',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  SizedBox(
                      width: screenWidth * 0.5,
                      child: const Text(
                        'We will send you one time password  (OTP)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                      )),
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
                        onPressed: controller.sentOTP,
                        child: const Text(
                          'Send OTP',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
