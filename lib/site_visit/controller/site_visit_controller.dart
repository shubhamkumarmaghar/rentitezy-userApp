
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';

class SiteVisitController extends GetxController {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 0));
  String radioGroupValue = 'Online';
  final phoneController = TextEditingController(text: GetStorage().read(Constants.phonekey)?.toString() ?? '');
  final RIEUserApiService apiService = RIEUserApiService();
  final String propertyId;

  SiteVisitController({required this.propertyId});

  void onSiteVisitModeChange(String? mode) {
    radioGroupValue = mode ?? 'Online';
    update();
  }

  void onShowCalender() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      selectedDate = date;
      update();
    }
  }

  void submitSiteVisit() async {
    showProgressLoader(Get.context!);
    String url = AppUrls.siteVisit;
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      'phone': phoneController.text,
      'listingId': propertyId,
      'date': selectedDate.toString(),
      'type': radioGroupValue.toLowerCase(),
      'source': 'app'
    });
    cancelLoader();
    if (response["message"].toString().toLowerCase() == 'success') {
      RIEWidgets.getToast(message: 'You have successfully scheduled site visit', color: CustomTheme.myFavColor);
      Get.back();
    } else {
      RIEWidgets.getToast(message: response["message"].toString(), color: CustomTheme.errorColor);
    }
  }
}
