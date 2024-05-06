import 'dart:developer';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/functions/util_functions.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../model/booking_model.dart';
import '../model/get_single_booking_model.dart';

class BookingsController extends GetxController {
  SingleBookingModel? getSingleBooking;
  List<MyBookingModelData>? myBookingData;
  var isLoading = true.obs;
  final RIEUserApiService apiService = RIEUserApiService();

  @override
  void onInit() {
    fetchMyBooking();
    super.onInit();
  }

  void fetchMyBooking() async {
    String url = AppUrls.myBooking;
    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (response['message'].toString().toLowerCase() == 'success') {
      var list = response["data"] as List;
      if (list.isNotEmpty) {
        final List<MyBookingModelData> photosList =
            (response["data"] as List).map((stock) => MyBookingModelData.fromJson(stock)).toList();
        myBookingData = photosList;
        update();
      } else {
        log('No Booking found');
        RIEWidgets.getToast(message: 'No Booking found', color: CustomTheme.white);
        myBookingData = [];
        update();
      }
    }
  }

  Future<void> getBookingDetails({required String bookingId}) async {
    String url = "${AppUrls.getSingleBooking}/?id=$bookingId";
    final response = await apiService.getApiCallWithURL(endPoint: url);
    if (response["message"].toString().toLowerCase() == 'success') {
      if (response['data'] != null) {
        getSingleBooking = SingleBookingModel.fromJson(response);
        update();
      }
    }
  }

  Future<void> navigateToMap(String? latLang) async {
    if (latLang == null || latLang.isEmpty) {
      return;
    }
    List<String> locationList = latLang.split(',');
    navigateToNativeMap(lat: locationList[0], long: locationList[1]);
  }
}
