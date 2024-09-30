import 'dart:developer';
import 'package:get/get.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';

import '../../utils/const/app_urls.dart';
import '../utils/model/property_model.dart';

class WishlistController extends GetxController {
  RIEUserApiService apiService = RIEUserApiService();
  List<PropertyInfoModel>? wishListedPropertyList;

  @override
  void onInit() {
    getWishListProperty();
    super.onInit();
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
