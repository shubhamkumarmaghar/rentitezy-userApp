import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:unicons/unicons.dart';

import '../../checkout/view/checkout_screen.dart';
import '../../property_details/view/property_details_screen.dart';
import '../../site_visit/view/site_visit_screen.dart';
import '../const/appConfig.dart';
import '../functions/util_functions.dart';
import '../model/property_model.dart';
import '../services/utils_api_service.dart';


class PropertyViewWidget extends StatelessWidget {
  final PropertyInfoModel propertyInfoModel;
  final Function onWishlist;

  const PropertyViewWidget({super.key, required this.propertyInfoModel, required this.onWishlist});

  @override
  Widget build(BuildContext context) {
    bool canNavigateToMap = false;
    List<String> images = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmcZfrx5HCXD6E0ROTB5onJjhxJp7u-ntyo2BbyVTgPw&s'
    ];
    if (propertyInfoModel.images != null && propertyInfoModel.images!.isNotEmpty) {
      images = propertyInfoModel.images!.map((e) => e.url ?? '').toList();
    }
    if (propertyInfoModel.property?.latlng != null) {
      if (propertyInfoModel.property?.latlng != '' &&
          propertyInfoModel.property?.latlng!.contains('undefined') == false) {
        canNavigateToMap = true;
      }
    }
    return Container(
      color: Colors.white,
      height: 450,
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => PropertyDetailsScreen(propertyId: propertyInfoModel.id?.toString() ?? ''));
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          borderOnForeground: false,
          elevation: 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 215,
                    width: screenWidth,
                    child: FlutterCarousel(
                      options: CarouselOptions(
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        disableCenter: true,
                        viewportFraction: 1,
                        indicatorMargin: 12.0,
                        enableInfiniteScroll: false,
                        showIndicator: true,
                        slideIndicator: CircularSlideIndicator(
                            indicatorRadius: 3,
                            currentIndicatorColor: CustomTheme.appThemeContrast.withOpacity(0.7),
                            alignment: Alignment.bottomCenter,
                            indicatorBackgroundColor: Colors.white),
                      ),
                      items: images
                          .map(
                            (e) => ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                memCacheHeight: (screenHeight * 0.25).toInt(),
                                memCacheWidth: screenWidth.toInt(),
                                imageUrl: e,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.03,
                    bottom: 17,
                    child: GestureDetector(
                      onTap: () async {
                        final res = await UtilsApiService.wishlistProperty(
                            context: context, propertyInfoModel: propertyInfoModel);
                        if (res) {
                          onWishlist();
                        }
                      },
                      child: Container(
                        height: 38,
                        width: screenWidth * 0.1,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                        child: Icon(
                          propertyInfoModel.wishlist != null && propertyInfoModel.wishlist == 1
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: propertyInfoModel.wishlist != null && propertyInfoModel.wishlist == 1
                              ? CustomTheme.errorColor
                              : Constants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.03,
                    top: 12,
                    child: Container(
                      height:25,
                      width: screenWidth * 0.13,
                      decoration:
                          BoxDecoration(color: CustomTheme.propertyTextColor, borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            '${images.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
             const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: screenWidth * 0.7,
                      padding: EdgeInsets.only(left: screenWidth * 0.023, right: screenWidth * 0.023),
                      child: Text(
                        '${propertyInfoModel.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black, wordSpacing: 3, fontWeight: FontWeight.w500),
                      )),
                  Visibility(
                    visible: canNavigateToMap,
                    replacement: const SizedBox.shrink(),
                    child: GestureDetector(
                      onTap: () => navigateToMap(propertyInfoModel.property?.latlng),
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.015),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: 3),
                        decoration: BoxDecoration(
                            color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(3)),
                        child: Row(
                          children: [
                            Icon(
                              UniconsLine.map_pin_alt,
                              size: getScreenWidth * 0.04,
                              color: Constants.primaryColor,
                            ),
                            SizedBox(
                              width: getScreenWidth * 0.01,
                            ),
                            Text(
                              'Map',
                              style:
                                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Constants.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.only(left: screenWidth * 0.023),
                child: Row(
                  children: [
                    Text(
                      '${propertyInfoModel.property?.name}, ',
                      style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${propertyInfoModel.property?.location?.name}',
                      style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                  padding: EdgeInsets.only(left: screenWidth * 0.023),
                  child: Text(
                    '${Constants.currency}${propertyInfoModel.price}/M*',
                    style: TextStyle(
                        color: CustomTheme.appThemeContrast,
                        fontSize: 18,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600),
                  )),
              const SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.only(left: screenWidth * 0.023),
                child: Row(
                  children: [
                    iconWidget('sqr_feet'),
                    const Text(
                      'Sq Ft : ',
                      style: TextStyle(color: CustomTheme.propertyTextColor, fontSize: 14),
                    ),
                    Text('${propertyInfoModel.area}',
                        style: const TextStyle(color: CustomTheme.propertyTextColor, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.023),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: propertyInfoModel.availFrom != null,
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
                        child: Text('Available From : ${getLocalTime(propertyInfoModel.availFrom)}',
                            style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500))),
                    Visibility(
                      visible: propertyInfoModel.furnishType != null,
                      replacement: const SizedBox.shrink(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015, vertical: screenHeight * 0.005),
                        decoration: BoxDecoration(
                            color: CustomTheme.appThemeContrast.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text('${propertyInfoModel.furnishType.toString().capitalizeFirst}-Furnished',
                            style: TextStyle(
                                color: CustomTheme.appThemeContrast, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.023),
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      width: screenWidth * 0.3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomTheme.appThemeContrast,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          onPressed: () async {
                            Get.to(() => SiteVisitScreen(propertyId: propertyInfoModel.id.toString()));
                          },
                          child: const Text(
                            'Site Visit',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                    ),
                    width(0.05),
                    SizedBox(
                      height: 35,
                      width: screenWidth * 0.3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          onPressed: (){
                            Get.to(() => CheckoutScreen(
                              listingType: propertyInfoModel.listingType,
                              listingId:  propertyInfoModel.id.toString(),
                              propertyUnitsList: propertyInfoModel.units,
                            ));
                          },
                          child: const Text(
                            'Book Now',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconWidget(String name) {
    return Image.asset(
      'assets/images/$name.png',
      fit: BoxFit.contain,
      height: 20,
      width: 20,
      color: CustomTheme.propertyTextColor,
    );
  }

  Future<void> navigateToMap(String? latLang) async {
    if (latLang == null || latLang.isEmpty) {
      return;
    }
    List<String> locationList = latLang.split(',');
    navigateToNativeMap(lat: locationList[0], long: locationList[1]);
  }
  // void onBookNow() {
  //   if (propertyDetailsModel != null) {
  //     Get.to(() => CheckoutScreen(propertyDetailsModel: propertyDetailsModel!));
  //   }
  // }
  //
}
