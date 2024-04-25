import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/model/property_model.dart';
import '../home/home_controller/home_controller.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/widgets.dart';

class NearByPropertyScreen extends StatelessWidget {
  final PropertyInfoModel propertyInfoModel;
  final homeController = Get.find<HomeController>();

  NearByPropertyScreen({super.key, required this.propertyInfoModel});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmcZfrx5HCXD6E0ROTB5onJjhxJp7u-ntyo2BbyVTgPw&s'
    ];
    if (propertyInfoModel.images != null && propertyInfoModel.images!.isNotEmpty) {
      images = propertyInfoModel.images!.map((e) => e.url ?? '').toList();
    }
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
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.2,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                      child: Image.network(
                        images[0],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                      width: screenWidth * 0.45,
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.007, top: screenHeight * 0.01, right: screenWidth * 0.007),
                      child: Text(
                        '${propertyInfoModel.title ?? ''},${propertyInfoModel.property?.location?.name ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Constants.primaryColor,
                        ),
                      )),
                  Container(
                      width: screenWidth * 0.45,
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.007, top: screenHeight * 0.01, right: screenWidth * 0.007),
                      child: Text(
                        '${propertyInfoModel.property?.name ?? ''},${propertyInfoModel.property?.location?.name ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Constants.primaryColor,
                        ),
                      )),
                  Container(
                      width: screenWidth * 0.4,
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.007, top: screenHeight * 0.01, right: screenWidth * 0.007),
                      child: Text(
                        '${Constants.currency}${propertyInfoModel.price ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: CustomTheme.appThemeContrast,
                        ),
                      )),
                ],
              ),
              Positioned(
                right: screenWidth * 0.02,
                top: screenHeight * 0.02,
                child: GestureDetector(
                  onTap: () async =>
                      await homeController.likeProperty(context: context, propertyInfoModel: propertyInfoModel),
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
  }
}
