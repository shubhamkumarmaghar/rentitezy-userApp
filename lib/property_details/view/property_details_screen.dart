import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rentitezy/property_details/controller/property_details_controller.dart';
import 'package:rentitezy/property_details/model/property_details_model.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/enums/rent_type.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:rentitezy/utils/widgets/youtube_player_widget.dart';
import 'package:unicons/unicons.dart';
import '../../login/view/login_screen.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/functions/util_functions.dart';
import '../../utils/services/utils_api_service.dart';
import '../../utils/widgets/custom_photo_view.dart';
import '../widgets/property_details_widgets.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertyDetailsController>(
      init: PropertyDetailsController(propertyId: propertyId),
      builder: (controller) {
        final data = controller.propertyDetailsModel;
        if (data == null) {
          return Scaffold(
            body: SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: const Center(child: CircularProgressIndicator.adaptive())),
          );
        } else if (data.propId == null) {
          return Scaffold(
            body: Container(
              height: screenHeight * 0.55,
              width: screenWidth,
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.06,
                  ),
                  goBackWidget(arrowColor: Colors.white, backgroundColor: Constants.primaryColor),
                  const Spacer(),
                  RIEWidgets.noData(message: 'No Details found !'),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.44,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomTheme.appThemeContrast,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: controller.onSiteVisit,
                      child: const Text(
                        'Site Visit',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                ),
                SizedBox(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.44,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              availableToBook(dateTime: data.availFrom) ? Constants.primaryColor : Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        if (availableToBook(dateTime: data.availFrom)) {
                          controller.onBookNow();
                        } else {
                          RIEWidgets.getToast(message: 'Not available for booking', color: CustomTheme.errorColor);
                        }
                      },
                      child: const Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                )
              ],
            ),
          ),
          body: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  propertyImages(images: controller.propertyImages, controller: controller),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      data.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      data.property?.name ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, color: CustomTheme.propertyTextColor),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  propertyLocation(controller: controller, model: data),
                  propertyRent(controller: controller, model: data),
                  propertyFeatures(controller: controller, model: data),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    margin: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        color: Constants.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
                    child: Visibility(
                        visible: data.availFrom != null && data.availFrom!.isNotEmpty,
                        child: calculateDateDifference(
                            dateTime: data.availFrom, shouldShowAvailFrom: true, textColor: Constants.primaryColor)),
                  ),
                  propertyDescription(controller: controller, model: data),
                  propertyAmenities(controller: controller, model: data),
                  // propertyEnquiry(controller: controller, model: data),
                  showGoogleMaps(controller: controller, model: data),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
