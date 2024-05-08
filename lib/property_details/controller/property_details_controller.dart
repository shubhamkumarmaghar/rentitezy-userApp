import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/checkout/view/checkout_screen.dart';
import 'package:rentitezy/property_details/model/property_details_model.dart';
import 'package:rentitezy/utils/enums/rent_type.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/const/widgets.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';

class PropertyDetailsController extends GetxController {
  final RIEUserApiService apiService = RIEUserApiService();
  PropertyDetailsModel? propertyDetailsModel;
  final googleMapCompleter = Completer<GoogleMapController>();
  RxInt currentImageIndex = 1.obs;
  final String propertyId;
  Rx<RentType> rentType = RentType.long.obs;
  final phoneController = TextEditingController(text: GetStorage().read(Constants.phonekey)?.toString() ?? '');
  List<String> propertyImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmcZfrx5HCXD6E0ROTB5onJjhxJp7u-ntyo2BbyVTgPw&s'
  ];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  DateTime selectedDate = DateTime.now().add(const Duration(days: 0));
  String radioGroupValue = 'Online';

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
      update();
    } else {}
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
    log('ggg ${{
      'phone': phoneController.text,
      'listingId': propertyId,
      'date': selectedDate.toString(),
      'type': radioGroupValue.toLowerCase(),
      'source': 'app'
    }.toString()}');
    cancelLoader();
    if (response["message"].toString().toLowerCase() == 'success') {
      RIEWidgets.getToast(message: 'You have successfully scheduled site visit', color: CustomTheme.myFavColor);
      Get.back();
    } else {
      RIEWidgets.getToast(message: response["message"].toString(), color: CustomTheme.errorColor);
    }
  }

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
      Get.to(() => CheckoutScreen(propertyDetailsModel: propertyDetailsModel!));
    }
  }

  void showSiteVisitBottomModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context!,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Center(
                          child: Text(
                            'Site Visit',
                            style: TextStyle(
                                color: CustomTheme.appThemeContrast, fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ),
                        Center(
                            child: Container(
                          height: 1,
                          width: 100,
                          color: CustomTheme.appThemeContrast,
                        )),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                activeColor: CustomTheme.appThemeContrast,
                                value: 'Online',
                                groupValue: radioGroupValue,
                                onChanged: (value) {
                                  setState(() => radioGroupValue = 'Online');
                                },
                              ),
                            ),
                            Text(
                              'Online',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.blueGrey.shade500,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.2,
                            ),
                            Transform.scale(
                              scale: 1.2,
                              child: Radio(
                                activeColor: CustomTheme.appThemeContrast,
                                value: 'Offline',
                                groupValue: radioGroupValue,
                                onChanged: (value) {
                                  setState(() => radioGroupValue = 'Offline');
                                },
                              ),
                            ),
                            Text(
                              'Offline',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.blueGrey.shade500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        const Text(
                          'Mobile Number',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: CustomTheme.appThemeContrast.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.04,
                              ),
                              Icon(
                                Icons.phone,
                                color: Constants.primaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: screenWidth * 0.78,
                                child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                  ],
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      hoverColor: Constants.hint,
                                      hintText: 'Mobile number',
                                      hintStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                                      border: InputBorder.none,
                                      labelStyle: const TextStyle(
                                          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        const Text(
                          'Date',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Center(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: CustomTheme.appThemeContrast.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => selectedDate = date);
                                }
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.03,
                                  ),
                                  Icon(Icons.calendar_today_outlined, color: Constants.primaryColor, size: 20),
                                  SizedBox(
                                    width: screenWidth * 0.05,
                                  ),
                                  Text(DateFormat.yMMMd().format(selectedDate)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.06,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (phoneController.text.isNotEmpty) {
                                submitSiteVisit();
                              } else {
                                RIEWidgets.getToast(message: 'Phone number can not be empty', color: Colors.white);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: CustomTheme.appThemeContrast,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        )
                      ],
                    ),
                  ));
            }),
          );
        });
  }
}
