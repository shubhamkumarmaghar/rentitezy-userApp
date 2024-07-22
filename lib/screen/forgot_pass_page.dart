import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

import '../utils/const/widgets.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _MyForgotState();
}

class _MyForgotState extends State<ForgotScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TextEditingController phoneController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController cfrmPassController = TextEditingController();
  TextEditingController otpController = TextEditingController(text: "");
  bool sentOtp = false;
  //otp
  String otpCode = "";
  int otpCodeLength = 4;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Widget inputFeildPh(
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

  Widget inputFeild(
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
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Constants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Forgot Password',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        Positioned(
            top: 145,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputFeildPh('Mobile number', phoneController, 15),
                    Visibility(
                      visible: sentOtp,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Enter your otp',
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                          ),
                          height(0.005),
                          TextFieldPin(
                              textController: otpController,
                              autoFocus: true,
                              codeLength: otpCodeLength,
                              alignment: MainAxisAlignment.center,
                              defaultBoxSize: 46.0,
                              margin: 10,
                              selectedBoxSize: 46.0,
                              textStyle: const TextStyle(fontSize: 16),
                              defaultDecoration: pinPutDecoration.copyWith(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.6))),
                              selectedDecoration: pinPutDecoration,
                              onChange: (code) {
                                setState(() {
                                  otpCode = code;
                                });
                              }),
                          inputFeild('New Password', newPassController, 15),
                          inputFeild(
                              'Confirm Password', cfrmPassController, 15),
                        ],
                      ),
                    ),
                    height(0.05),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                          ),
                          onPressed: () async {
                            if (!sentOtp) {
                              dynamic result =
                                  await reqOtp(phoneController.text);
                              if (context.mounted) {}
                              if (result['success']) {
                                sentOtp = true;
                                showSnackBar(context, 'OTP : ${result['otp']}');
                              } else {
                                sentOtp = false;
                                showSnackBar(context, result['message']);
                              }
                            } else {
                              if (phoneController.text.isEmpty) {
                                showSnackBar(context, 'Enter valid phone');
                              } else if (phoneController.text.length != 10) {
                                showSnackBar(
                                    context, 'Enter valid phone 10 digits');
                              } else if (newPassController.text.isEmpty) {
                                showSnackBar(
                                    context, 'Enter valid new password');
                              } else if (cfrmPassController.text.isEmpty) {
                                showSnackBar(
                                    context, 'Enter valid confirm password');
                              } else if (cfrmPassController.text !=
                                  newPassController.text) {
                                showSnackBar(context,
                                    'New and Confirm Password not match');
                              } else {
                                dynamic result = await reqResetPass(
                                    otpCode,
                                    phoneController.text,
                                    newPassController.text);
                                if (context.mounted) {}
                                if (result['success']) {
                                  sentOtp = false;
                                  showSnackBar(context, result['message']);
                                  Navigator.pop(context);
                                } else {
                                  sentOtp = true;
                                  showSnackBar(context, result['message']);
                                }
                              }
                            }
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 27, right: 27),
                            child: Text(
                              sentOtp ? 'Update' : 'Otp Request',
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                    height(0.005),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          dynamic result = await reqOtp(phoneController.text);
                          if (context.mounted) {}
                          if (result['success']) {
                            sentOtp = true;
                            showSnackBar(context, 'OTP : ${result['otp']}');
                          } else {
                            sentOtp = false;
                            showSnackBar(context, result['message']);
                          }
                        },
                        child: Text(
                          'Recent OTP?',
                          style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    height(0.025),
                  ],
                ),
              ),
            ))
      ]),
    );
  }
}
