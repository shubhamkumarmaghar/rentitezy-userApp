import 'dart:developer';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/functions/util_functions.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';
import '../model/booking_model.dart';
import '../model/booking_details_model.dart';
import '../view/booking_details_screen.dart';

class BookingsController extends GetxController {
  BookingDetailsModel? bookingDetailsModel;
  List<MyBookingModelData>? myBookingData;

  final RIEUserApiService apiService = RIEUserApiService();

  @override
  void onInit() {
    fetchMyBooking();
    super.onInit();
  }

  void fetchMyBooking({bool? showLoader}) async {
    String url = AppUrls.myBooking;
    if (showLoader != null && showLoader) {
      showProgressLoader(Get.context!);
    }
    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (showLoader != null && showLoader) {
      cancelLoader();
    }
    if (response != null &&
        response['message'].toString().toLowerCase().contains('success') &&
        response['data'] != null) {
      var list = response["data"] as List;
      if (list.isNotEmpty) {
        final List<MyBookingModelData> photosList =
            (response["data"] as List).map((stock) => MyBookingModelData.fromJson(stock)).toList();
        myBookingData = photosList;
      } else {
        RIEWidgets.getToast(message: 'No Booking found', color: CustomTheme.white);
        myBookingData = [];
      }
      update();
    }
  }

  Future<void> getBookingDetails({required String bookingId, bool? showLoader}) async {
    if (showLoader != null && showLoader) {
      showProgressLoader(Get.context!);
    }
    String url = "${AppUrls.getSingleBooking}/?id=$bookingId";
    final response = await apiService.getApiCallWithURL(endPoint: url);
    if (showLoader != null && showLoader) {
      cancelLoader();
    }
    if (response["message"].toString().toLowerCase() == 'success' && response['data'] != null) {
      bookingDetailsModel = BookingDetailsModel.fromJson(response['data']);
      Get.to(() => const BookingDetailsPage());
    } else {
      bookingDetailsModel = BookingDetailsModel();
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
