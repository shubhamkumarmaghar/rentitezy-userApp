import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/assets_req_model.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';
import '../../utils/model/property_model.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/custom_alert_dialogs.dart';
import '../model/property_list_nodel.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var isLoadingLocation = true.obs;
  PropertyListModel? allPropertyData;
  var apiPropertyList = <PropertyListModel>[].obs;
  var othersController = TextEditingController();
  var commentController = TextEditingController();
  var selectedIndex = 0.obs;
  var locationBy = "ALL".obs;
  var categories = <String>[].obs;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var offset = 10.obs;
  List<PropertyInfoModel>? propertyInfoList;
  List<PropertyInfoModel>? nearbyPropertyInfoList;

  final RIEUserApiService apiService = RIEUserApiService();

  String userId = 'guest';
  String userName = '';
  String imageUrl = '';
  bool isTenant = false;

  @override
  void onInit() {
    localSetup();
    fetchProperties(false);
    fetchAddress();
    super.onInit();
  }

  @override
  void onClose() {
    offset(10);
    super.onClose();
  }

  void localSetup() {
    isTenant = GetStorage().read(Constants.isTenant);
    userName = GetStorage().read(Constants.usernamekey);
    userId = GetStorage().read(Constants.userId) != null ? GetStorage().read(Constants.userId).toString() : "guest";
    imageUrl = GetStorage().read(Constants.profileUrl) ?? '';
  }

  void scrollListener(bool isNext) {
    if (offset.value >= 10) {
      offset(isNext ? (offset.value + 10) : (offset.value - 10));
    }
    fetchProperties(true);
  }

  void fetchNearbyProperties(bool isNext) async {
    if (!isNext) {
      isLoading(true);
    }
    String url = '${AppUrls.listing}?limit=10&available=true&offset=$offset';
    if (locationBy.value != 'ALL') {
      url = '${AppUrls.listing}?limit=10&available=true&offset=$offset&location=${locationBy.value}';
    }

    final response = await apiService.getApiCallWithURL(endPoint: url);

    String success = response["message"];
    try {
      if (success.toLowerCase().contains('success')) {
        if (response['data'] != null) {
          Iterable iterable = response['data'];

          propertyInfoList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
        } else {
          propertyInfoList = [];
        }
        isLoading(false);
        update();
      }
      if (!isNext) {
        isLoading(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchProperties(bool isNext) async {
    if (!isNext) {
      isLoading(true);
    }
    String url = '${AppUrls.listing}?limit=10&available=true&offset=$offset';
    if (locationBy.value != 'ALL') {
      url = '${AppUrls.listing}?limit=10&available=true&offset=$offset&location=${locationBy.value}';
    }

    final response = await apiService.getApiCallWithURL(endPoint: url);

    String success = response["message"];
    try {
      if (success.toLowerCase().contains('success')) {
        if (response['data'] != null) {
          Iterable iterable = response['data'];

          propertyInfoList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
        } else {
          propertyInfoList = [];
        }

        isLoading(false);
        update();
      }
      if (!isNext) {
        isLoading(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchAddress() async {
    isLoadingLocation(true);
    final response = await http.get(
      Uri.parse(AppUrls.locations),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      String success = body["message"];
      try {
        if (success.toLowerCase().contains('success')) {
          List<dynamic> response = body['data'] as List;
          for (var i in response) {
            categories.add(i.toString());
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      isLoadingLocation(false);
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
  }

  locationFunc(String newVal) {
    locationBy.value = newVal;
    update();
    refresh();
    fetchProperties(false);
  }


  }
