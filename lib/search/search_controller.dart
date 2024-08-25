import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/home/model/property_list_nodel.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/const/app_urls.dart';
import '../../utils/model/property_model.dart';
import '../theme/custom_theme.dart';
import '../utils/const/widgets.dart';
import '../utils/services/rie_user_api_service.dart';
import '../utils/view/rie_widgets.dart';

class SearchPropertiesController extends GetxController {
  var isLoading = false;
  bool suggestion = false;
  var isLoadingLocation = true.obs;
  final searchQuery = TextEditingController();
  List<PropertyInfoModel>? searchedPropertyList;
  var apiPropertyList = <PropertySingleData>[].obs;
  List<String> searchedLocation = [];
  final RIEUserApiService apiService = RIEUserApiService();
  final storage = GetStorage();
  String selectedDropdown = 'ALL';
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
    fetchAddress();
  }

  @override
  void onClose() {
    super.onClose();
  }

  set showSuggestion(bool show) {
    suggestion = show;
    update();
  }

  void fetchAddress() async {
    isLoadingLocation(true);
    await Future.delayed(Duration(seconds: 4));
    final response = await apiService
        .getApiCall(endPoint: AppUrls.locations, headers: {'Auth-Token': GetStorage().read(Constants.token)});
    isLoadingLocation(false);
    if (response["message"].toString().toLowerCase().contains('success')) {
      if (response['data'] != null) {
        List<dynamic> location = response['data'] as List;
        searchedLocation.add('ALL');
        for (var i in location) {
          searchedLocation.add(i.toString());
        }
      }
    } else {
      RIEWidgets.getToast(message: response["message"] ?? 'Something went wrong!', color: CustomTheme.errorColor);
    }
  }

  void onLocationTextChanged(String text) {
    searchedLocation[0] = text;
    showSuggestion = true;
    if (text.isEmpty) {
      fetchProperties();
      showSuggestion = false;
    }
    update();
  }

  void showFiltersBottomModalSheet() async {
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
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
                        'Select Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Container(
                        height: screenHeight * 0.06,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Constants.primaryColor.withOpacity(0.1),
                            border: Border.all(color: Constants.primaryColor, width: 0.5),
                            borderRadius: BorderRadius.circular(30)),
                        width: screenWidth,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Select Address'),
                            borderRadius: BorderRadius.circular(20),
                            menuMaxHeight: screenHeight * 0.6,
                            underline: Container(),
                            dropdownColor: Colors.white,
                            value: selectedDropdown,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDropdown = newValue!;
                                searchQuery.text = selectedDropdown;
                              });
                            },
                            items: searchedLocation.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: CustomTheme.propertyTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            Get.back();
                            fetchProperties();
                          },
                          child: Container(
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(40),
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
        });
  }

  void fetchProperties() async {
    isLoading = true;
    update();
    String url = '${AppUrls.listing}?available=true&location=${searchQuery.text}';
    if (searchQuery.text.trim().isEmpty) {
      url = '${AppUrls.listing}?available=true';
    }
    log('api url $url');
    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (response["message"].toString().toLowerCase().contains('success') && response['data'] != null) {
      Iterable iterable = response['data'];
      searchedPropertyList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    } else {
      searchedPropertyList = [];
      RIEWidgets.getToast(message: response["message"] ?? 'Something went wrong!', color: CustomTheme.errorColor);
    }
    //saveUserSearchText();
    isLoading = false;
    update();
  }

  void saveUserSearchText() async {
    final searchedText = storage.read(Constants.searchedText);
    if (searchedText != null && searchedText.toString().isNotEmpty) {
      List textList = jsonDecode(searchedText) as List;
      textList.forEach(
        (element) => log('hello $element'),
      );
    }
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }
}
