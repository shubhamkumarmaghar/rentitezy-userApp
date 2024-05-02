import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/login/login_controller/login_controller.dart';
import 'package:rentitezy/signup/view/signup_screen.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/screen/forgot_pass_page.dart';
import '../../utils/const/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        height(0.1),
                        SizedBox(
                            height: 120,
                            width: 200,
                            child: Image.asset(
                              'assets/images/login_image.png',
                              fit: BoxFit.fill,
                            )),
                        height(0.05),
                        title("Welcome to Rentiseazy", 22),
                        height(0.03),
                        phoneTextField(controller),
                        SizedBox(
                          height: screenHeight * 0.025,
                        ),
                        passwordTextField(controller),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotScreen()));
                            },
                            child: Text("Forgot Password? ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: CustomTheme.appThemeContrast,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),
                        height(0.1),
                        SizedBox(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.8,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () async {
                                if (controller.phoneController.text.isEmpty) {
                                  showSnackBar(context, 'Enter valid phone number', CustomTheme.errorColor);
                                } else if (controller.passwordController.text.isEmpty) {
                                  showSnackBar(context, 'Enter valid password', CustomTheme.errorColor);
                                } else {
                                  await controller.login();
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                        height(0.03),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => const SignUpScreen());
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Don't have an account ?  ",
                                    style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                        color: Constants.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: 'Sign Up Now',
                                    style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                        color: CustomTheme.appThemeContrast,
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget phoneTextField(LoginController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      height: screenHeight * 0.065,
      child: TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
            hoverColor: Constants.hint,
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            hintText: 'Mobile Number',
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordTextField(LoginController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      height: screenHeight * 0.065,
      child: Obx(() {
        return TextField(
          controller: controller.passwordController,
          obscureText: controller.obscureText.value,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hoverColor: Constants.hint,
              contentPadding: const EdgeInsets.only(left: 20, right: 20,bottom: 5),
              suffix: InkWell(
                  onTap: () {
                    controller.obscureText.value = !controller.obscureText.value;
                  },
                  child: Icon(
                    Icons.remove_red_eye,
                    color: controller.obscureText.value ? Constants.primaryColor : Colors.grey,
                  )),
              hintText: 'Password',
              border: InputBorder.none),
        );
      }),
    );
  }
}
