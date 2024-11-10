import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';

import '../../utils/const/app_urls.dart';
import '../dashboard/controller/dashboard_controller.dart';
import '../login/view/login_screen.dart';
import '../utils/const/appConfig.dart';
import '../utils/model/property_model.dart';

class WishlistController extends GetxController {
  RIEUserApiService apiService = RIEUserApiService();
  List<PropertyInfoModel>? wishListedPropertyList;
  final bool isLogin = GetStorage().read(Constants.isLogin) ?? false;

  @override
  void onInit() {
    super.onInit();
    if (isLogin) {
      getWishListProperty();
    } else {
      Future.delayed(const Duration(seconds: 0)).then(
        (value) {
          Get.to(() => const LoginScreen(
                canPop: true,
              ))?.then(
            (value) {
              Get.find<DashboardController>().setIndex(0);
            },
          );
        },
      );
    }


  }

  void getWishListProperty() async {
    String url = AppUrls.wishlist;
    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (response != null &&
        response['message'].toString().toLowerCase().contains('success') &&
        response['data'] != null) {
      Iterable iterable = response['data'];
      wishListedPropertyList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    } else {
      wishListedPropertyList = [];
    }
    update();
  }
}
