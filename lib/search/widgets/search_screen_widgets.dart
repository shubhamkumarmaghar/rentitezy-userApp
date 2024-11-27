import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/search/controller/search_controller.dart';
import 'package:rentitezy/utils/model/data_model.dart';

import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';

void showFiltersBottomModalSheet(SearchPropertiesController controller) async {
  showModalBottomSheet(
    isScrollControlled: true,
    context: Get.context!,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (BuildContext context, setState) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Property Filters',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                  Center(
                      child: Container(
                    height: 0.5,
                    width: screenWidth,
                    color: Colors.grey.shade400,
                  )),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  getDropDownButton(
                      hint: 'Select Address',
                      itemsList: controller.searchedLocation,
                      value: controller.selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          controller.selectedLocation = newValue!;
                          controller.searchQuery.text = controller.selectedLocation;
                        });
                      }),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'Property Type',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  getDropDownDataModelButton(
                      hint: 'Property Type',
                      itemsList: controller.propertyTypeList,
                      value: controller.selectedPropertyType,
                      onChanged: (DataModel? newValue) {
                        setState(() {
                          controller.selectedPropertyType = newValue!;
                        });
                      }),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'Furnish Type',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  getDropDownDataModelButton(
                      hint: 'Furnish Type',
                      itemsList: controller.furnishTypeList,
                      value: controller.selectedFurnishType,
                      onChanged: (DataModel? newValue) {
                        setState(() {
                          controller.selectedFurnishType = newValue!;
                        });
                      }),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'Bath',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  getDropDownButton(
                      hint: 'Bath',
                      itemsList: controller.bathroomsList,
                      value: controller.selectedBathroom,
                      onChanged: (String? newValue) {
                        setState(() {
                          controller.selectedBathroom = newValue!;
                        });
                      }),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Obx(
                    () {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${Constants.currency}${controller.priceRange.value.start.round()}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
                          ),
                          Text(
                            '${Constants.currency}${controller.priceRange.value.end.round()}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Obx(
                    () {
                      return SliderTheme(
                        data: SliderThemeData(
                            valueIndicatorColor: Constants.primaryColor,
                            showValueIndicator: ShowValueIndicator.always,
                            overlayShape: SliderComponentShape.noThumb,
                            valueIndicatorTextStyle: const TextStyle(color: Colors.white)),
                        child: RangeSlider(
                          activeColor: Constants.primaryColor,
                          values: controller.priceRange.value,
                          onChanged: (value) {
                            controller.priceRange.value = value;
                          },
                          max: 100000,
                          min: 6000,
                          labels: RangeLabels(
                            '${Constants.currency}${controller.priceRange.value.start.round()}',
                            '${Constants.currency}${controller.priceRange.value.end.round()}',
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () {
                          return GestureDetector(
                            onTap: controller.clearFilters,
                            child: Container(
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                color: controller.filterApplied.value ? CustomTheme.appThemeContrast : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Clear',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Constants.fontsFamily,
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: controller.applyFilters,
                        child: Container(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.05,
                          decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Apply',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget getDropDownButton(
    {required String value,
    required String hint,
    required List<String> itemsList,
    required Function(String? value) onChanged}) {
  return Container(
    height: screenHeight * 0.05,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.1),
        border: Border.all(color: Constants.primaryColor, width: 0.2),
        borderRadius: BorderRadius.circular(10)),
    width: screenWidth,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text(hint),
        borderRadius: BorderRadius.circular(20),
        menuMaxHeight: screenHeight * 0.6,
        underline: Container(),
        dropdownColor: Colors.white,
        value: value,
        onChanged: onChanged,
        items: itemsList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: const TextStyle(color: CustomTheme.propertyTextColor, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

Widget getDropDownDataModelButton(
    {required DataModel value,
    required String hint,
    required List<DataModel> itemsList,
    required Function(DataModel? value) onChanged}) {
  return Container(
    height: screenHeight * 0.05,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.1),
        border: Border.all(color: Constants.primaryColor, width: 0.2),
        borderRadius: BorderRadius.circular(10)),
    width: screenWidth,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<DataModel>(
        hint: Text(hint),
        borderRadius: BorderRadius.circular(20),
        menuMaxHeight: screenHeight * 0.6,
        underline: Container(),
        dropdownColor: Colors.white,
        value: value,
        onChanged: onChanged,
        items: itemsList.map<DropdownMenuItem<DataModel>>((DataModel value) {
          return DropdownMenuItem<DataModel>(
            value: value,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                value.name.toString(),
                style: const TextStyle(color: CustomTheme.propertyTextColor, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

void showSortBottomModalSheet(SearchPropertiesController controller) async {
  showModalBottomSheet(
    isScrollControlled: true,
    context: Get.context!,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (BuildContext context, setState) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                  Center(
                      child: Container(
                    height: 0.5,
                    width: screenWidth,
                    color: Colors.grey.shade400,
                  )),
                  SizedBox(height: screenHeight*0.01,),

                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sort by Newest',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Radio(
                            value: 'Sort by Newest',
                            groupValue: controller.sortGroupValue,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return Constants.primaryColor;
                              },
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  controller.sortGroupValue = value;
                                  controller.updateSort(sortType: 'createdOn', sortOrder: 'asc');
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sort by Oldest',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Radio(
                            value: 'Sort by Oldest',
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return Constants.primaryColor;
                              },
                            ),
                            groupValue: controller.sortGroupValue,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  controller.sortGroupValue = value;
                                  controller.updateSort(sortType: 'createdOn', sortOrder: 'desc');
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sort by Price (High to Low)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Radio(
                            value: 'Sort by Price (High to Low)',
                            groupValue: controller.sortGroupValue,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return Constants.primaryColor;
                              },
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  controller.sortGroupValue = value;
                                  controller.updateSort(sortType: 'price', sortOrder: 'desc');
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sort by Price (Low to High)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Radio(
                            value: 'Sort by Price (Low to High)',
                            groupValue: controller.sortGroupValue,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                return Constants.primaryColor;
                              },
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  controller.sortGroupValue = value;
                                  controller.updateSort(sortType: 'price', sortOrder: 'asc');
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () {
                          return GestureDetector(
                            onTap: controller.clearSorts,
                            child: Container(
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                color: controller.sortApplied.value ? CustomTheme.appThemeContrast : Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Clear',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: Constants.fontsFamily,
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: controller.applySort,
                        child: Container(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.05,
                          decoration: BoxDecoration(
                            color: Constants.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Apply',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
