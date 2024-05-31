import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../utils/widgets/app_bar.dart';
import '../utils/widgets/property_view_widget.dart';
import 'search_controller.dart';

class SearchPropertiesScreen extends StatelessWidget {
  final List<String> locationsList;

  const SearchPropertiesScreen({super.key, required this.locationsList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPropertiesController>(
      init: SearchPropertiesController(locationsList),
      builder: (controller) {
        return Scaffold(
          appBar: appBarWidget(
            title: 'Search Properties',
          ),
          body: Container(
            padding: EdgeInsets.only(
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height(0.02),
                  searchView(controller: controller),
                  height(0.02),
                  SizedBox(
                    height: screenHeight * 0.76,
                    width: screenWidth,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: controller.suggestion,
                            replacement: SizedBox(
                              height: controller.searchedPropertyList == null ||
                                      (controller.searchedPropertyList != null &&
                                          controller.searchedPropertyList!.isEmpty)
                                  ? screenHeight * 0.4
                                  : 0,
                            ),
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: screenHeight * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey, width: 0.5)),
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.showSuggestion = false;
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        controller.searchQuery.text = controller.searchedLocation[index];
                                      },
                                      child: Container(
                                          color: Colors.white,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
                                          padding: EdgeInsets.only(
                                            top: index == 0 ? screenHeight * 0.01 : 0,
                                          ),
                                          height: screenHeight * 0.055,
                                          child: Text(
                                            controller.searchedLocation[index].capitalizeFirst.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: CustomTheme.appThemeContrast),
                                          )),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Divider(
                                    color: Colors.grey,
                                  ),
                                  itemCount: controller.searchedLocation.length,
                                ),
                              ),
                            )),
                        SizedBox(height: screenHeight*0.02,),
                        controller.searchedPropertyList == null
                            ? const Center(
                                child: Text(
                                'Search location for property',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ))
                            : controller.searchedPropertyList != null && controller.searchedPropertyList!.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Property Found at ${controller.searchQuery.text}!',
                                      style: const TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  )
                                : ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: controller.searchedPropertyList!.length,
                                    itemBuilder: (context, index) {
                                      return PropertyViewWidget(
                                          propertyInfoModel: controller.searchedPropertyList![index],
                                          onWishlist: () => controller.update());
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                  ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget searchView({required SearchPropertiesController controller}) {
    return Container(
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.025,
          ),
          Container(
            height: screenHeight * 0.04,
            width: screenWidth * 0.09,
            decoration:
                BoxDecoration(color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
            child: Icon(
              Icons.location_on_outlined,
              color: Constants.primaryColor,
            ),
          ),
          Container(
            width: screenWidth * 0.55,
            padding: EdgeInsets.only(left: screenWidth * 0.03),
            child: TextField(
              controller: controller.searchQuery,
              onSubmitted: (value) {},
              onChanged: controller.onLocationTextChanged,
              style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Location',
                  hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16)),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: screenHeight * 0.04,
            width: screenWidth * 0.2,
            child: ElevatedButton(
              onPressed: () => controller.fetchProperties(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
              child: const Text('Search', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.04,
          ),
        ],
      ),
    );
  }
}
