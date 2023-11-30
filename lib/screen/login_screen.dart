// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/screen/forgot_pass_page.dart';
import 'package:rentitezy/screen/home_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  TextEditingController uFNameController = TextEditingController();
  TextEditingController uLNameController = TextEditingController();
  TextEditingController uPhoneController = TextEditingController();
  TextEditingController uPasswordController = TextEditingController();
  TextEditingController uEmailController = TextEditingController();
  bool isLogin = true;
  String imagePath = '';
  bool isLoading = false;

  void isLoginCheck() {
    if (!isLogin) {
      isLogin = true;
    } else {
      isLogin = false;
    }
    setState(() {});
  }

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

  bool isPasswordValid(String password) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  Widget inputFieldPh(
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

  Widget inputFieldEmail(
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
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

  void userRequest() async {
    UserModel? userModel;
    // TenantModel? tenantModel;
    var sharedPreferences = await _pref;
    try {
      dynamic result;
      if (!isLogin) {
        result = await createUser(
            uFNameController.text,
            uLNameController.text,
            uPhoneController.text,
            uPasswordController.text,
            uEmailController.text,
            imagePath);

        if (result['success']) {
          userModel = UserModel.fromJson(result['data']);
        } else {
          showSnackBar(context, result['message']);
        }
      } else {
        result =
            await userLogin(uFNameController.text, uPasswordController.text);
        if (result['success']) {
          if (result['data'] != null) {
            userModel = UserModel.fromJson(result['data']);
            showSnackBar(context, result['message']);
          } else {
            showSnackBar(context, 'Invalid Credentials');
          }
        } else {
          showSnackBar(context, result['message']);
        }
      }
      if (userModel != null) {
        sharedPreferences.setBool(Constants.isLogin, true);
        if (result['isTenant']) {
          // tenantModel = TenantModel.fromJson(result['tenantDet']);
          sharedPreferences.setBool(Constants.isTenant, true);
          sharedPreferences.setString(Constants.tenantId, userModel.id);
          // if (tenantModel.isAgree == 'true') {
          //   sharedPreferences.setBool(Constants.isAgree, true);
          // } else {
          //   sharedPreferences.setBool(Constants.isAgree, false);
          // }
        } else {
          sharedPreferences.setBool(Constants.isTenant, false);
        }
        debugPrint("isTenant ${sharedPreferences.getBool(Constants.isTenant)}");
        sharedPreferences.setString(Constants.userId, userModel.id.toString());
        sharedPreferences.setString(Constants.phonekey, userModel.phone);
        sharedPreferences.setString(Constants.auth_key, userModel.authKey);
        sharedPreferences.setString(Constants.token, userModel.token);
        sharedPreferences.setString(Constants.profileUrl, userModel.image);
        sharedPreferences.setString(Constants.usernamekey, userModel.firstName);
        sharedPreferences.setString(Constants.emailkey, userModel.email);
        await Future<void>.delayed(const Duration(seconds: 2));
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      }
    } on Exception catch (error) {
      showSnackBar(context, error.toString());
      Navigator.pop(context);
    }
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
                height(15),
                SizedBox(
                    height: 170,
                    width: 250,
                    child: Image.asset(
                      'assets/images/login_image.png',
                      fit: BoxFit.fill,
                    )),
                title(!isLogin ? "Create Account" : "Welcome", 27),
                height(15),
                Visibility(
                  visible: !isLogin,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                          child: CircleAvatar(
                              radius: 40.0,
                              backgroundColor: Colors.white,
                              child: imagePath.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 38.0,
                                      backgroundImage: NetworkImage(imagePath),
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
                                                  imagePath = img;
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
                                                  imagePath = img;
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
                                      ))))),
                ),
                height(15),
                inputField(!isLogin ? 'First name' : 'Phone number',
                    uFNameController, 5),
                Visibility(
                  visible: !isLogin,
                  child: inputField('Last name', uLNameController, 5),
                ),
                Visibility(
                    visible: !isLogin,
                    child: inputFieldPh('Mobile number', uPhoneController, 5)),
                Visibility(
                    visible: !isLogin,
                    child:
                        inputFieldEmail('Email Address', uEmailController, 5)),
                inputField('Password', uPasswordController, 0),
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
                height(10),
                SizedBox(
                  width: screenWidth * 0.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      onPressed: () {
                        if (isLogin) {
                          if (uFNameController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid username');
                          } else if (uPasswordController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid password');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            userRequest();
                          }
                        } else {
                          if (uFNameController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid first name');
                          } else if (uLNameController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid last name');
                          } else if (uPhoneController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid phone number');
                          } else if (uEmailController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid email address');
                          } else if (!validateEmail(uEmailController.text)) {
                            showSnackBar(context, 'Invalid email address');
                          } else if (uPasswordController.text.isEmpty) {
                            showSnackBar(context, 'Enter valid password');
                          } else if (!isPasswordValid(
                              uPasswordController.text)) {
                            showSnackBar(context, 'Enter valid password');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            userRequest();
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 27, right: 27),
                        child: isLoading
                            ? load()
                            : Text(
                                !isLogin ? 'Sign Up' : 'Login',
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      )),
                ),
                height(25),
                GestureDetector(
                  onTap: () {
                    isLoginCheck();
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
                            text: !isLogin ? 'Login Now' : 'Sign Up Now',
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
