import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/screen/profile_screen_new.dart';
import 'package:rentitezy/widgets/app_drawer.dart';
import 'package:rentitezy/widgets/near_by_items.dart';
import 'package:rentitezy/widgets/property_view_widget.dart';
import '../../search/search_properties_screen.dart';
import '../../utils/const/widgets.dart';
import '../../utils/view/rie_widgets.dart';

class MyHomePage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final homeController = Get.put(HomeController());

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
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
                      child: Text(homeController.userName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: Constants.fontsFamily,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () => Get.to(const ProfileScreenNew()),
                  child: const Icon(Icons.settings),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              padding: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03, top: screenHeight * 0.01),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(0.02),
                    searchView(),
                    height(0.03),
                    SizedBox(height: 45, width: screenWidth, child: buildTabBar()),
                    height(0.04),
                    Text(
                      "Near by Properties",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomTheme.appThemeContrast),
                    ),
                    height(0.02),
                    buildOnGoingList(),
                    height(0.04),
                    Text(
                      "Recommended Properties",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomTheme.appThemeContrast),
                    ),
                    height(0.02),
                    homeController.propertyInfoList == null
                        ? Center(child: RIEWidgets.getLoader())
                        : homeController.propertyInfoList != null && homeController.propertyInfoList!.isEmpty
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
                                itemCount: homeController.propertyInfoList?.length,
                                itemBuilder: (context, index) {
                                  return PropertyViewWidget(propertyInfoModel: homeController.propertyInfoList![index],onWishlist: ()=>controller.update());
                                },
                              ),
                    height(0.02),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget buildTabBar() {
    return Obx(() => homeController.isLoadingLocation.value
        ? Center(child: RIEWidgets.getLoader())
        : ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: homeController.categories.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
              onTap: () {
                homeController.selectedIndex.value = index;
                homeController.locationFunc(homeController.categories[index]);
              },
              child: Obx(
                    () => AnimatedContainer(
                    margin: EdgeInsets.fromLTRB(index == 0 ? 15 : 5, 0, 5, 0),
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: index == homeController.selectedIndex.value
                          ? Constants.primaryColor
                          : Constants.primaryColor.withOpacity(0.1),
                    ),
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      alignment: Alignment.center,
                      child: Text(
                        homeController.categories[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: index == homeController.selectedIndex.value ? Colors.white : Colors.black,
                        ),
                      ),
                    )),
              ));
        }));
  }

  Widget searchView() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const SearchPropertiesScreen());
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
                  Get.to(() => const SearchPropertiesScreen());
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

  Widget buildOnGoingList() {
    return FittedBox(
      child: SizedBox(
          height: Get.height * 0.33,
          width: Get.width,
          child: homeController.propertyInfoList == null
              ? Center(child: RIEWidgets.getLoader())
              : homeController.propertyInfoList != null && homeController.propertyInfoList!.isEmpty
              ? const Center(
            child: Text(
              'No Property Found!',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
              : ListView.separated(
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount:
            homeController.propertyInfoList!.length > 5 ? 5 : homeController.propertyInfoList!.length,
            itemBuilder: (context, index) {
              return NearByPropertyScreen(
                propertyInfoModel: homeController.propertyInfoList![index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              width: screenWidth * 0.05,
            ),
          )),
    );
  }
}
