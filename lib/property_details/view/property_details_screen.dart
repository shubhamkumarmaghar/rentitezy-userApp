import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:unicons/unicons.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/functions/util_functions.dart';
import '../../utils/services/utils_api_service.dart';
import '../../utils/widgets/custom_photo_view.dart';

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
                          backgroundColor: Constants.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: controller.onBookNow,
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Visibility(
                        visible: data.availFrom != null && data.availFrom!.isNotEmpty,
                        replacement: const Row(
                          children: [
                            Text('Not Available',
                                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.info,
                              color: Colors.grey,
                              size: 18,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            const Text('Available From',
                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                          Text( calculateDateDifference(data.availFrom ??'') < 1 ?'Available Now':getLocalTime(data.availFrom),
                                style: TextStyle(
                                    color: Colors.blueGrey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        )),
                  ),
                  propertyDescription(controller: controller, model: data),
                  propertyAmenities(controller: controller, model: data),
                  propertyEnquiry(controller: controller, model: data),
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

  Widget showGoogleMaps({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    if (model == null || model.property == null) {
      return const SizedBox.shrink();
    }
    return Visibility(
      visible: model.property?.lat != null &&
          model.property!.lat!.isNotEmpty &&
          model.property?.long != null &&
          model.property!.long!.isNotEmpty,
      replacement: const SizedBox.shrink(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Text(
              'Map',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            SizedBox(
              height: screenHeight * 0.25,
              child: GoogleMap(
                  markers: controller.markers.values.toSet(),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: false,

                  // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                  //   ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                  //   ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                  //   ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                  //   ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())
                  //   ),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(controller.propertyDetailsModel!.property!.lat!),
                          double.parse(controller.propertyDetailsModel!.property!.long!)),
                      zoom: 17.0,
                      tilt: 0,
                      bearing: 0),
                  onMapCreated: (GoogleMapController mapController) {
                    controller.googleMapCompleter.complete(mapController);
                    controller.onMapCreated(
                        mapController,
                        double.parse(controller.propertyDetailsModel!.property!.lat!),
                        double.parse(controller.propertyDetailsModel!.property!.long!),
                        model.property?.name ?? '');
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyAmenities({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    if (model == null || model.listingAmenities == null) {
      return const SizedBox.shrink();
    }
    return Visibility(
      visible: model.listingAmenities!.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              'Property Amenities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: model.listingAmenities?.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 20, childAspectRatio: 5),
                itemBuilder: (BuildContext context, int index) {
                  final data = model.listingAmenities![index];
                  return Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.network(
                          data.amenity?.appIcon ?? '',
                          color: CustomTheme.appThemeContrast,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Text(data.amenity?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54))
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget propertyEnquiry({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Text(
            'Property Enquiry',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            padding: const EdgeInsets.all(5),
            width: screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //  color: Constants.primaryColor.withOpacity(0.1),
                border: Border.all(color: Colors.grey, width: 0.5)),
            height: screenHeight * 0.15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.65,
                  child: TextField(
                    controller: controller.enquiryTextController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hoverColor: Constants.hint,
                        contentPadding: const EdgeInsets.only(left: 10, right: 10),
                        hintText: 'Ask your question',
                        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade400),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.075),
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomTheme.appThemeContrast,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () async {
                        RIEWidgets.getToast(message: 'Coming soon...', color: CustomTheme.myFavColor);
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget propertyDescription({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Text(
            'Property Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
          ),
          SizedBox(
            height: screenHeight * 0.005,
          ),
          Text(
            model?.description ?? '',
            style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget propertyFeatures({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Text(
            'Property Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.5, color: Constants.primaryColor)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      '${model?.property?.floor ?? ''}th Floor',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Constants.primaryColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.5, color: Constants.primaryColor)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      '${model?.furnishType?.toString().capitalizeFirst ?? ''}-Furnished',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Constants.primaryColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.5, color: Constants.primaryColor)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      '${model?.area?.toString() ?? ''} Sqft',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Constants.primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.5, color: Constants.primaryColor)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      model?.listingType ?? '',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Constants.primaryColor),
                    ),
                  ),
                  Visibility(
                    visible: model?.balconies != null,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 0.5, color: Constants.primaryColor)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        '${model?.balconies.toString()} Balcony',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Constants.primaryColor),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: model?.bathrooms != null,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 0.5, color: Constants.primaryColor)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        '${model?.bathrooms.toString()} Bathroom',
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Constants.primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget propertyRent({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    if (model == null) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      return Column(
        children: [
          SizedBox(
            height: screenHeight * 0.025,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rent',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${Constants.currency} ${getPrice(rentType: controller.rentType.value, model: model)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Deposit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${Constants.currency} ${getDepositAmount(rentType: controller.rentType.value, model: model)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Maintenance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${Constants.currency} ${model.property?.maintenance ?? 0.toString()}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  String getPrice({required RentType rentType, required PropertyDetailsModel model}) {
    if (rentType == RentType.long) {
      return model.price?.toString() ?? '';
    } else if (rentType == RentType.short) {
      return model.stPrice?.toString() ?? '';
    } else {
      return model.dailyPrice?.toString() ?? '';
    }
  }

  String getDepositAmount({required RentType rentType, required PropertyDetailsModel model}) {
    if (rentType == RentType.long) {
      return model.deposit?.toString() ?? '';
    } else if (rentType == RentType.short) {
      return model.stDeposit?.toString() ?? '';
    } else {
      return model.rent?.toString() ?? '';
    }
  }

  Widget propertyImages({required List<String> images, required PropertyDetailsController controller}) {
    return Stack(
      children: [
        Container(
          height: screenHeight * 0.38,
          width: screenWidth,
          padding: EdgeInsets.only(bottom: screenHeight * 0.03),
          child: FlutterCarousel(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              disableCenter: true,
              viewportFraction: 1,
              indicatorMargin: 12.0,
              onPageChanged: (index, reason) {
                controller.currentImageIndex.value = index + 1;
              },
              enableInfiniteScroll: false,
              showIndicator: false,
              slideIndicator: CircularSlideIndicator(
                  indicatorRadius: 3,
                  currentIndicatorColor: CustomTheme.appThemeContrast.withOpacity(0.7),
                  alignment: Alignment.bottomCenter,
                  indicatorBackgroundColor: Colors.white),
            ),
            items: images
                .map((e) => CachedNetworkImage(
                    memCacheHeight: (screenHeight * 0.25).toInt(),
                    memCacheWidth: screenWidth.toInt(),
                    imageUrl: e,
                    imageBuilder: (context, imageProvider) => GestureDetector(
                          onTap: () => Get.to(() => CustomPhotoView(
                                imageUrl: e,
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/dummy_image.png'), fit: BoxFit.contain),
                          ),
                        ),
                    errorWidget: (context, url, error) => Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/dummy_image.png'), fit: BoxFit.contain),
                          ),
                        )))
                .toList(),
          ),
        ),
        Positioned(
          right: screenWidth * 0.02,
          bottom: screenHeight * 0.07,
          child: Obx(() {
            return Container(
              height: screenHeight * 0.03,
              width: screenWidth * 0.2,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  Text(
                    '${controller.currentImageIndex} / ${images.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
            );
          }),
        ),
        Positioned(
          left: screenWidth * 0.03,
          top: screenHeight * 0.06,
          child: goBackWidget(),
        ),
        Positioned(
          right: screenWidth * 0.03,
          top: screenHeight * 0.06,
          child: GestureDetector(
            onTap: () async {
              controller.wishlistProperty();
            },
            child: Container(
              height: screenHeight * 0.045,
              width: screenWidth * 0.1,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Icon(
                controller.propertyDetailsModel?.wishlist != null && controller.propertyDetailsModel?.wishlist == 1
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 20,
                color:
                    controller.propertyDetailsModel?.wishlist != null && controller.propertyDetailsModel?.wishlist == 1
                        ? CustomTheme.errorColor
                        : Constants.primaryColor,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: screenWidth * 0.1,
          child: Obx(() {
            return Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.06,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade400, width: 0.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => controller.rentType.value = RentType.long,
                    child: Container(
                      width: screenWidth * 0.22,
                      height: screenHeight * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.rentType.value == RentType.long ? Constants.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Long Term',
                        style: TextStyle(
                            fontSize: 14,
                            color: controller.rentType.value == RentType.long ? Colors.white : Constants.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.rentType.value = RentType.short,
                    child: Container(
                      width: screenWidth * 0.22,
                      height: screenHeight * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            controller.rentType.value == RentType.short ? Constants.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Short Term',
                        style: TextStyle(
                            fontSize: 14,
                            color: controller.rentType.value == RentType.short ? Colors.white : Constants.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.rentType.value = RentType.daily,
                    child: Container(
                      width: screenWidth * 0.22,
                      height: screenHeight * 0.04,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            controller.rentType.value == RentType.daily ? Constants.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Daily',
                        style: TextStyle(
                            fontSize: 14,
                            color: controller.rentType.value == RentType.daily ? Colors.white : Constants.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget goBackWidget({Color? arrowColor, Color? backgroundColor}) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        height: screenHeight * 0.045,
        width: screenWidth * 0.1,
        decoration: BoxDecoration(color: backgroundColor ?? Colors.white, borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
              color: arrowColor ?? Constants.primaryColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyLocation({required PropertyDetailsController controller, PropertyDetailsModel? model}) {
    return Visibility(
      visible: model?.property?.address != null,
      replacement: const SizedBox.shrink(),
      child: GestureDetector(
        onTap: () => controller.navigateToMap(model?.property?.latlng),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Icon(UniconsLine.map_pin_alt, size: 20, color: Constants.primaryColor),
              SizedBox(
                width: screenWidth * 0.01,
              ),
              SizedBox(
                width: screenWidth * 0.7,
                child: Text(
                  model?.property?.address ?? 'ff',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.blueGrey.shade500),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  UniconsLine.navigator,
                  color: Constants.primaryColor,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
