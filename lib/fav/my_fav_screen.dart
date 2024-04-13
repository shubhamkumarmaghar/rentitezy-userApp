import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/widgets/recommend_items.dart';
import '../../utils/const/widgets.dart';
import 'fav_controller.dart';
import 'fav_widget.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<DashboardController>().setIndex(0);
        return true;
      },
      child: GetBuilder<FavController>(
        init: FavController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                  backgroundColor: Constants.primaryColor,
                  title: Text(
                    'My Favorite',
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Get.find<DashboardController>().setIndex(0);
                    },
                  )),
              body: Obx(
                () => controller.loadFav.value
                    ? SizedBox(
                        height: screenHeight,
                        width: screenWidth,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Constants.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              title(controller.proFetch.value, 14)
                            ]),
                      )
                    : ListView.builder(
                        itemCount: controller.allWishlistData?.data?.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return WishListWidget(wishListSingleDataModel: controller.allWishlistData?.data?[index]);
                        },
                      ),
              ));
        },
      ),
    );
  }
}
