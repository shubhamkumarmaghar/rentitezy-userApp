import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rentitezy/checkout/view/checkout_screen.dart';
import 'package:rentitezy/property_details/model/property_details_model.dart';
import 'package:rentitezy/site_visit/view/site_visit_screen.dart';
import 'package:rentitezy/utils/enums/rent_type.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/functions/util_functions.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';

class PropertyDetailsController extends GetxController {
  final RIEUserApiService apiService = RIEUserApiService();
  PropertyDetailsModel? propertyDetailsModel;
  final googleMapCompleter = Completer<GoogleMapController>();
  RxInt currentImageIndex = 1.obs;
  final String propertyId;
  Rx<RentType> rentType = RentType.long.obs;
  final enquiryTextController = TextEditingController();
  List<String> propertyImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmcZfrx5HCXD6E0ROTB5onJjhxJp7u-ntyo2BbyVTgPw&s'
  ];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  PropertyDetailsController({required this.propertyId});

  @override
  void onInit() {
    super.onInit();
    fetchPropertyDetails();
  }

  Future<void> fetchPropertyDetails() async {
    String url = '${AppUrls.listingDetail}?id=$propertyId';
    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (response['message'].toLowerCase().contains('success') && response['data'] != null) {
      propertyDetailsModel = PropertyDetailsModel.fromJson(response['data']);
      if (propertyDetailsModel != null &&
          propertyDetailsModel?.images != null &&
          propertyDetailsModel!.images!.isNotEmpty) {
        propertyImages = propertyDetailsModel!.images!.map((e) => e.url ?? '').toList();
      }
    } else {
      propertyDetailsModel = PropertyDetailsModel(propId: null);
      RIEWidgets.getToast(message: response["message"].toString(), color: CustomTheme.errorColor);
    }
    update();
  }

  Future<void> navigateToMap(String? latLang) async {
    if (latLang == null || latLang.isEmpty) {
      return;
    }
    List<String> locationList = latLang.split(',');
    navigateToNativeMap(lat: locationList[0], long: locationList[1]);
  }

  // void submitPropertyEnquiry() async {
  //   showProgressLoader(Get.context!);
  //   String url = AppUrls.siteVisit;
  //   final response = await apiService.postApiCall(endPoint: url, bodyParams: {
  //     'phone': phoneController.text,
  //     'listingId': propertyId,
  //     'date': selectedDate.toString(),
  //     'type': radioGroupValue.toLowerCase(),
  //     'source': 'app'
  //   });
  //   cancelLoader();
  //   if (response["message"].toString().toLowerCase() == 'success') {
  //     RIEWidgets.getToast(message: 'You have successfully scheduled site visit', color: CustomTheme.myFavColor);
  //     Get.back();
  //   } else {
  //     RIEWidgets.getToast(message: response["message"].toString(), color: CustomTheme.errorColor);
  //   }
  // }

  void onMapCreated(GoogleMapController mapController, double lat, double lng, String title) {
    final marker = Marker(
      markerId: const MarkerId('place_name'),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: title,
      ),
    );
    markers[const MarkerId('place_name')] = marker;
    update();
  }

  void onBookNow() {
    if (propertyDetailsModel != null) {
      Get.to(() => CheckoutScreen(
            listingType: propertyDetailsModel?.listingType,
            listingId: propertyDetailsModel!.id.toString(),
            propertyUnitsList: propertyDetailsModel?.units,
          ));
    }
  }

  void onSiteVisit() {
    if (propertyDetailsModel != null) {
      Get.to(() => SiteVisitScreen(propertyId: propertyId));
    }
  }
}
