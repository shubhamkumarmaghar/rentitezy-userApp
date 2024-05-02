import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';
import '../utils/view/rie_widgets.dart';
import '../widgets/property_view_widget.dart';
import 'wishlist_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (invoked) {
        Get.find<DashboardController>().setIndex(0);
      },
      child: GetBuilder<WishlistController>(
        init: WishlistController(),
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
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Get.find<DashboardController>().setIndex(0);
                    },
                  )),
              body: Container(
                height: screenHeight,
                width: screenWidth,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: controller.wishListedPropertyList == null
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : controller.wishListedPropertyList != null && controller.wishListedPropertyList!.isEmpty
                        ? RIEWidgets.noData(message: 'No wishListed property found!')
                        : ListView.builder(
                            itemCount: controller.wishListedPropertyList?.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return PropertyViewWidget(
                                propertyInfoModel: controller.wishListedPropertyList![index],
                                onWishlist: () => controller.getWishListProperty(),
                              );
                            },
                          ),
              ));
        },
      ),
    );
  }
}
