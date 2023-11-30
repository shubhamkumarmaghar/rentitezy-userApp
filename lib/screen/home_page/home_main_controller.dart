import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/localDb/db_helper.dart';
import 'package:rentitezy/model/tenant_model.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:rentitezy/screen/profile_screen_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';

class HomeMainController extends GetxController {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var userName = 'Guest'.obs;
  var userPhone = 'Guest'.obs;
  var userId = 'guest'.obs;
  var profilePic = 'guest'.obs;
  final dbFavItem = DbHelper.instance;
  var isTenant = false.obs;
  var tenantName = "guest".obs;
  var tenantId = 'guest'.obs;
  var othersController = TextEditingController();
  var commentController = TextEditingController();
  TenantModel? tenantDet;
  UserModel? userDet;
  @override
  void onInit() {
    fetchUser();
    super.onInit();
  }

  void fetchUser() async {
    SharedPreferences sharedPreferences = await prefs;
    if (sharedPreferences.containsKey(Constants.userId) &&
        (sharedPreferences.getString(Constants.userId) != null)) {
      dynamic result = await fetchTenantUserApi(
          '${AppUrls.getUser}?id=${sharedPreferences.getString(Constants.userId).toString()}');
      if (result["success"]) {
        userDet = UserModel.fromJson(result["data"][0]);
        sharedPreferences.setString(Constants.userId, userDet!.id);
        userId.value = UserModel.fromJson(result["data"][0]).id.toString();
        // if (result['isTenant']) {
        // sharedPreferences.setBool(Constants.isTenant, true);
        // TenantModel tempTenant = TenantModel.fromJson(result['tenantDet']);
        if (sharedPreferences.getBool(Constants.isTenant)!) {
          tenantName.value = '${userDet!.firstName} ${userDet!.lastName}';
          tenantId.value = userDet!.id.toString();
          sharedPreferences.setString(
              Constants.tenantId, userDet!.id.toString());
          isTenant(true);
        }
        userName.value = '${userDet!.firstName} ${userDet!.lastName}';
        // tenantDet = tempTenant;

        sharedPreferences.setString(Constants.profileUrl, userDet!.image);
        // sharedPreferences.setBool(Constants.isTenant, true);

        // if (tempTenant.isAgree == 'true') {
        //   sharedPreferences.setBool(Constants.isAgree, true);
        // } else {
        //   sharedPreferences.setBool(Constants.isAgree, false);
        // }
        // } else {
        //   isTenant(false);
        //   sharedPreferences.setString(
        //       Constants.usernamekey, userDet!.firstName);
        //   sharedPreferences.setString(Constants.phonekey, userDet!.phone);
        //   sharedPreferences.setString(Constants.emailkey, userDet!.email);
        //   sharedPreferences.setString(Constants.profileUrl, userDet!.image);
        //   userId.value = userDet!.id.toString();
        //   userName.value = userDet!.firstName;
        // }
      } else {
        setDefault();
      }
    } else {
      setDefault();
    }
    update();
    refresh();
  }

  void goToProfile() {
    Get.to(const ProfileScreenNew());
  }

  void setDefault() async {
    SharedPreferences sharedPreferences = await prefs;
    isTenant.value = false;
    userId.value = 'guest';
    userName.value = 'guest';
    tenantName.value = '';
    sharedPreferences.setString(Constants.tenantId, 'guest');
    sharedPreferences.setBool(Constants.isTenant, false);
    sharedPreferences.setBool(Constants.isAgree, false);
  }
}
