import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';

import '../../home/home_view/home_screen.dart';
import '../../utils/const/api.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../model/login_signUp_model.dart';

class LoginController extends GetxController {
  LoginModel? userModel;
  bool isLogin = true;
  String imagePath = '';
  bool isLoading = false;
  RIEUserApiService rieUserApiService = RIEUserApiService();
  TextEditingController uFNameController = TextEditingController();
  TextEditingController uLNameController = TextEditingController();
  TextEditingController uPhoneController = TextEditingController();
  TextEditingController uPasswordController = TextEditingController();
  TextEditingController uEmailController = TextEditingController();

  Future<void> fetchLoginDetails(
      {required String email, required String password}) async {
    isLoading = true;
    String url = AppUrls.userLogin;
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': email,
          'password': password,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message']
        .toString()
        .toLowerCase()
        .contains('welcome to rentiseazy.')) {
      isLoading = false;
      userModel = LoginModel.fromJson(data);
      if (userModel?.success == true) {
        if (userModel?.data != null) {
          // userModel = LoginModel.fromJson(result);
          RIEWidgets.getToast(
              message: '${userModel?.message}', color: CustomTheme.white);
          GetStorage().write(Constants.isLogin, true);

          if (userModel?.isTenant == true) {
            // tenantModel = TenantModel.fromJson(result['tenantDet']);
            GetStorage().write(Constants.isTenant, true);
            GetStorage().write(Constants.tenantId, userModel?.data?.id);
            // if (tenantModel.isAgree == 'true') {
            //   GetStorage().write(Constants.isAgree, true);
            // } else {
            //   GetStorage().write(Constants.isAgree, false);
            // }
          } else {
            GetStorage().write(Constants.isTenant, false);
            GetStorage().write(Constants.tenantId, '');
          }
          debugPrint("isTenant ${GetStorage().read(Constants.isTenant)}");
          GetStorage().write(Constants.userId, userModel?.data?.id.toString());
          GetStorage().write(Constants.phonekey, userModel?.data?.phone);
          GetStorage().write(Constants.token, userModel?.data?.token);
          GetStorage().write(Constants.profileUrl, userModel?.data?.image);
          GetStorage().write(Constants.usernamekey, userModel?.data?.firstName);
          GetStorage().write(Constants.emailkey, userModel?.data?.email);
          await Future<void>.delayed(const Duration(seconds: 2));
          isLoading = false;
          Get.offAll(const MyHomePage());
        } else {
          RIEWidgets.getToast(
              message: '${userModel?.message}', color: CustomTheme.white);
        }
      } else {
        RIEWidgets.getToast(
            message: '${userModel?.message}', color: CustomTheme.white);
      }
    } else {
      isLoading = false;
      userModel = LoginModel(message: 'failure');
      RIEWidgets.getToast(
          message: '${userModel?.message}', color: CustomTheme.white);
    }
  }

  Future<void> createUserr(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String email,
      required String password}) async {
    isLoading = true;
    String url = AppUrls.userRegister;
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          "firstName": firstName,
          "lastName": lastName,
          "phone": phoneNumber,
          "password": password,
          "email": email,
          // "image": image
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message']
        .toString()
        .toLowerCase()
        .contains('welcome to rentiseazy.')) {
      isLoading = false;
      userModel = LoginModel.fromJson(data);
      if (userModel?.success == true) {
        if (userModel?.data != null) {
          // userModel = LoginModel.fromJson(result);
          RIEWidgets.getToast(
              message: '${userModel?.message}', color: CustomTheme.white);
          GetStorage().write(Constants.isLogin, true);

          if (userModel?.isTenant == true) {
            // tenantModel = TenantModel.fromJson(result['tenantDet']);
            GetStorage().write(Constants.isTenant, true);
            GetStorage().write(Constants.tenantId, userModel?.data?.id);
            // if (tenantModel.isAgree == 'true') {
            //   GetStorage().write(Constants.isAgree, true);
            // } else {
            //   GetStorage().write(Constants.isAgree, false);
            // }
          } else {
            GetStorage().write(Constants.isTenant, false);
            GetStorage().write(Constants.tenantId, '');
          }
          debugPrint("isTenant ${GetStorage().read(Constants.isTenant)}");
          GetStorage().write(Constants.userId, userModel?.data?.id.toString());
          GetStorage().write(Constants.phonekey, userModel?.data?.phone);
          GetStorage().write(Constants.token, userModel?.data?.token);
          GetStorage().write(Constants.profileUrl, userModel?.data?.image);
          GetStorage().write(Constants.usernamekey, userModel?.data?.firstName);
          GetStorage().write(Constants.emailkey, userModel?.data?.email);
          await Future<void>.delayed(const Duration(seconds: 2));
          isLoading = false;
          Get.offAll(const MyHomePage());
        } else {
          RIEWidgets.getToast(
              message: '${userModel?.message}', color: CustomTheme.white);
        }
      } else {
        RIEWidgets.getToast(
            message: '${userModel?.message}', color: CustomTheme.white);
      }
    } else {
      isLoading = false;
      userModel = LoginModel(message: 'failure');
      RIEWidgets.getToast(
          message: '${userModel?.message}', color: CustomTheme.white);
    }
  }

  void userRequest({bool loginORSignup = true}) async {
    //UserModel? userModel;
    LoginModel? userModel;
    // TenantModel? tenantModel;
    log('abced ${isLogin.toString()}');
    try {
      log('abced ${isLogin.toString()}');
      dynamic result;
      if (loginORSignup == false) {
        result = await createUser(
            uFNameController.text,
            uLNameController.text,
            uPhoneController.text,
            uPasswordController.text,
            uEmailController.text,
            imagePath);
        if (result['success']) {
          userModel = LoginModel.fromJson(result);
        } else {
          //showSnackBar(context, result['message']);
          log('${result['message']}');
        }
      } else {
        result =
            await userLogin(uFNameController.text, uPasswordController.text);
        if (result['success']) {
          log('message ::${result}');
          if (result['data'] != null) {
            userModel = LoginModel.fromJson(result);
            RIEWidgets.getToast(
                message: result['message'], color: CustomTheme.white);
            //showSnackBar(context, result['message']);
          } else {
            RIEWidgets.getToast(
                message: result['Invalid Credentials'],
                color: CustomTheme.white);
            // showSnackBar(context, 'Invalid Credentials');
          }
        } else {
          RIEWidgets.getToast(
              message: result['message'], color: CustomTheme.white);
          // showSnackBar(context, result['message']);
        }
      }
      if (userModel != null) {
        GetStorage().write(Constants.isLogin, true);
        if (result['isTenant']) {
          // tenantModel = TenantModel.fromJson(result['tenantDet']);
          GetStorage().write(Constants.isTenant, true);
          GetStorage().write(Constants.tenantId, userModel.data?.id);
          // if (tenantModel.isAgree == 'true') {
          //   GetStorage().write(Constants.isAgree, true);
          // } else {
          //   GetStorage().write(Constants.isAgree, false);
          // }
        } else {
          GetStorage().write(Constants.isTenant, false);
          GetStorage().write(Constants.tenantId, '');
        }
        debugPrint("isTenant ${GetStorage().read(Constants.isTenant)}");
        GetStorage().write(Constants.userId, userModel.data?.id.toString());
        GetStorage().write(Constants.phonekey, userModel.data?.phone);
        GetStorage().write(Constants.token, userModel.data?.token);
        GetStorage().write(Constants.profileUrl, userModel.data?.image);
        GetStorage().write(Constants.usernamekey, userModel.data?.firstName);
        GetStorage().write(Constants.emailkey, userModel.data?.email);
        await Future<void>.delayed(const Duration(seconds: 2));
        isLoading = false;

        Get.offAll(const MyHomePage());
        /*  Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));*/
      }
    } on Exception catch (error) {
      RIEWidgets.getToast(message: error.toString(), color: CustomTheme.white);
      //  showSnackBar(context, error.toString());
      //Navigator.pop(context);
    }
  }

/*
  void isLoginCheck() {
    if (!isLogin) {
      isLogin = true;
    } else {
      isLogin = false;
    }
  }
*/
  bool isPasswordValid(String password) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }
}
