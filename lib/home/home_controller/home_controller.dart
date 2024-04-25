import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/assets_req_model.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';
import '../../utils/model/property_model.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../widgets/const_widget.dart';
import '../../widgets/custom_alert_dialogs.dart';
import '../model/property_list_nodel.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var isLoadingLocation = true.obs;
  PropertyListModel? allPropertyData;
  var apiPropertyList = <PropertyListModel>[].obs;
  var othersController = TextEditingController();
  var commentController = TextEditingController();
  var selectedIndex = 0.obs;
  var locationBy = "ALL".obs;
  var categories = <String>[].obs;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var offset = 10.obs;
  List<PropertyInfoModel>? propertyInfoList;
  List<PropertyInfoModel>? nearbyPropertyInfoList;

  final RIEUserApiService apiService = RIEUserApiService();

  String userId = 'guest';
  String userName = '';
  String imageUrl = '';
  bool isTenant = false;

  @override
  void onInit() {
    localSetup();
    fetchProperties(false);
    fetchAddress();
    super.onInit();
  }

  @override
  void onClose() {
    offset(10);
    super.onClose();
  }

  void localSetup() {
    isTenant = GetStorage().read(Constants.isTenant);
    userName = GetStorage().read(Constants.usernamekey);
    userId = GetStorage().read(Constants.userId) != null ? GetStorage().read(Constants.userId).toString() : "guest";
    imageUrl = GetStorage().read(Constants.profileUrl) ?? '';
  }

  void scrollListener(bool isNext) {
    if (offset.value >= 10) {
      offset(isNext ? (offset.value + 10) : (offset.value - 10));
    }
    fetchProperties(true);
  }

  void fetchNearbyProperties(bool isNext) async {
    if (!isNext) {
      isLoading(true);
    }
    String url = '${AppUrls.listing}?limit=10&available=true&offset=$offset';
    if (locationBy.value != 'ALL') {
      url = '${AppUrls.listing}?limit=10&available=true&offset=$offset&location=${locationBy.value}';
    }

    final response = await apiService.getApiCallWithURL(endPoint: url);

    String success = response["message"];
    try {
      if (success.toLowerCase().contains('success')) {
        if (response['data'] != null) {
          Iterable iterable = response['data'];

          propertyInfoList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
        } else {
          propertyInfoList = [];
        }

        allPropertyData = PropertyListModel.fromJson(response);
        isLoading(false);
        update();
        // allPropertyData!.data?.forEach((element) {
        //   log('props ::::: ${element.wishlist}--${element.id}');
        // });
      }
      if (!isNext) {
        isLoading(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchProperties(bool isNext) async {
    if (!isNext) {
      isLoading(true);
    }
    String url = '${AppUrls.listing}?limit=10&available=true&offset=$offset';
    if (locationBy.value != 'ALL') {
      url = '${AppUrls.listing}?limit=10&available=true&offset=$offset&location=${locationBy.value}';
    }

    final response = await apiService.getApiCallWithURL(endPoint: url);

    String success = response["message"];
    try {
      if (success.toLowerCase().contains('success')) {
        if (response['data'] != null) {
          Iterable iterable = response['data'];

          propertyInfoList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
        } else {
          propertyInfoList = [];
        }

        isLoading(false);
        update();
      }
      if (!isNext) {
        isLoading(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchAddress() async {
    isLoadingLocation(true);
    final response = await http.get(
      Uri.parse(AppUrls.locations),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      String success = body["message"];
      try {
        if (success.toLowerCase().contains('success')) {
          List<dynamic> response = body['data'] as List;
          for (var i in response) {
            categories.add(i.toString());
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      isLoadingLocation(false);
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
  }

  locationFunc(String newVal) {
    locationBy.value = newVal;
    //allPropertyData.value = [];
    update();
    refresh();
    fetchProperties(false);
  }

  Future<List<AssetReqModel>> getAllAssetsReq(String userId) async {
    final response = await http.get(
      Uri.parse('${AppUrls.assetReq}?userId=$userId'),
      headers: <String, String>{},
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      int success = body["success"];
      if (success == 1) {
        try {
          return (body["data"] as List).map((stock) => AssetReqModel.fromJson(stock)).toList();
        } catch (e) {
          return [];
        }
      } else {
        throw Exception(body["message"]);
      }
    } else {
      throw Exception('Failed to Assets Request');
    }
  }

  List<String> ticketList = [
    'Plumbing',
    'Electrical',
    'General Maintenance',
    'Emergency',
    'Water',
    'Sanitary',
    'Others'
  ];
  String selectedTicket = 'Plumbing';

  void showBottomTickets(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Create your Ticket',
                            style: TextStyle(
                                fontFamily: Constants.fontsFamily,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Center(
                            child: Container(
                          height: 1,
                          width: 40,
                          color: Colors.black,
                        )),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ticketList
                                .map(
                                  (temp) => RadioListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    value: temp,
                                    groupValue: selectedTicket,
                                    selected: temp == selectedTicket,
                                    onChanged: (value) {
                                      setState(
                                        () => selectedTicket = value.toString(),
                                      );
                                    },
                                    title: Text(
                                      temp,
                                      style: TextStyle(
                                          color: Colors.black, fontFamily: Constants.fontsFamily, fontSize: 15),
                                    ),
                                    activeColor: Constants.primaryColor,
                                  ),
                                )
                                .toList()),
                        const SizedBox(height: 10),
                        selectedTicket == 'Others'
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                margin: contEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                  border: Border.all(color: Constants.getColorFromHex('EAE7E7')),
                                ),
                                child: TextField(
                                  controller: othersController,
                                  style: TextStyle(fontFamily: Constants.fontsFamily),
                                  decoration: InputDecoration(
                                      hoverColor: Constants.getColorFromHex('CDCDCD'),
                                      hintText: '*Your Problem',
                                      hintStyle: TextStyle(
                                          color: Constants.getColorFromHex('CDCDCD'),
                                          fontFamily: Constants.fontsFamily),
                                      border: InputBorder.none),
                                ),
                              )
                            : height(0),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Constants.lightBg,
                            border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                          ),
                          child: TextField(
                            controller: commentController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hoverColor: Constants.hint, hintText: '*Your comments', border: InputBorder.none),
                          ),
                        ),
                      ],
                    ))),
          );
        });
  }

  Future<void> likeProperty({required BuildContext context, required PropertyInfoModel propertyInfoModel}) async {
    showProgressLoader(context);
    String url = AppUrls.addFav;
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      'listingId': propertyInfoModel.id.toString(),
      'wishlist': propertyInfoModel.wishlist != null && propertyInfoModel.wishlist == 0 ? '1' : '0',
    });
    final data = response as Map<String, dynamic>;
    cancelLoader();
    if (data['message'].toString().toLowerCase().contains('success')) {
      propertyInfoModel.wishlist = propertyInfoModel.wishlist == 0 ? 1 : 0;
    } else {
      RIEWidgets.getToast(message: '${data['message']}', color: CustomTheme.errorColor);
    }
    update();
  }
}
