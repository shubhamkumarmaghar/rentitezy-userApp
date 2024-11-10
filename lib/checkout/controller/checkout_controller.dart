import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/checkout/view/checkout_details_screen.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../home/model/property_list_nodel.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';
import '../model/checkout_model.dart';
import '../../razorpay_payment/model/razorpay_payment_response_model.dart';
import '../../razorpay_payment/view/razorpay_payment_view.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';

class CheckoutController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final RIEUserApiService apiService = RIEUserApiService();
  Rx<DateTime> selectedDate = DateTime.now().add(const Duration(days: 0)).obs;

  RxInt selectedPropertyUnitId = 0.obs;
  RxBool monthSelected = true.obs;
  int? cartId;
  late TextEditingController guestController;
  final dayController = TextEditingController(text: '3');
  final monthController = TextEditingController(text: '11');
  final unitController = TextEditingController();
  List<String> guestCountList = [];

  final String? listingType;
  final String listingId;

  final List<Units>? propertyUnitsList;

  CheckoutController({this.listingType, required this.listingId, this.propertyUnitsList});

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: GetStorage().read(Constants.usernamekey)?.toString() ?? '');
    phoneController = TextEditingController(text: GetStorage().read(Constants.phonekey)?.toString() ?? '');
    emailController = TextEditingController(text: GetStorage().read(Constants.emailkey)?.toString() ?? '');
    if (listingType == null) {
      guestCountList = ['1', '2', '3'];
      guestController = TextEditingController(text: guestCountList.first);
      return;
    }
    if (listingType!.contains('1BHK')) {
      guestCountList = ['1', '2'];
    } else if (listingType!.contains('2BHK')) {
      guestCountList = ['1', '2', '3', '4'];
    } else if (listingType!.contains('3BHK')) {
      guestCountList = ['1', '2', '3', '4', '5'];
    } else if (listingType!.contains('Studio')) {
      guestCountList = ['1', '2'];
    }
    guestController = TextEditingController(text: guestCountList.last);
  }

  Future<void> submitBookingRequest() async {
    if (selectedPropertyUnitId.value == 0) {
      RIEWidgets.getToast(message: 'Please select unit', color: CustomTheme.errorColor);
      return;
    }

    showProgressLoader(Get.context!);
    final dateFormat = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    String duration = monthSelected.value ? '${monthController.text}m' : '${dayController.text}d';

    String url =
        "${AppUrls.checkout}?checkin=$dateFormat&duration=$duration&guest=${guestController.text}&listingId=$listingId&unitId=${selectedPropertyUnitId.value}";

    final response = await apiService.getApiCallWithURL(endPoint: url);

    cancelLoader();
    if (response != null &&
        response["message"].toString().toLowerCase().contains('success') &&
        response['data'] != null) {
      final checkoutModel = CheckoutModel.fromJson(response['data']);
      cartId = checkoutModel.cartId;
      Get.to(() => CheckoutDetailsScreen(checkoutModel: checkoutModel));
    }
  }

  void requestPayment(String cartId) async {

    if (cartId.trim().isEmpty) {
      return;
    }
    showProgressLoader(Get.context!);
    String url = AppUrls.checkoutV2;

    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "cartId": cartId,
      "source": 'app'
    });
    cancelLoader();

    if (response != null &&
        response['message'] != null &&
        response['message'].toString().toLowerCase().contains('success') &&
        response['data'] != null) {
      final data = response['data'] as Map<String, dynamic>;
      Get.to(RazorpayPaymentView(
        paymentResponseModel: RazorpayPaymentResponseModel.fromJson(data),
        guestCount: int.parse(guestController.text.isNotEmpty ? guestController.text : '1'),
      ))?.then((value) {
        cancelLoader();
      },);
    } else {
      RIEWidgets.getToast(message: response["message"].toString(), color: CustomTheme.errorColor);
    }
  }

  void onSelectDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      selectedDate.value = date;
    }
  }
}
