import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../widgets/custom_alert_dialogs.dart';
import '../model/signup_response_model.dart';

class SignUpController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final apiService = RIEUserApiService();
  RxBool obscureText = true.obs;

  Future<void> signUp() async {
    showProgressLoader(Get.context!);
    String url = AppUrls.userRegister;
    final response = await apiService.postApiCall(
        endPoint: url,
        bodyParams: {
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
          "email": emailController.text,
        },
        fromLogin: true);
    final data = response as Map<String, dynamic>;

    if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
      SignUpResponseModel loginResponseModel = SignUpResponseModel.fromJson(data['data']);
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.myFavColor);
      GetStorage().write(Constants.isLogin, true);
      GetStorage().write(Constants.userId, loginResponseModel.id.toString());
      GetStorage().write(Constants.phonekey, loginResponseModel.phone);
      GetStorage().write(Constants.firstName, loginResponseModel.firstName);
      GetStorage().write(Constants.lastName, loginResponseModel.lastName);
      GetStorage().write(Constants.token, loginResponseModel.token);
      GetStorage().write(Constants.profileUrl, loginResponseModel.image);
      GetStorage().write(Constants.usernamekey, loginResponseModel.firstName);
      GetStorage().write(Constants.emailkey, loginResponseModel.email);
      cancelLoader();
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(() => const DashboardView());
    } else {
      cancelLoader();
      RIEWidgets.getToast(message: data['message'].toString(), color: CustomTheme.errorColor);
    }
  }

  bool isPasswordValid(String password) {
    RegExp regex = RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }
}
