import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rentitezy/utils/model/data_model.dart';
import 'package:rentitezy/utils/repo/property_repository.dart';
import '../../../utils/const/app_urls.dart';
import '../../../utils/model/property_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';

class SearchPropertiesController extends GetxController {
  final searchQuery = TextEditingController();
  List<PropertyInfoModel>? searchedPropertyList;
  List<String> searchedLocation = locationsList;
  List<DataModel> propertyTypeList = bhkList;
  List<DataModel> furnishTypeList = furnishList;
  List<String> bathroomsList = bathroomsCountList;
  final RIEUserApiService apiService = RIEUserApiService();
  final storage = GetStorage();
  String selectedLocation = 'ALL';
  var selectedPropertyType = DataModel(name: "Select", value: "select");
  var selectedFurnishType = DataModel(name: "Select", value: "select");
  String selectedBathroom = 'Select';
  RxBool filterApplied = false.obs;
  Rx<RangeValues> priceRange = RangeValues(6000, 50000).obs;

  final searchedPropertyRefreshController = RefreshController(initialRefresh: false);
  RxBool sortApplied = false.obs;
  String sortType = 'none';
  String sortOrder = 'none';
  String sortGroupValue = 'none';

  int pageNumber = 0;
  int pageCount = 5;
  bool isLastProperty = false;

  final String location;
  final DataModel? propertyType;

  SearchPropertiesController({required this.location, this.propertyType});

  @override
  void onInit() {
    super.onInit();
    searchQuery.text = location;
    if (propertyType != null) {
      filterApplied.value = true;
      selectedPropertyType = propertyType!;
    }
    fetchProperties();
  }

  void clearFilters() {
    if (filterApplied.value) {
      Get.back();
      selectedLocation = 'ALL';
      selectedPropertyType = DataModel(name: "Select", value: "select");
      selectedFurnishType = DataModel(name: "Select", value: "select");
      selectedBathroom = 'Select';
      pageNumber = 0;
      pageCount = 5;
      isLastProperty = false;
      searchedPropertyList = null;
      searchQuery.clear();
      filterApplied.value = false;
      priceRange = RangeValues(6000, 50000).obs;
      update();
      fetchProperties();
    }
  }

  void clearSorts() {
    if (sortApplied.value) {
      Get.back();
      sortApplied = false.obs;
      sortType = 'none';
      sortOrder = 'none';
      sortGroupValue = 'none';
      pageNumber = 0;
      pageCount = 5;
      searchedPropertyList = null;
      update();
      fetchProperties();
    }
  }

  void applySort() {
    Get.back();
    sortApplied = true.obs;
    pageNumber = 0;
    pageCount = 5;
    searchedPropertyList = null;
    update();
    fetchProperties();
  }

  void applyFilters() {
    Get.back();
    filterApplied.value = true;
    pageNumber = 0;
    pageCount = 5;
    searchedPropertyList = null;
    update();
    fetchProperties();
  }

  void updateSort({required String sortType, required String sortOrder}) {
    this.sortType = sortType;
    this.sortOrder = sortOrder;
  }

  Future<void> fetchProperties() async {
    Map<String, dynamic> queryParams = {
      "available": 'true',
      "offset": pageNumber.toString(),
      "limit": pageCount.toString()
    };
    if (searchQuery.text.trim().isNotEmpty) {
      queryParams.addAll({"location": searchQuery.text});
    }
    if (filterApplied.value) {
      if (!selectedPropertyType.value.toLowerCase().contains('select')) {
        queryParams.addAll({"unitType": selectedPropertyType.value});
      }
      if (!selectedFurnishType.value.toLowerCase().contains('select')) {
        queryParams.addAll({"furnishType": selectedFurnishType.value});
      }
      if (!selectedBathroom.toLowerCase().contains('select')) {
        queryParams.addAll({"bathroom": selectedBathroom});
      }
      queryParams.addAll({"minPrice": priceRange.value.start.round().toString()});
      queryParams.addAll({"maxPrice": priceRange.value.end.round().toString()});
    }
    if (sortApplied.value) {
      if (!sortType.contains('none')) {
        queryParams.addAll({"sortBy": sortType});
      }
      if (!sortOrder.contains('none')) {
        queryParams.addAll({"order": sortOrder});
      }
    }
    final response = await apiService.getApiCallWithQueryParams(endPoint: 'listing', queryParams: queryParams);

    if (response["message"].toString().toLowerCase().contains('success') && response['data'] != null) {
      Iterable iterable = response['data'];
      searchedPropertyList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    } else {
      searchedPropertyList = [];
      RIEWidgets.getToast(message: response["message"] ?? 'Something went wrong!', color: CustomTheme.errorColor);
    }
    update();
  }

  Future<void> getPropertyListRefresher(bool isRefresh) async {
    pageNumber++;
    if (isRefresh) {
      isLastProperty = false;
      searchedPropertyList = null;
      pageNumber = 0;
      selectedLocation = 'ALL';
      selectedPropertyType = DataModel(name: "Select", value: "select");
      selectedFurnishType = DataModel(name: "Select", value: "select");
      selectedBathroom = 'Select';
      searchQuery.clear();
      priceRange = RangeValues(6000, 50000).obs;
      filterApplied.value = false;
      sortApplied = false.obs;
      sortType = 'none';
      sortOrder = 'none';
      sortGroupValue = 'none';
      update();
    } else {
      if (isLastProperty == true) {
        searchedPropertyRefreshController.loadComplete();
        RIEWidgets.getToast(
          message: 'No more properties found!',
        );
        return;
      }
    }

    final response = await _fetchPaginatedProperties();

    if (response.length < 5) {
      isLastProperty = true;
    }

    if (isRefresh) {
      searchedPropertyList = response;

      searchedPropertyRefreshController.refreshCompleted();
    } else {
      searchedPropertyList?.addAll(response);
      searchedPropertyRefreshController.loadComplete();
    }
    update();
  }

  Future<List<PropertyInfoModel>> _fetchPaginatedProperties() async {
    Map<String, dynamic> queryParams = {
      "available": 'true',
      "offset": pageNumber.toString(),
      "limit": pageCount.toString()
    };
    if (searchQuery.text.trim().isNotEmpty) {
      queryParams.addAll({"location": searchQuery.text});
    }
    if (filterApplied.value) {
      if (!selectedPropertyType.value.toLowerCase().contains('select')) {
        queryParams.addAll({"unitType": selectedPropertyType.value});
      }
      if (!selectedFurnishType.value.toLowerCase().contains('select')) {
        queryParams.addAll({"furnishType": selectedFurnishType.value});
      }
      if (!selectedBathroom.toLowerCase().contains('select')) {
        queryParams.addAll({"bathroom": selectedBathroom});
      }
      queryParams.addAll({"minPrice": priceRange.value.start.round().toString()});
      queryParams.addAll({"maxPrice": priceRange.value.end.round().toString()});
    }
    if (sortApplied.value) {
      if (!sortType.contains('none')) {
        queryParams.addAll({"sortBy": sortType});
      }
      if (!sortOrder.contains('none')) {
        queryParams.addAll({"order": sortOrder});
      }
    }
    final response = await apiService.getApiCallWithQueryParams(endPoint: 'listing', queryParams: queryParams);
    if (response["message"].toString().toLowerCase().contains('success') && response['data'] != null) {
      Iterable iterable = response['data'];
      return iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  void onClose() {
    searchQuery.dispose();
    super.onClose();
  }
}
