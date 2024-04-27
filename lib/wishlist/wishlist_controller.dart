import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/fav_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';

import '../../utils/const/app_urls.dart';
import '../utils/model/property_model.dart';

class WishlistController extends GetxController {
  WishlistModel? allWishlistData;
  RIEUserApiService apiService = RIEUserApiService();
  List<PropertyInfoModel>? wishListedPropertyList;
  var loadFav = false.obs;
  var apiFavPropertyList = <WishlistModel>[].obs;
  var loadProperty = false.obs;
  var proFetch = 'Data Fetching...Please wait'.obs;

  @override
  void onInit() {
    getWishListProperty();
    super.onInit();
  }

  void getWishListProperty() async {
    String url = AppUrls.wishlist;
    final response = await apiService.getApiCallWithURL(endPoint: url);

    try {
      if (response['message'].toString().toLowerCase() == 'success') {
        if (response['data'] != null) {
          Iterable iterable = response['data'];
          wishListedPropertyList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
        } else {
          wishListedPropertyList = [];
        }
      }
      update();
    } catch (e) {
      wishListedPropertyList = [];
      update();
      log('Error while wishlist :: ${e.toString()}');
    }
  }
}
