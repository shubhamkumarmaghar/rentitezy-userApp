// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:rentitezy/const/appConfig.dart';
// import 'package:rentitezy/model/property_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PropertyController extends GetxController {
//   var isLoading = false.obs;
//   var askQController = TextEditingController();
//   var reviewController = TextEditingController();
//   var locationController = TextEditingController();
//   var zipCodeController = TextEditingController();
//   var guestList = ['1', '2', '3', '4', '5'].obs;
//   var monthList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'].obs;
//   var dropdownValueGuest = ''.obs;
//   var dropdownValueMonth = ''.obs;
//   var selectFlat = ''.obs;
//   var propertyModel = PropertyModel(
//           id: '1',
//           ownerId: '2',
//           relationShip: 'NA',
//           name: 'NA',
//           type: 'NA',
//           plots: 'NA',
//           floor: 'NA',
//           facility: 'NA',
//           amenities: 'NA',
//           address: 'NA',
//           area: 'NA',
//           city: 'NA',
//           latlng: 'NA',
//           photo: 'NA',
//           video: 'NA',
//           description: 'NA',
//           price: 'NA',
//           images: [],
//           month: 'NA',
//           year: 'NA',
//           amenitiesList: [],
//           ownerPhone: 'NA',
//           bhkType: 'NA',
//           flatNoList: [],
//           createdOn: 'NA')
//       .obs;

//   final Future<SharedPreferences> pref = SharedPreferences.getInstance();
//   DateTime currentDate = DateTime.now();
//   var userId = 'guest'.obs;
//   var tenantId = 'guest'.obs;
//   LinkedHashMap<String, int> myMap = LinkedHashMap();

//   final Completer<GoogleMapController> controller = Completer();
//   Set<Marker> markers = {};
//   var propertyId = ''.obs;

//   @override
//   void onInit() {
//     String s = Get.parameters['propertyId'].toString();
//     if (s.isNotEmpty) {
//       fetchPropertyDetails(s);
//     }
//     super.onInit();
//   }

//   void fetchPropertyDetails(String profileId) async {
//     isLoading(true);
//     var response = await http.get(Uri.parse(AppConfig.property));
//     var responseData = jsonDecode(response.body);
//     await Future.delayed(const Duration(seconds: 2));
//     if (response.statusCode == 200) {
//       if (responseData['success']) {
//         final List<PropertyModel> photosList = (responseData["data"] as List)
//             .map((stock) => PropertyModel.fromJson(stock))
//             .toList();
//         if (photosList.isNotEmpty) {
//           propertyModel.value = photosList.first;
//           propertyModel.refresh();
//         }
//       }
//     }
//   }
// }
