import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/const/app_urls.dart';

class SearchPController extends GetxController {
  var isLoading = false.obs;
  var userId = 'guest'.obs;
  var isSearching = false.obs;
  var searchText = "".obs;
  var offset = 10.obs;
  final key = GlobalKey<ScaffoldState>();
  final searchQuery = TextEditingController();
  var apiPropertyList = <FlatModel>[].obs;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  @override
  void onInit() {
    searchQuery.addListener(
      () => fetchProperties(false),
    );
    fetchProperties(false);
    super.onInit();
  }

  void scrollListener(bool isNext) {
    if (offset.value >= 10) {
      offset(isNext ? (offset.value + 10) : (offset.value - 10));
    }
    fetchProperties(true);
  }

  @override
  void onClose() {
    offset(10);
    super.onClose();
  }

  void fetchProperties(bool isNext) async {
    if (!isNext) {
      isLoading(true);
    }
    var sharedPreferences = await prefs;
    String ur = '${AppUrls.listing}?limit=10&offset=$offset';
    String search =
        '${AppUrls.listing}?limit=10&offset=$offset&location=${searchQuery.text}';
    final response = await http.get(
      Uri.parse(searchQuery.text.isEmpty ? ur : search),
      headers: <String, String>{
        "Auth-Token": sharedPreferences.getString(Constants.token).toString()
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          apiPropertyList.value = (body["data"] as List)
              .map((stock) => FlatModel.fromJson(stock))
              .toList();
          print('apiPropertyList ${apiPropertyList.length}');
        }
        if (!isNext) {
          isLoading(false);
        }
      } catch (e) {
        // if (kDebugMode) {
        print(e);
        //}
      }
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }
}
