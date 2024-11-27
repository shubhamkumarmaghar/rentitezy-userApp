import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentitezy/search/widgets/search_screen_widgets.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/model/data_model.dart';
import '../../utils/secret/.secret_keys.dart';
import '../../utils/widgets/property_view_widget.dart';
import '../controller/search_controller.dart';

class SearchPropertiesScreen extends StatelessWidget {
  final String location;
  final String title;
  final DataModel? propertyType;

  const SearchPropertiesScreen({super.key, required this.location, required this.title, this.propertyType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPropertiesController>(
      init: SearchPropertiesController(location: location, propertyType: propertyType),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                )),
            actions: [
              IconButton(
                onPressed: () => showSortBottomModalSheet(controller),
                icon: const Icon(
                  Icons.filter_alt_sharp,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => showFiltersBottomModalSheet(controller),
                icon: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.01,
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
            ),
          ),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            padding: EdgeInsets.only(
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                getSearchField(controller,context),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: controller.searchedPropertyList == null
                      ? const Center(child: CircularProgressIndicator.adaptive())
                      : controller.searchedPropertyList != null && controller.searchedPropertyList!.isEmpty
                          ? const Center(
                              child: Text(
                                'No Property Found!',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            )
                          : SmartRefresher(
                              controller: controller.searchedPropertyRefreshController,
                              cacheExtent: 9999999,
                              enablePullUp: true,
                              header: WaterDropMaterialHeader(
                                color: Constants.primaryColor,
                                backgroundColor: Colors.white,
                                distance: 60,
                              ),
                              physics: const ScrollPhysics(),
                              onRefresh: () async {
                                await controller.getPropertyListRefresher(true);
                              },
                              onLoading: () async {
                                await controller.getPropertyListRefresher(false);
                              },
                              //footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 10),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.searchedPropertyList!.length,
                                itemBuilder: (context, index) {
                                  return PropertyViewWidget(
                                      propertyInfoModel: controller.searchedPropertyList![index],
                                      onWishlist: () => controller.update());
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                  height: 0,
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getSearchField(SearchPropertiesController controller,BuildContext context) {
    return SizedBox(
      height: 60,
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller.searchQuery,
        googleAPIKey: placesAndroidKey,
        inputDecoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search Location',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            decoration:
                BoxDecoration(color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
            child: Icon(
              Icons.location_on_outlined,
              color: Constants.primaryColor,
            ),
          ),
        ),
        countries: const ["in"],
        isLatLngRequired: false,
        itemClick: (Prediction prediction) {
          if (prediction.description == null || prediction.description!.isEmpty) {
            return;
          }

          List<String> places = prediction.description!.split(',');
          controller.searchQuery.text = places.first;
          controller.pageNumber = 0;
          FocusScope.of(context).requestFocus(FocusNode());
          controller.fetchProperties();
        },
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Constants.primaryColor,
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text(prediction.description ?? ""))
              ],
            ),
          );
        },
        seperatedBuilder: const Divider(),
        isCrossBtnShown: true,
        containerHorizontalPadding: 10,
        placeType: PlaceType.geocode,
      ),
    );
  }
}
