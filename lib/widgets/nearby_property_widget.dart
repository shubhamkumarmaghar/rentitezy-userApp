
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/model/property_model.dart';
import 'package:rentitezy/utils/services/utils_api_service.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/widgets.dart';

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
            Get.to(
              () => PropertiesDetailsPageNew(
                propertyId: propertyInfoModel.id.toString(),
              ),
              arguments: propertyInfoModel.id.toString(),
            );
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
              margin: EdgeInsets.only(left: screenWidth * 0.009, bottom: screenHeight * 0.005),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      SizedBox(
                        width: screenWidth * 0.48,
                        height: screenHeight * 0.2,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                            child: CachedNetworkImage(
                                memCacheHeight: (screenHeight * 0.15).toInt(),
                                memCacheWidth: (screenWidth * 0.45).toInt(),
                                imageUrl: images[0],
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
                                    ))),
                      ),
                      Container(
                          width: screenWidth * 0.48,
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.007, top: screenHeight * 0.01, right: screenWidth * 0.007),
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
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.007, top: screenHeight * 0.01, right: screenWidth * 0.007),
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
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.007, top: screenHeight * 0.01, right: screenWidth * 0.007),
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
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.002),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appThemeContrast.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(2)
                                ),
                                child: Text('${propertyInfoModel.furnishType.toString().capitalizeFirst}-Furnished',
                                    style: TextStyle(color: CustomTheme.appThemeContrast, fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: screenWidth * 0.02,
                    top: screenHeight * 0.02,
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
