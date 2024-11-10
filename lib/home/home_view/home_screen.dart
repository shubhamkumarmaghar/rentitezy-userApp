import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import '../../search/view/search_properties_screen.dart';
import '../../utils/const/widgets.dart';
import '../../utils/repo/property_repository.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/app_drawer.dart';
import '../../utils/widgets/nearby_property_widget.dart';
import '../../utils/widgets/property_view_widget.dart';

class MyHomePage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(HomeController());

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      //init: HomeController(),
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            RIEWidgets.showExitDialog(context);
          },
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              drawer: AppDrawer(),
              appBar: AppBar(
                centerTitle: true,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                backgroundColor: Constants.primaryColor,
                title: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Text("Hi, ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: Constants.fontsFamily,
                                fontWeight: FontWeight.w500)),
                      ),
                      WidgetSpan(
                        child: Text(controller.userName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: Constants.fontsFamily,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
              body: Container(
                height: screenHeight,
                width: screenWidth,
                padding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, top: screenHeight * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(0.02),
                    searchView(controller),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(0.03),
                            if (controller.nearbyPropertyInfoList != null &&
                                controller.nearbyPropertyInfoList!.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Near by Properties",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w600, color: CustomTheme.appThemeContrast),
                                  ),
                                  controller.nearbyPropertyInfoList != null &&
                                          controller.nearbyPropertyInfoList!.length > 5
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => SearchPropertiesScreen(
                                                location: controller.currentLocation,
                                                title: 'Near by Properties',
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "See All",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: CustomTheme.appThemeContrast),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            if (controller.nearbyPropertyInfoList != null &&
                                controller.nearbyPropertyInfoList!.isNotEmpty)
                              height(0.02),
                            if (controller.nearbyPropertyInfoList != null &&
                                controller.nearbyPropertyInfoList!.isNotEmpty)
                              nearByPropertiesList(controller),
                            if (controller.nearbyPropertyInfoList != null &&
                                controller.nearbyPropertyInfoList!.isNotEmpty)
                              height(0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recommended Properties",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600, color: CustomTheme.appThemeContrast),
                                ),
                                controller.propertyInfoList != null && controller.propertyInfoList!.length > 5
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => const SearchPropertiesScreen(
                                              location: '',
                                              title: 'Recommended Properties',
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "See All",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: CustomTheme.appThemeContrast),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            height(0.02),
                            controller.propertyInfoList == null
                                ? Center(child: RIEWidgets.getLoader())
                                : controller.propertyInfoList != null && controller.propertyInfoList!.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No Property Found!',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: controller.propertyInfoList!.length,
                                        itemBuilder: (context, index) {
                                          return PropertyViewWidget(
                                              propertyInfoModel: controller.propertyInfoList![index],
                                              onWishlist: () => controller.update());
                                        },
                                      ),
                            height(0.02),
                            controller.propertyInfoList == null
                                ? const SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => const SearchPropertiesScreen(
                                          location: '',
                                          title: 'Recommended Properties',
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          color: Constants.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * 0.03,
                                          ),
                                          Text(
                                            'View all recommended properties',
                                            style: TextStyle(fontSize: 16, color: Constants.primaryColor),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.arrow_forward_outlined,
                                            color: Constants.primaryColor,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.03,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            height(0.03),
                            Text(
                              "Looking For",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: CustomTheme.appThemeContrast),
                            ),
                            height(0.02),
                            propertyByType(),
                            height(0.03),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget searchView(HomeController homeController) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const SearchPropertiesScreen(
              location: '',
              title: 'Search Properties',
            ));
      },
      child: Container(
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.03,
            ),
            Container(
              height: screenHeight * 0.04,
              width: screenWidth * 0.09,
              decoration:
                  BoxDecoration(color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
              child: Icon(
                Icons.location_on_outlined,
                size: screenHeight * 0.025,
                color: Constants.primaryColor,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
            const Text(
              'Search Location',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              height: screenHeight * 0.04,
              width: screenWidth * 0.2,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const SearchPropertiesScreen(
                        location: '',
                        title: 'Search Properties',
                      ));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
                child: const Text('Search', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyByType() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: propertyTypeList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 20, childAspectRatio: 1.0, mainAxisSpacing: 20),
      itemBuilder: (BuildContext context, int index) {
        var data = propertyTypeList[index];
        return GestureDetector(
          onTap: () => Get.to(
            () => SearchPropertiesScreen(
              location: '',
              propertyType: data,
              title: 'Properties',
            ),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                  image: NetworkImage(
                      'https://img.freepik.com/free-photo/blue-house-with-blue-roof-sky-background_1340-25953.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Text(
              data.name,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget nearByPropertiesList(HomeController homeController) {
    return FittedBox(
      child: SizedBox(
          height: homeController.nearbyPropertyInfoList != null && homeController.nearbyPropertyInfoList!.isNotEmpty
              ? 330
              : 100,
          width: screenWidth,
          child: homeController.nearbyPropertyInfoList == null
              ? Center(child: RIEWidgets.getLoader())
              : homeController.nearbyPropertyInfoList != null && homeController.nearbyPropertyInfoList!.isEmpty
                  ? Center(
                      child: Text(
                        'No any nearby property found!',
                        style: TextStyle(fontSize: 18, color: CustomTheme.grey),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: homeController.nearbyPropertyInfoList!.length > 5
                          ? 5
                          : homeController.nearbyPropertyInfoList!.length,
                      itemBuilder: (context, index) {
                        return NearByPropertyWidget(
                          propertyInfoModel: homeController.nearbyPropertyInfoList![index],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: screenWidth * 0.04,
                      ),
                    )),
    );
  }
}
