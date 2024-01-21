
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../utils/const/app_urls.dart';
import '../web_view/webview_payment.dart';
import 'booking_model.dart';

class MyBookingController extends GetxController {
  var myBookingData = <MyBookingModelData>[].obs;
  RxList<Invoices> invoices = <Invoices>[].obs;

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

  Future<void> fetchBookingInvoices({required String bookingID})async{
    String url = '${AppUrls.invoice}?bookingId=$bookingID';
    final response = await homeApiController.apiService.getApiCallWithURL(endPoint: url);
    if (response['message'].toString().toLowerCase() == 'success') {
      var list = response["data"] as List;
      if(list.isNotEmpty){
        final List<Invoices> invoiceList = (response["data"] as List)
            .map((stock) => Invoices.fromJson(stock))
            .toList();
        invoices.value = invoiceList.obs;
      }
      else{
        log('No Invoice found');
        RIEWidgets.getToast(message: 'No Invoice found', color: CustomTheme.white);
      }
    }
  }


  Future<void> invoicePayment({required String invoiceId}) async {
    String url = AppUrls.invoicePay;
    // String a = 'intent://pay?pa=BasisPay1779@icici&pn=Rentiseazy&mc=&tr=ATC2933673&tn=PayTo:6546032&am=11000.00&mam=11000.00&cu=INR&/#Intent;scheme=upi;package=net.one97.paytm;end';
    // String uaa = a.replaceAll('intent', 'upi');
    //UrlLauncher.launchUrl(Uri.parse(uaa));
//
    // log('abced :::: $uaa');
    isLoading.value = true;
    // await launchUrlString('https://www.instamojo.com/@Rentiseazy/492e2287666a4abc9fddcad9c8208768');
    final response = await homeApiController.apiService.postApiCall(endPoint: url,
        bodyParams: {

          "invoiceId": invoiceId,
        });
    if (response['success']) {

      debugPrint("longurl ${response['data']}");
      String longurl = response['data']['longurl'];
      log('abced $longurl');

      //await launchUrlString(longurl);
      isLoading.value = false;
        Get.off(WebViewContainer(url: longurl));


    }
  }

}
