import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/login/view/login_screen.dart';
import 'package:rentitezy/signup/controller/signup_controller.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
                width: screenWidth,
                height: screenHeight,
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      height(0.07),
                      SizedBox(
                          height: 120,
                          width: 200,
                          child: Image.asset(
                            'assets/images/login_image.png',
                            fit: BoxFit.fill,
                          )),
                      height(0.02),
                      title("Create Account", 22),
                      height(0.02),
                      firstNameTextField(controller),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      lastNameTextField(controller),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      phoneTextField(controller),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      emailTextField(controller),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      passwordTextField(controller),
                      SizedBox(
                        height: screenHeight * 0.08,
                      ),
                      SizedBox(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.8,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomTheme.appThemeContrast,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: () async {
                              if (controller.firstNameController.text.length < 2) {
                                showSnackBar(context, 'Enter valid first name');
                              } else if (controller.lastNameController.text.length < 3) {
                                showSnackBar(context, 'Enter valid last name');
                              } else if (controller.phoneController.text.length < 10) {
                                showSnackBar(context, 'Enter valid phone number');
                              } else if (!validateEmail(controller.emailController.text)) {
                                showSnackBar(context, 'Invalid email address');
                              } else if (controller.passwordController.text.length < 6) {
                                showSnackBar(context, 'Enter valid password');
                              } else {
                                await controller.signUp();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 27, right: 27),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      ),
                      height(0.025),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Already have an account ?  ',
                                  style: TextStyle(
                                      fontFamily: Constants.fontsFamily,
                                      color: Constants.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: 'Login Now',
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
    );
  }

  Widget firstNameTextField(SignUpController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      height: screenHeight * 0.065,
      child: TextField(
        controller: controller.firstNameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hoverColor: Constants.hint,
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            hintText: 'First Name',
            border: InputBorder.none),
      ),
    );
  }

  Widget lastNameTextField(SignUpController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      height: screenHeight * 0.065,
      child: TextField(
        controller: controller.lastNameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            hoverColor: Constants.hint,
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            hintText: 'Last Name',
            border: InputBorder.none),
      ),
    );
  }

  Widget phoneTextField(SignUpController controller) {
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

  Widget emailTextField(SignUpController controller) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      height: screenHeight * 0.065,
      child: TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hoverColor: Constants.hint,
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            hintText: 'Email Address',
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordTextField(SignUpController controller) {
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
              contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
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
