import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../web_view/webview_payment.dart';
import '../model/booking_model.dart';
import '../model/get_single_booking_model.dart';

class MyBookingController extends GetxController {
  SingleBookingModel? getSingleBooking;
  List<MyBookingModelData>? myBookingData;
  RxList<Invoices> invoices = <Invoices>[].obs;
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
      getSingleBooking = SingleBookingModel.fromJson(response);
      update();
    }
  }

  Future<void> fetchBookingInvoices({required String bookingID}) async {
    String url = '${AppUrls.invoice}?bookingId=$bookingID';
    final response = await apiService.getApiCallWithURL(endPoint: url);
    if (response['message'].toString().toLowerCase() == 'success') {
      var list = response["data"] as List;
      if (list.isNotEmpty) {
        final List<Invoices> invoiceList = (response["data"] as List).map((stock) => Invoices.fromJson(stock)).toList();
        invoices.value = invoiceList.obs;
      } else {
        log('No Invoice found');
        RIEWidgets.getToast(message: 'No Invoice found', color: CustomTheme.white);
      }
    }
  }

  Future<void> invoicePayment({required String invoiceId}) async {
    String url = AppUrls.invoicePay;
    isLoading.value = true;
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      "invoiceId": invoiceId,
    });
    if (response['success']) {
      String longurl = response['data']['longurl'];
      log('abced $longurl');

      //await launchUrlString(longurl);
      isLoading.value = false;
      Get.off(WebViewContainer(url: longurl));
    }
  }
}
