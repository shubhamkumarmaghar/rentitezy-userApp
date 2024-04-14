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

class FavController extends GetxController {
  WishlistModel? allWishlistData;
  RIEUserApiService apiService = RIEUserApiService();
  var loadFav = false.obs;
  var apiFavPropertyList = <WishlistModel>[].obs;
  var loadProperty = false.obs;

  //var apiPropertyList = <Property>[].obs;
  var proFetch = 'Data Fetching...Please wait'.obs;

  @override
  void onInit() {
    getWishListProperty();
    super.onInit();
  }

  void fetchFavProperties() async {
    loadFav(true);
    debugPrint('WISH: ${AppUrls.wishlist} -- ${GetStorage().read(Constants.token).toString()}');
    final response = await http.get(
      Uri.parse(AppUrls.wishlist),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          allWishlistData = WishlistModel.fromJson(body);
          /* apiFavPropertyList.value = (body["data"] as List)
              .map((stock) => WishlistModel.fromJson(stock))
              .toList();*/
          debugPrint('qqqqq- ${apiFavPropertyList.length}');
        } else {
          proFetch.value = 'Currently unavailable';
        }
        loadFav(false);
      } catch (e) {
        loadFav(false);
      }
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
  }

  void getWishListProperty() async {
    String url = AppUrls.wishlist;
    loadFav.value = true;
    final response = await apiService.getApiCallWithURL(endPoint: url);
    final responseHome = await apiService.getApiCallWithURL(endPoint: 'https://api.rentiseazy.com/user/home');

    bool success = response["success"];


    try {
      if (response['message'].toString().toLowerCase() == 'success') {
        allWishlistData = WishlistModel.fromJson(response);
      }
      if (responseHome['message'].toString().toLowerCase() == 'success') {
        log('Home data :: $responseHome');
      }
      loadFav.value = false;
    } catch (e) {
      debugPrint(e.toString());
      loadFav.value = false;
    }
  }

  Future<FlatModel?> fetchProperties(String id) async {
    debugPrint('id ${id.toString()}');
    loadProperty(true);
    final response = await http.get(
      Uri.parse('${AppUrls.listingDetail}?id=$id'),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      debugPrint('body ${body.toString()}');
      debugPrint('body ${body["data"].toString()}');
      bool success = body["success"];
      try {
        if (success) {
          return FlatModel.fromJson(body["data"]);
        }
        loadProperty(false);
      } catch (e) {
        debugPrint('bodyErrr ${e.toString()}');
        loadProperty(false);
        return null;
      }
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
    return null;
  }

  Future<List<PropertyModel>> fetchListingDetails(String id) async {
    final response = await http.get(
      Uri.parse('${AppUrls.property}?id=$id'),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          return (body["data"] as List).map((stock) => PropertyModel.fromJson(stock)).toList();
        }
        loadProperty(false);
      } catch (e) {
        loadProperty(false);
        return [];
      }
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
    return [];
  }
}
