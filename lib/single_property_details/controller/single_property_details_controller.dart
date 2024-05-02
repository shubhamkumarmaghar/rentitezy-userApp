import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../../home/home_controller/home_controller.dart';
import '../../model/checkout_model.dart';
import '../../razorpay_payment/model/razorpay_payment_response_model.dart';
import '../../razorpay_payment/view/razorpay_payment_view.dart';
import '../../screen/checkout_screen.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/api.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../web_view/webview_payment.dart';
import '../model/single_property_details_model.dart';

class SinglePropertyDetailsController extends GetxController {
  String? id = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool singlePage = true.obs;
  List<bool> list = [true, false];
  List<bool> sitiVisitTypeList = [true, false];
  final RIEUserApiService apiService = RIEUserApiService();

  void setChip({required int selectedIndex}) {
    list = list.map((e) => false).toList();
    list[selectedIndex] = true;
  }

  void setSourceChip({required int selectedIndex}) {
    sitiVisitTypeList = sitiVisitTypeList.map((e) => false).toList();
    sitiVisitTypeList[selectedIndex] = true;
  }

  RxString proFetch = 'Data Fetching...Please wait'.obs;
  List<String> guestList = ['1', '2', '3', '4', '5'];
  List<String> monthList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
  List<String> sourceList = ['Source', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];

  List<String> getDailyList() {
    List<String> monthList = [];
    for (int i = 1; i < 32; i++) {
      monthList.add('$i');
    }
    return monthList;
  }

  var dropdownValueGuest;
  var dropdownValueMonth = '11';
  var dropdownValueSource = 'Source';
  var dropdownValueDaily = '1';
  Units? unitId;

  var selectFlat;
  CheckoutModel? checkoutModel;

  DateTime currentDate = DateTime.now();
  SinglePropertyDetails? singleProPerty;
  final List propertyImages = [];

  @override
  void onInit() {
    super.onInit();
    getalldata();
  }

  void getalldata() async {
    id = await Get.arguments ?? '0';
    log('property ID $id');
    await getSinglePropertyDetails();
    nameController = TextEditingController(text: GetStorage().read(Constants.usernamekey).toString());
    phoneController = TextEditingController(text: GetStorage().read(Constants.phonekey).toString());
    emailController = TextEditingController(text: GetStorage().read(Constants.emailkey).toString());
  }

  Future<void> getSinglePropertyDetails() async {
    String url = '${AppUrls.listingDetail}?id=$id';
    singlePage.value = true;
    final response = await apiService.getApiCallWithURL(endPoint: url);
    String success = response["message"];
    if (success.toLowerCase() == 'success') {
      singleProPerty = SinglePropertyDetails.fromJson(response);
      update();
    } else {
      proFetch.value = 'Currently unavailable';
      update();
    }
    singlePage.value = false;
    update();
  }

  void submitReqBooking(
    String from, {
    required String unitId,
  }) async {
    showProgressLoader(Get.context!);
    String duration = '';
    singlePage.value = true;
    final f = DateFormat('yyyy-MM-dd');
    if (list[0] == true) {
      duration = '${dropdownValueMonth}m';
    } else {
      duration = '${dropdownValueDaily}d';
    }
    log('kkkkk $unitId');
    String url =
        "${AppUrls.checkout}?checkin=${f.format(currentDate)}&duration=$duration&guest=$dropdownValueGuest&listingId=${singleProPerty?.data?.id}&unitId=$unitId";
    final response = await apiService.getApiCallWithURL(endPoint: url);
    String success = response["message"];
    if (success.toLowerCase() == 'success') {
      if (response['data'] != null) {
        checkoutModel = CheckoutModel.fromJson(response['data']);
        Get.back();
        await Get.to(CheckOutPage(
            from: from, currentDate: currentDate, propertyModel: singleProPerty, checkoutModel: checkoutModel));
      }
    } else {
      singlePage.value = false;
      Get.back();
    }
  }

  void submitSiteVisit(String from) async {
    singlePage.value = true;
    String url = AppUrls.siteVisit;
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      'phone': phoneController.text,
      'listingId': id,
      'date': currentDate.toString(),
      'type': sitiVisitTypeList[0] == true ? 'online' : 'offline',
      'source': 'app'
    });

    String success = response["message"];
    if (success.toString().toLowerCase() == 'success') {
      RIEWidgets.getToast(message: 'You have successfully scheduled site visit', color: CustomTheme.white);
      singlePage.value = false;
      Get.back();
    } else {
      Get.back();
      singlePage.value = false;
    }
  }

  void paymentRequest(String cartId) async {
    String url = AppUrls.checkoutV2;
    singlePage.value = true;

    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "cartId": cartId,
      "source": 'app'
    });
    if (response['message'] != 'failure') {
      singlePage.value = false;
      final data = response['data'] as Map<String, dynamic>;
      Get.back();

      Get.to(RazorpayPaymentView(paymentResponseModel: RazorpayPaymentResponseModel.fromJson(data)));
    }
  }
}
