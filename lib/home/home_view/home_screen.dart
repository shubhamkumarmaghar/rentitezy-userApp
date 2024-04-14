import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/screen/profile_screen_new.dart';
import 'package:rentitezy/widgets/app_drawer.dart';
import 'package:rentitezy/widgets/near_by_items.dart';
import 'package:rentitezy/widgets/recommend_items.dart';
import '../../utils/const/widgets.dart';
import '../../utils/view/rie_widgets.dart';
import '../../screen/search/all_properties_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(index == homeController.selectedIndex.value ? 18 : 15)),
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

  Widget searchWidget() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const AllPropertiesPage());
      },
      child: SizedBox(
        height: screenHeight * 0.08,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Container(
                height: screenHeight * 0.065,
                decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Icon(
                      Icons.search,
                      color: Constants.primaryColor,
                    ),
                    Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.only(left: screenWidth * 0.03),
                      child: TextField(
                        enabled: false,
                        style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by property name',
                            hintStyle:
                                TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w500, fontSize: 16)),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget buildOnGoingList() {
    return FittedBox(
      child: SizedBox(
          height: Get.height * 0.35,
          width: Get.width,
          child: Obx(
            () => homeController.isLoading.value
                ? RIEWidgets.getLoader()
                : ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: homeController.allPropertyData != null && homeController.allPropertyData?.data != null
                        ? homeController.allPropertyData!.data!.length > 5
                            ? 3
                            : homeController.allPropertyData?.data?.length
                        : 0,
                    itemBuilder: (context, index) {
                      return NearByItem(
                        propertyModel: homeController.allPropertyData?.data![index],
                      );
                    },
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          color: Constants.lightSearch,
                          fontSize: 20,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold)),
                ),
                WidgetSpan(
                  child: Text(homeController.userName,
                      style: TextStyle(
                          color: Constants.lightSearch,
                          fontSize: 20,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.to(const ProfileScreenNew()),
              child: imgLoadWid(homeController.imageUrl, 'assets/images/user_vec.png', 40, 40, BoxFit.contain),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 75),
              children: [
                searchWidget(),
                height(0.02),
                SizedBox(height: 45, width: screenWidth, child: buildTabBar()),
                height(0.04),
                Text("Near by Properties",textAlign: TextAlign.center,style: TextStyle(
                     fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CustomTheme.appThemeContrast
                ),),
                height(0.01),
                buildOnGoingList(),
                height(0.04),
                Text("Recommended Properties",textAlign: TextAlign.center,style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,

                    color: CustomTheme.appThemeContrast
                ),),
                height(0.02),
                Obx(
                  () => homeController.isLoading.value
                      ? Center(child: RIEWidgets.getLoader())
                      : Column(
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: homeController.allPropertyData?.data?.length,
                              itemBuilder: (context, index) {
                                return RecommendItem(
                                  propertyModel: homeController.allPropertyData?.data![0],
                                );
                              },
                            ),
                          ],
                        ),
                ),
                height(0.18),
              ],
            ),
          ),
        ));
  }
}
