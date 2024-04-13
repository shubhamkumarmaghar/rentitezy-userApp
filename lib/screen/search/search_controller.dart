import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/home/model/property_list_nodel.dart';
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
  var apiPropertyList = <PropertySingleData>[].obs;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    searchQuery.addListener(
      () => fetchProperties(true),
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
    String ur = '${AppUrls.listing}?limit=10&offset=$offset';
    String search = '${AppUrls.listing}?limit=10&offset=$offset&location=${searchQuery.text}';
    final response = await http.get(
      Uri.parse(searchQuery.text.isEmpty ? ur : search),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          Iterable iterable = body["data"];
          apiPropertyList.value = iterable.map((flat) => PropertySingleData.fromJson(flat)).toList();
          log('apiPropertyList ${apiPropertyList.length}  ');
        }
        if (!isNext) {
          isLoading(false);
        }
      } catch (e) {
        log('error ::'+e.toString());
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
