import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';

import '../../theme/custom_theme.dart';
import '../const/app_urls.dart';
import '../model/property_model.dart';
import '../view/rie_widgets.dart';
import '../widgets/custom_alert_dialogs.dart';

class UtilsApiService {
  static final RIEUserApiService apiService = RIEUserApiService();

  static Future<bool> wishlistProperty(
      {required BuildContext context, required PropertyInfoModel propertyInfoModel}) async {
    showProgressLoader(Get.context!);
    String url = AppUrls.addFav;
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      'listingId': propertyInfoModel.id.toString(),
      'wishlist': propertyInfoModel.wishlist != null && propertyInfoModel.wishlist == 0 ? '1' : '0',
    });
    if (response == null) {
      return false;
    }
    final data = response as Map<String, dynamic>;
    cancelLoader();
    if (data['message'].toString().toLowerCase().contains('success')) {
      propertyInfoModel.wishlist = propertyInfoModel.wishlist == 0 ? 1 : 0;
      return true;
    } else {
      RIEWidgets.getToast(message: '${data['message']}', color: CustomTheme.errorColor);
      return false;
    }
  }
}
