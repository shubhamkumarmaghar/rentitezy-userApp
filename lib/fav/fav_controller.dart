import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/fav_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/const/app_urls.dart';
import '../home/model/property_list_nodel.dart';

class FavController extends GetxController {
  PropertyListModel? allWishlistData;
  RIEUserApiService apiService = RIEUserApiService();
  var loadFav = false.obs;
  var apiFavPropertyList = <FavModel>[].obs;
  var loadProperty = false.obs;
  //var apiPropertyList = <Property>[].obs;
  var proFetch = 'Data Fetching...Please wait'.obs;
  @override
  void onInit() {
    //fetchFavProperties();
    getWishListProperty();
    super.onInit();
  }

  void fetchFavProperties() async {
    loadFav(true);
    debugPrint(
        'WISH: ${AppUrls.wishlist} -- ${GetStorage().read(Constants.token).toString()}');
    final response = await http.get(
      Uri.parse(AppUrls.wishlist),
      headers: <String, String>{
        "Auth-Token": GetStorage().read(Constants.token).toString()
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          apiFavPropertyList.value = (body["data"] as List)
              .map((stock) => FavModel.fromJson(stock))
              .toList();
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

  void getWishListProperty()async {
    String url = AppUrls.wishlist;
    final response = await apiService.getApiCallWithURL(endPoint: url);

    bool success = response["success"];
    try {
      if (success) {

        allWishlistData = PropertyListModel.fromJson(response);
        /* (response["data"] as List)
              .map((stock) => PropertyModel.fromJson(stock))
              .toList();*/
        //allPropertyData.addAll(apiPropertyList);
      }
    } catch (e) {
      debugPrint(e.toString());
    }


  }

  Future<FlatModel?> fetchProperties(String id) async {
    debugPrint('id ${id.toString()}');
    loadProperty(true);
    final response = await http.get(
      Uri.parse('${AppUrls.listingDetail}?id=$id'),
      headers: <String, String>{
        "Auth-Token": GetStorage().read(Constants.token).toString()
      },
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
      headers: <String, String>{
        "Auth-Token": GetStorage().read(Constants.token).toString()
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          return (body["data"] as List)
              .map((stock) => PropertyModel.fromJson(stock))
              .toList();
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
