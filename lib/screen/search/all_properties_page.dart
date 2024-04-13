import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rentitezy/home/model/property_list_nodel.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/widgets/search_items.dart';

import 'search_controller.dart';

class AllPropertiesPage extends StatelessWidget {
  const AllPropertiesPage({super.key});

  Widget searchWidget({required BuildContext context, required SearchPropertiesController controller}) {
    return SizedBox(
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
                      controller: controller.searchQuery,
                      onSubmitted: (value) {
                        controller.fetchProperties();
                      },
                      onChanged: controller.onLocationTextChanged,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPropertiesController>(
      init: SearchPropertiesController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              backgroundColor: Constants.primaryColor,
              title: Text(
                'Search Properties',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily, color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Get.back(),
              )),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchWidget(context: context, controller: controller),
                  const SizedBox(
                    height: 10,
                  ),
                  controller.suggestion
                      ? Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: screenHeight * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: CustomTheme.appThemeContrast, width: 0.5)),
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => controller.showSuggestion = false,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
                                      padding: EdgeInsets.only(
                                        top: index == 0 ? screenHeight * 0.01 : 0,
                                      ),
                                      height: screenHeight * 0.055,
                                      child: Text(
                                        controller.searchedLocation[index],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: CustomTheme.appThemeContrast),
                                      )),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                color: CustomTheme.appThemeContrast,
                              ),
                              itemCount: controller.searchedLocation.length,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    height: screenHeight * 0.8,
                    child: controller.isLoading
                        ? Center(
                            child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(Constants.primaryColor),
                          ))
                        : ListView.builder(
                            itemCount: controller.apiPropertyList.length,
                            itemBuilder: (context, index) {
                              return SearchItem(
                                propertyModel: controller.apiPropertyList[index],
                              );
                            },
                          ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
