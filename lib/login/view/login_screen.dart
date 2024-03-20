// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/login/view/signUp_screen.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/screen/forgot_pass_page.dart';
import 'package:rentitezy/home/home_view/home_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/const/widgets.dart';
import '../login_controller/login_controller.dart';
import '../model/login_signUp_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  Widget inputField(
      String hind, TextEditingController tController, double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Constants.lightBg,
          border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
        ),
        child: TextField(
          controller: tController,
          decoration: InputDecoration(
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 20),
          margin: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(0.05),
                SizedBox(
                    height: 170,
                    width: 250,
                    child: Image.asset(
                      'assets/images/login_image.png',
                      fit: BoxFit.fill,
                    )),
                title("Welcome", 27),
                height(0.05),
                inputField('Phone number', loginController.uFNameController, 5),
                inputField('Password', loginController.uPasswordController, 0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotScreen()));
                      },
                      child: Text("Forgot Password? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              color: Constants.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                height(0.025),
                SizedBox(
                  width: screenWidth * 0.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      onPressed: () async {
                        if (loginController.uFNameController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid username');
                        } else if (loginController
                            .uPasswordController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid password');
                        } else {

                          loginController.fetchLoginDetails(email: loginController.uFNameController.text ,
                              password:loginController
                              .uPasswordController.text  );
                          //loginController.userRequest(loginORSignup: true);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 27, right: 27),
                        child: loginController.isLoading
                            ? load()
                            : Text(
                                'Login',
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      )),
                ),
                height(0.05),
                GestureDetector(
                  onTap: () {
                    Get.to(const SignUpScreen());
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                fontFamily: Constants.fontsFamily,
                                color: Constants.textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'Sign Up Now',
                            style: TextStyle(
                                fontFamily: Constants.fontsFamily,
                                color: Constants.primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
