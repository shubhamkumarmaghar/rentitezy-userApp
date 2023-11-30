import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/const/appConfig.dart';

class PropertyApiController extends GetxController {
  var isLoading = true.obs;
  var isLoadingLocation = true.obs;
  var apiPropertyList = <PropertyModel>[].obs;
  var allPropertyData = <PropertyModel>[].obs;
  var selectedIndex = 0.obs;
  var locationBy = "ALL".obs;
  var categories = <String>[].obs;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var offset = 10.obs;

  @override
  void onInit() {
    fetchProperties(false);
    fetchAddress();
    super.onInit();
  }

  @override
  void onClose() {
    offset(10);
    super.onClose();
  }

  void scrollListener(bool isNext) {
    if (offset.value >= 10) {
      offset(isNext ? (offset.value + 10) : (offset.value - 10));
    }
    fetchProperties(true);
  }

  void fetchProperties(bool isNext) async {
    if (!isNext) {
      isLoading(true);
    }

    var sharedPreferences = await prefs;
    String url = '${AppUrls.listing}?limit=10&available=true&offset=$offset';
    if (locationBy.value != 'ALL') {
      url =
          '${AppUrls.listing}?limit=10&available=true&offset=$offset&location=${locationBy.value}';
    }

    final response = await http.get(
      Uri.parse(url),
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
              .map((stock) => PropertyModel.fromJson(stock))
              .toList();
          allPropertyData.addAll(apiPropertyList);
        }
        if (!isNext) {
          isLoading(false);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
  }

  void fetchAddress() async {
    isLoadingLocation(true);
    var sharedPreferences = await prefs;
    final response = await http.get(
      Uri.parse(AppUrls.locations),
      headers: <String, String>{
        "Auth-Token": sharedPreferences.getString(Constants.token).toString()
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
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
    allPropertyData.value = [];
    update();
    refresh();
    fetchProperties(false);
  }
}
