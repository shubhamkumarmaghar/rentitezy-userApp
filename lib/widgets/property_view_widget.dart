import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/appConfig.dart';
import '../utils/model/property_model.dart';
import '../utils/services/utils_api_service.dart';

class PropertyViewWidget extends StatelessWidget {
  final PropertyInfoModel propertyInfoModel;
  final homeController = Get.find<HomeController>();
  final Function onWishlist;

  PropertyViewWidget({super.key, required this.propertyInfoModel, required this.onWishlist});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmcZfrx5HCXD6E0ROTB5onJjhxJp7u-ntyo2BbyVTgPw&s'
    ];
    if (propertyInfoModel.images != null && propertyInfoModel.images!.isNotEmpty) {
      images = propertyInfoModel.images!.map((e) => e.url ?? '').toList();
    }
    return Container(
      color: Colors.white,
      height: screenHeight * 0.46,
      padding: EdgeInsets.only(bottom: screenHeight * 0.015),
      child: GestureDetector(
        onTap: () {
          Get.to(
              () => PropertiesDetailsPageNew(
                    propertyId: '${propertyInfoModel.id}',
                  ),
              arguments: '${propertyInfoModel.id}');
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
                    height: screenHeight * 0.25,
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
                          .map((e) => ClipRRect(
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
                                  placeholder: (context, url) => loading(),
                                  errorWidget: (context, url, error) => Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                              image: AssetImage('assets/images/app_logo.png'), fit: BoxFit.contain),
                                        ),
                                      ))))
                          .toList(),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.03,
                    bottom: screenHeight * 0.02,
                    child: GestureDetector(
                      onTap: () async {
                        final res = await UtilsApiService.wishlistProperty(
                            context: context, propertyInfoModel: propertyInfoModel);
                        if (res) {
                          onWishlist();
                        }
                      },
                      child: Container(
                        height: screenHeight * 0.045,
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
                    top: screenHeight * 0.015,
                    child: Container(
                      height: screenHeight * 0.03,
                      width: screenWidth * 0.13,
                      decoration:
                          BoxDecoration(color: CustomTheme.propertyTextColor, borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.photo_camera,
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
              height(0.01),
              Container(
                  width: screenWidth * 0.88,
                  padding: EdgeInsets.only(left: screenWidth * 0.023, right: screenWidth * 0.023),
                  child: Text(
                    '${propertyInfoModel.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 20, color: Colors.black, wordSpacing: 3, fontWeight: FontWeight.w500),
                  )),
              height(0.006),
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
              height(0.006),
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
              height(0.006),
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
              height(0.008),
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
                        child: Text('Available From : ${getLocalTime(propertyInfoModel.availFrom ?? '')}',
                            style:
                                const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500))),
                    Visibility(
                      visible: propertyInfoModel.furnishType != null,
                      replacement: const SizedBox.shrink(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015, vertical: screenHeight * 0.005),
                        decoration: BoxDecoration(
                            color: CustomTheme.appThemeContrast.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        child: Text('${propertyInfoModel.furnishType.toString().capitalizeFirst}-Furnished',
                            style: TextStyle(color: CustomTheme.appThemeContrast, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLocalTime(String dateTime) {
    if (dateTime.isEmpty) {
      return 'NA';
    }
    var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime, true);
    var showDate = '${date.toLocal().year}-${handleZero(date.toLocal().month)}-${handleZero(date.toLocal().day)}';
    return showDate;
  }

  String handleZero(int data) {
    return data < 10 ? '0$data' : data.toString();
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
}
