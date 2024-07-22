
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/mobile_auth/view/mobile_otp_screen.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../login/model/login_response_model.dart';
import '../../signup/view/signup_screen.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';

class MobileAuthController extends GetxController {
  RIEUserApiService rieUserApiService = RIEUserApiService();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sentOTP() async {
    showProgressLoader(Get.context!);
    String url = AppUrls.otpSignIn;
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;
    cancelLoader();
    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
      Get.to(() => MobileOtpScreen());
    }
  }

  Future<void> resendOTP() async {
    showProgressLoader(Get.context!);
    String url = AppUrls.otpSignIn;
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;
    cancelLoader();
    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
      RIEWidgets.getToast(message:'OTP sent successfully', color: CustomTheme.myFavColor);
    }
  }

  Future<void> signInWithOTP() async {
    showProgressLoader(Get.context!);
    String url = AppUrls.otpSignIn;
    final response = await rieUserApiService.postApiCall(
        endPoint: url, bodyParams: {'phone': phoneController.text, 'otp': otpController.text}, fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(data['data']);
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.myFavColor);
      GetStorage().write(Constants.isLogin, true);
      GetStorage().write(Constants.userId, loginResponseModel.id.toString());
      GetStorage().write(Constants.phonekey, loginResponseModel.phone);
      GetStorage().write(Constants.token, loginResponseModel.token);
      GetStorage().write(Constants.profileUrl, loginResponseModel.image);
      GetStorage().write(Constants.usernamekey, '${loginResponseModel.firstName} ${loginResponseModel.lastName}');
      GetStorage().write(Constants.firstName, loginResponseModel.firstName);
      GetStorage().write(Constants.lastName, loginResponseModel.lastName);
      GetStorage().write(Constants.emailkey, loginResponseModel.email);
      cancelLoader();
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(() => const DashboardView());
    }else{
      cancelLoader();
      Get.offAll(() => const SignUpScreen());
    }
  }
}
