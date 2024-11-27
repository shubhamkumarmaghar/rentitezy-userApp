import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/model/property_model.dart';
import 'package:rentitezy/utils/services/utils_api_service.dart';

import '../../checkout/view/checkout_screen.dart';
import '../../property_details/view/property_details_screen.dart';
import '../../site_visit/view/site_visit_screen.dart';
import '../const/widgets.dart';
import '../functions/util_functions.dart';
import '../view/rie_widgets.dart';

class NearByPropertyWidget extends StatelessWidget {
  final PropertyInfoModel propertyInfoModel;

  const NearByPropertyWidget({super.key, required this.propertyInfoModel});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmcZfrx5HCXD6E0ROTB5onJjhxJp7u-ntyo2BbyVTgPw&s'
    ];
    if (propertyInfoModel.images != null && propertyInfoModel.images!.isNotEmpty) {
      images = propertyInfoModel.images!.map((e) => e.url ?? '').toList();
    }
    return GetBuilder<HomeController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () async {
            Get.to(() => PropertyDetailsScreen(propertyId: propertyInfoModel.id?.toString() ?? ''));
          },
          child: Container(
            padding: EdgeInsets.only(left: screenWidth * 0.005),
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02),
              margin: EdgeInsets.only(left: screenWidth * 0.009, bottom: screenHeight * 0.007),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: screenWidth * 0.48,
                        height: 170,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                            child: CachedNetworkImage(
                              memCacheHeight: 125,
                              memCacheWidth: (screenWidth * 0.45).toInt(),
                              imageUrl: images[0],
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
                            )),
                      ),
                      Container(
                          width: screenWidth * 0.48,
                          padding: EdgeInsets.only(left: screenWidth * 0.007, top: 8, right: screenWidth * 0.007),
                          child: Text(
                            propertyInfoModel.title ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Constants.primaryColor,
                            ),
                          )),
                      Container(
                          width: screenWidth * 0.48,
                          padding: EdgeInsets.only(left: screenWidth * 0.007, top: 8, right: screenWidth * 0.007),
                          child: Text(
                            propertyInfoModel.property?.location?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          )),
                      Container(
                        width: screenWidth * 0.48,
                        padding: EdgeInsets.only(left: screenWidth * 0.007, top: 8, right: screenWidth * 0.007),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${Constants.currency}${propertyInfoModel.price ?? ''}/M*',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: CustomTheme.appThemeContrast,
                              ),
                            ),
                            Visibility(
                              visible: propertyInfoModel.furnishType != null,
                              replacement: const SizedBox.shrink(),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: 2),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appThemeContrast.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(2)),
                                child: Text('${propertyInfoModel.furnishType.toString().capitalizeFirst}-Furnished',
                                    style: TextStyle(
                                        color: CustomTheme.appThemeContrast,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => SiteVisitScreen(propertyId: propertyInfoModel.id.toString()));
                            },
                            child: Container(
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: CustomTheme.appThemeContrast, borderRadius: BorderRadius.circular(5)),
                              width: screenWidth * 0.22,
                              child: const Text(
                                'Site Visit',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          width(0.02),
                          GestureDetector(
                            onTap: () {
                              if (availableToBook(dateTime: propertyInfoModel.availFrom)) {
                                Get.to(() => CheckoutScreen(
                                      listingType: propertyInfoModel.listingType,
                                      listingId: propertyInfoModel.id.toString(),
                                      propertyUnitsList: propertyInfoModel.units,
                                    ));
                              } else {
                                RIEWidgets.getToast(
                                    message: 'Not available for booking', color: CustomTheme.errorColor);
                              }
                            },
                            child: Container(
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: availableToBook(dateTime: propertyInfoModel.availFrom)
                                      ? Constants.primaryColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(5)),
                              width: screenWidth * 0.22,
                              child: const Text(
                                'Book Now',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: screenWidth * 0.02,
                    top: 18,
                    child: GestureDetector(
                      onTap: () async {
                        final res = await UtilsApiService.wishlistProperty(
                            context: context, propertyInfoModel: propertyInfoModel);
                        if (res) {
                          controller.update();
                        }
                      },
                      child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            size: 20,
                            propertyInfoModel.wishlist == 1 ? Icons.favorite : Icons.favorite_border,
                            color: propertyInfoModel.wishlist == 1 ? CustomTheme.errorColor : Constants.primaryColor,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
