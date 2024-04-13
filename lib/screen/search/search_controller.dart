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

class SearchPropertiesController extends GetxController {
  var isLoading = false;
  var offset = 10.obs;
  bool suggestion = false;
  final searchQuery = TextEditingController();
  var apiPropertyList = <PropertySingleData>[].obs;
  List<String> searchedLocation = [];

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  @override
  void onClose() {
    offset(10);
    super.onClose();
  }

  set showSuggestion(bool show) {
    suggestion = show;
    update();
  }

  void onLocationTextChanged(String text) {
    searchedLocation.add('BTM Layout,Bangalore');
    showSuggestion = true;
    if (text.isEmpty) {
      searchedLocation.clear();
      showSuggestion = false;
    }
    update();
  }

  void fetchProperties() async {
    isLoading = true;
    update();
    String searchUrl = '${AppUrls.listing}?location=${searchQuery.text}';
    log('param :: $searchUrl');
    final response = await http.get(
      Uri.parse(searchUrl),
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
        isLoading = false;
        showSuggestion = false;
        update();
      } catch (e) {
        log('error ::$e');
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
