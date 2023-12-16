import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../model/property_list_nodel.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var isLoadingLocation = true.obs;
  PropertyListModel? allPropertyData;
  var apiPropertyList = <PropertyListModel>[].obs;
 // var allPropertyData = <PropertyModel>[].obs;
  var selectedIndex = 0.obs;
  var locationBy = "ALL".obs;
  var categories = <String>[].obs;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var offset = 10.obs;

  final RIEUserApiService apiService = RIEUserApiService();

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
    String url = '${AppUrls.listing}?limit=10&available=true&offset=$offset';
    if (locationBy.value != 'ALL') {
      url =
          '${AppUrls.listing}?limit=10&available=true&offset=$offset&location=${locationBy.value}';
    }

    final response = await apiService.getApiCallWithURL(endPoint: url);

     // var body = jsonDecode(response.body);
      bool success = response["success"];
      try {
        if (success) {

          allPropertyData = PropertyListModel.fromJson(response);
             /* (response["data"] as List)
              .map((stock) => PropertyModel.fromJson(stock))
              .toList();*/
          //allPropertyData.addAll(apiPropertyList);
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
      headers: <String, String>{
        "Auth-Token": GetStorage().read(Constants.token).toString()
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
    //allPropertyData.value = [];
    update();
    refresh();
    fetchProperties(false);
  }
}
