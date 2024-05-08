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
import '../../utils/model/property_model.dart';
import '../theme/custom_theme.dart';
import '../utils/services/rie_user_api_service.dart';
import '../utils/view/rie_widgets.dart';

class SearchPropertiesController extends GetxController {
  var isLoading = false;
  var offset = 10.obs;
  bool suggestion = false;
  final searchQuery = TextEditingController();
  List<PropertyInfoModel>? searchedPropertyList;
  var apiPropertyList = <PropertySingleData>[].obs;
  List<String> searchedLocation = [];
  final List<String> locationsList;
  final RIEUserApiService apiService = RIEUserApiService();

  SearchPropertiesController(this.locationsList);

  @override
  void onInit() {
    super.onInit();
    searchedLocation.addAll(locationsList);
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
    //searchedLocation.clear();
    // searchedLocation.add(text);
    searchedLocation[0] = text;
    showSuggestion = true;
    if (text.isEmpty) {
      //searchedLocation.clear();
      fetchProperties();
      showSuggestion = false;
    }
    update();
  }

  void fetchProperties() async {
    isLoading = true;
    update();
    String url = '${AppUrls.listing}?available=true&location=${searchQuery.text}';
    if (searchQuery.text.trim().isEmpty) {
      url = '${AppUrls.listing}?available=true';
    }
    final response = await apiService.getApiCallWithURL(endPoint: url);

    isLoading = false;
    if (response["message"].toString().toLowerCase().contains('success') && response['data'] != null) {
      Iterable iterable = response['data'];
      searchedPropertyList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    } else {
      searchedPropertyList = [];
      RIEWidgets.getToast(message: response["message"] ?? 'Something went wrong!', color: CustomTheme.errorColor);
    }
    log('length ${searchedPropertyList?.length}');
    update();
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }
}
