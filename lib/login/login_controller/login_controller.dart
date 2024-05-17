import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../model/login_response_model.dart';

class LoginController extends GetxController {
  bool isLoading = false;
  RxBool obscureText = true.obs;
  RIEUserApiService rieUserApiService = RIEUserApiService();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    String url = AppUrls.userLogin;
    showProgressLoader(Get.context!);
    final response = await rieUserApiService.postApiCall(
        endPoint: url,
        bodyParams: {
          'phone': phoneController.text,
          'password': passwordController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('welcome') && data['data'] != null) {
      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(data['data']);
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.myFavColor);
      GetStorage().write(Constants.isLogin, true);
      GetStorage().write(Constants.userId, loginResponseModel.id.toString());
      GetStorage().write(Constants.phonekey, loginResponseModel.phone);
      GetStorage().write(Constants.token, loginResponseModel.token);
      GetStorage().write(Constants.profileUrl, loginResponseModel.image);
      GetStorage().write(Constants.usernamekey, loginResponseModel.firstName);
      GetStorage().write(Constants.firstName, loginResponseModel.firstName);
      GetStorage().write(Constants.lastName, loginResponseModel.lastName);
      GetStorage().write(Constants.emailkey, loginResponseModel.email);
      cancelLoader();
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(() => const DashboardView());
    } else {
      cancelLoader();
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.errorColor);
    }
  }
}
