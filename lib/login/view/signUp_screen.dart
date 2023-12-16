import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentitezy/login/view/login_screen.dart';

import '../../screen/forgot_pass_page.dart';
import '../../utils/const/api.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';
import '../../widgets/const_widget.dart';
import '../login_controller/login_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          padding: const EdgeInsets.only(top: 20),
          margin: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(0.005),
                SizedBox(
                    height: 170,
                    width: 250,
                    child: Image.asset(
                      'assets/images/login_image.png',
                      fit: BoxFit.fill,
                    )),
                title("Create Account", 27),
                height(0.005),
                /*  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.white,
                            child: loginController.imagePath.isNotEmpty
                                ? CircleAvatar(
                                radius: 38.0,
                                backgroundImage: NetworkImage(loginController.imagePath),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        XFile? pickedImage =
                                        await ImagePicker().pickImage(
                                            source:
                                            ImageSource.gallery);
                                        if (pickedImage != null) {
                                          String img = await uploadImage(
                                              pickedImage.path,
                                              pickedImage.name);
                                          setState(() {
                                            loginController.imagePath = img;
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 15.0,
                                        color: Color(0xFF404040),
                                      ),
                                    ),
                                  ),
                                ))
                                : CircleAvatar(
                                radius: 38.0,
                                backgroundImage: const AssetImage(
                                    'assets/images/user_vec.png'),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        XFile? pickedImage =
                                        await ImagePicker().pickImage(
                                            source:
                                            ImageSource.gallery);
                                        if (pickedImage != null) {
                                          String img = await uploadImage(
                                              pickedImage.path,
                                              pickedImage.name);
                                          setState(() {
                                            loginController.imagePath = img;
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 15.0,
                                        color: Color(0xFF404040),
                                      ),
                                    ),
                                  ),
                                ))))),*/
                height(0.005),
                inputField('First name',
                    loginController.uFNameController, 5),
                inputField('Last name', loginController.uLNameController, 5),
                inputFieldPh(
                    'Mobile number', loginController.uPhoneController, 5),
                inputFieldEmail(
                    'Email Address', loginController.uEmailController, 5),
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
                height(0.005),
                SizedBox(
                  width: screenWidth * 0.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      onPressed: () async {
                        if (loginController.uFNameController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid first name');
                        } else
                        if (loginController.uLNameController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid last name');
                        } else
                        if (loginController.uPhoneController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid phone number');
                        } else
                        if (loginController.uEmailController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid email address');
                        } else if (!validateEmail(
                            loginController.uEmailController.text)) {
                          showSnackBar(context, 'Invalid email address');
                        } else
                        if (loginController.uPasswordController.text.isEmpty) {
                          showSnackBar(context, 'Enter valid password');
                        } else if (!loginController.isPasswordValid(
                            loginController.uPasswordController.text)) {
                          showSnackBar(context, 'Enter valid password');
                        } else {
                          setState(() {
                            loginController.isLoading = true;
                          });
                          loginController.createUserr(
                              firstName: loginController.uFNameController.text,
                              lastName: loginController.uLNameController.text,
                              phoneNumber: loginController.uPhoneController.text,
                              email: loginController.uEmailController.text,
                              password:loginController.uPasswordController.text );
                          // userRequest(loginORSignup: false);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 27, right: 27),
                        child: loginController.isLoading
                            ? load()
                            : Text(
                          'Sign Up',
                          style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                height(0.025),
                GestureDetector(
                  onTap: () {
                    Get.to(const LoginScreen());
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
                            text: 'Login Now',
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

  Widget inputField(String hind, TextEditingController tController,
      double bottom) {
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

  Widget inputFieldPh(String hind, TextEditingController tController,
      double bottom) {
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
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          maxLength: 10,
          decoration: InputDecoration(
              counter: const SizedBox(),
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

  Widget inputFieldEmail(String hind, TextEditingController tController,
      double bottom) {
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
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

}
