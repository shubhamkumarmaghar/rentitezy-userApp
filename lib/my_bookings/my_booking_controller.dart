import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/const/app_urls.dart';
import 'booking_model.dart';

class MyBookingController extends GetxController {
  var myBookingData = <MyBookingModelData>[].obs;
  var isLoading = true.obs;

  HomeController homeApiController = Get.find();
  @override
  void onInit() {
    fetchMyBooking();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }


  void fetchMyBooking() async {
    String url = AppUrls.myBooking;
    isLoading(true);
    final response = await homeApiController.apiService.getApiCallWithURL(endPoint: url);
  /*  var response = await http.get(Uri.parse(AppUrls.myBooking), headers: {
      'auth-token': GetStorage().read(Constants.token).toString()
    });*/
   // var responseData = jsonDecode(response.body);
    await Future.delayed(const Duration(seconds: 2));
      if (response['success']) {
        var list = response["data"] as List;
        if(list.isNotEmpty){
        final List<MyBookingModelData> photosList = (response["data"] as List)
            .map((stock) => MyBookingModelData.fromJson(stock))
            .toList();
        myBookingData.value = photosList.obs;
      }
        else{
          log('No Booking found');
          RIEWidgets.getToast(message: 'No Booking found', color: CustomTheme.white);
        }
        }
      isLoading(false);
  }
}
