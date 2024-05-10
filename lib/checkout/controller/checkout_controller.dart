import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/checkout/view/checkout_details_screen.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../model/checkout_model.dart';
import '../../property_details/model/property_details_model.dart';
import '../../razorpay_payment/model/razorpay_payment_response_model.dart';
import '../../razorpay_payment/view/razorpay_payment_view.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../widgets/custom_alert_dialogs.dart';

class CheckoutController extends GetxController {
  late TextEditingController nameController;

  late TextEditingController emailController;

  late TextEditingController phoneController;

  final RIEUserApiService apiService = RIEUserApiService();
  Rx<DateTime> selectedDate = DateTime.now().add(const Duration(days: 0)).obs;
  final PropertyDetailsModel propertyDetailsModel;
  RxInt selectedMonths = 1.obs;
  RxInt selectedDays = 1.obs;
  RxInt selectedPropertyUnitId = 0.obs;
  RxBool monthSelected = true.obs;
  int? cartId;

  final guestController = TextEditingController(text: '1');
  final dayController = TextEditingController(text: '3');
  final monthController = TextEditingController(text: '11');
  final unitController = TextEditingController();

  CheckoutController({required this.propertyDetailsModel});

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: GetStorage().read(Constants.usernamekey)?.toString() ?? '');
    phoneController = TextEditingController(text: GetStorage().read(Constants.phonekey)?.toString() ?? '');
    emailController = TextEditingController(text: GetStorage().read(Constants.emailkey)?.toString() ?? '');
  }

  Future<void> submitBookingRequest() async {
    if (selectedPropertyUnitId.value == 0) {
      RIEWidgets.getToast(message: 'Please select unit', color: CustomTheme.errorColor);
      return;
    }
    // if (selectedPropertyUnitId.value > 1) {
    //   showTextAlertDialog(
    //       context: Get.context!,
    //       onYesTap: () {
    //         Get.back();
    //         submitBookingRequest();
    //       },
    //       title: 'Booking Alert',
    //       subTitle: 'Valid ID /KYC should be provided at the time on check in');
    // }

    showProgressLoader(Get.context!);
    final dateFormat = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    String duration = monthSelected.value ? '${selectedMonths}m' : '${selectedDays}d';

    String url =
        "${AppUrls.checkout}?checkin=$dateFormat&duration=$duration&guest=${guestController.text}&listingId=${propertyDetailsModel.id}&unitId=${selectedPropertyUnitId.value}";

    final response = await apiService.getApiCallWithURL(endPoint: url);

    Get.back();
    if (response["message"].toString().toLowerCase() == 'success' && response['data'] != null) {
      final checkoutModel = CheckoutModel.fromJson(response['data']);
      cartId = checkoutModel.cartId;
      Get.to(() => CheckoutDetailsScreen(checkoutModel: checkoutModel));
    } else {
      RIEWidgets.getToast(message: response["message"].toString(), color: CustomTheme.errorColor);
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
    if (response['message'] != 'failure' && response['data'] != null) {
      final data = response['data'] as Map<String, dynamic>;
      Get.to(RazorpayPaymentView(paymentResponseModel: RazorpayPaymentResponseModel.fromJson(data)));
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
