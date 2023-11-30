import 'dart:convert';

import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/const/app_urls.dart';
import 'booking_model.dart';

class MyBookingController extends GetxController {
  var myBookingData = <MyBookingModel>[].obs;
  var isLoading = true.obs;
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  @override
  void onInit() {
    fetchMyBooking();
    super.onInit();
  }

  void fetchMyBooking() async {
    SharedPreferences sharedPreferences = await pref;
    isLoading(true);
    var response = await http.get(Uri.parse(AppUrls.myBooking), headers: {
      'auth-token': sharedPreferences.getString(Constants.token).toString()
    });
    var responseData = jsonDecode(response.body);
    await Future.delayed(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      if (responseData['success']) {
        final List<MyBookingModel> photosList = (responseData["data"] as List)
            .map((stock) => MyBookingModel.fromJson(stock))
            .toList();
        myBookingData.value = photosList.obs;
      }
      isLoading(false);
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
  }
}
