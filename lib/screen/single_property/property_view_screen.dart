// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:rentitezy/const/appConfig.dart';
// import 'package:rentitezy/widgets/const_widget.dart';
// import 'package:scroll_page_view/scroll_page.dart';

// import 'property_controller.dart';

// class PropertyViewScreen extends StatelessWidget {
//   PropertyViewScreen({super.key});
//   final controller = Get.put(PropertyController());

//   Widget _imageView(String image) {
//     return ClipRRect(
//       clipBehavior: Clip.antiAlias,
//       borderRadius: BorderRadius.circular(8),
//       child: ClipRRect(
//         clipBehavior: Clip.antiAlias,
//         borderRadius: BorderRadius.circular(8),
//         child: CachedNetworkImage(
//             imageUrl: image,
//             imageBuilder: (context, imageProvider) => Container(
//                   height: 320,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     image: DecorationImage(
//                         image: imageProvider, fit: BoxFit.cover),
//                   ),
//                 ),
//             placeholder: (context, url) => loading(),
//             errorWidget: (context, url, error) => Container(
//                   height: 320,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     image: DecorationImage(
//                         image: AssetImage('assets/images/app_logo.png'),
//                         fit: BoxFit.contain),
//                   ),
//                 )),
//       ),
//     );
//   }

//   Widget containerBtn(String title, BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showBottomLeads(title, context);
//       },
//       child: Container(
//         height: 50,
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: Constants.primaryColor,
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Center(
//           child: Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontFamily: Constants.fontsFamily,
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget? _indicatorBuilder(BuildContext context, int index, int length) {
//     return Container(
//       width: 60,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.image_outlined,
//             size: 15,
//             color: Colors.white,
//           ),
//           width(3),
//           RichText(
//             text: TextSpan(
//               text: '${index + 1}',
//               style: TextStyle(
//                   fontSize: 12,
//                   fontFamily: Constants.fontsFamily,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500),
//               children: [
//                 TextSpan(
//                   text: '/',
//                   style: TextStyle(
//                       fontSize: 12,
//                       fontFamily: Constants.fontsFamily,
//                       color: Colors.white),
//                 ),
//                 TextSpan(
//                   text: '$length',
//                   style: TextStyle(
//                       fontSize: 12,
//                       fontFamily: Constants.fontsFamily,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget columnTxt(String title, String subTitle) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//               color: Constants.textColor,
//               fontSize: 13,
//               fontWeight: FontWeight.normal),
//         ),
//         height(3),
//         Text(
//           subTitle,
//           style: const TextStyle(
//               color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }

//   Widget iconCard(String icon) {
//     return Container(
//       height: 60,
//       width: 60,
//       margin: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//         border: Border.all(color: const Color.fromARGB(255, 241, 239, 239)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: iconWidget(icon, 30, 30),
//         // child: Icon(
//         //   iconData,
//         //   size: 35,
//         // ),
//       ),
//     );
//   }

//   Widget chip(String val) {
//     return GestureDetector(
//       onTap: () {
//         controller.askQController.value = TextEditingValue(text: val);
//       },
//       child: Container(
//         margin: const EdgeInsets.all(5),
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.white,
//           border: Border.all(color: Constants.primaryColor),
//         ),
//         child: Center(
//             child: Text(
//           val,
//           style: TextStyle(
//               fontFamily: Constants.fontsFamily,
//               fontSize: 13,
//               color: const Color.fromARGB(255, 110, 109, 109)),
//         )),
//       ),
//     );
//   }

//   void showBottomLeads(String from, BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
//         ),
//         builder: (context) {
//           return Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: StatefulBuilder(
//                 builder: (BuildContext context, setState) =>
//                     SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Text(
//                                 'Please Fill Your Details',
//                                 style: TextStyle(
//                                     fontFamily: Constants.fontsFamily,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20),
//                               ),
//                             ),
//                             Center(
//                                 child: Container(
//                               height: 1,
//                               width: 40,
//                               color: Colors.black,
//                             )),
//                             Container(
//                               padding: const EdgeInsets.all(3),
//                               margin: contEdge,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(7),
//                                 color: Constants.lightBg,
//                                 border: Border.all(
//                                     color: const Color.fromARGB(
//                                         255, 227, 225, 225)),
//                               ),
//                               child: DropdownButton(
//                                 underline: const SizedBox(),
//                                 isExpanded: true,
//                                 hint: Text(
//                                   'Select Guest',
//                                   style: TextStyle(
//                                       color:
//                                           Constants.getColorFromHex('CDCDCD'),
//                                       fontFamily: Constants.fontsFamily),
//                                 ),
//                                 iconEnabledColor:
//                                     Constants.getColorFromHex('CDCDCD'),
//                                 items: controller.guestList.map((item) {
//                                   return DropdownMenuItem(
//                                     value: item.toString(),
//                                     child: Text(
//                                       item.toString(),
//                                       style: TextStyle(
//                                         fontFamily: Constants.fontsFamily,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newVal) {
//                                   setState(() => dropdownValueGuest = newVal);
//                                 },
//                                 value: dropdownValueGuest,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(3),
//                               margin: contEdge,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(7),
//                                 color: Constants.lightBg,
//                                 border: Border.all(
//                                     color: const Color.fromARGB(
//                                         255, 227, 225, 225)),
//                               ),
//                               child: DropdownButton(
//                                 underline: const SizedBox(),
//                                 isExpanded: true,
//                                 hint: Text(
//                                   'Select Months',
//                                   style: TextStyle(
//                                       color:
//                                           Constants.getColorFromHex('CDCDCD'),
//                                       fontFamily: Constants.fontsFamily),
//                                 ),
//                                 iconEnabledColor:
//                                     Constants.getColorFromHex('CDCDCD'),
//                                 items: controller.monthList.map((item) {
//                                   return DropdownMenuItem(
//                                     value: item.toString(),
//                                     child: Text(
//                                       item.toString(),
//                                       style: TextStyle(
//                                         fontFamily: Constants.fontsFamily,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newVal) {
//                                   setState(() => dropdownValueMonth = newVal);
//                                 },
//                                 value: dropdownValueMonth,
//                               ),
//                             ),
//                             title('Select Date', 15),
//                             Container(
//                               height: 55,
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(7)),
//                                 color: Constants.lightBg,
//                               ),
//                               margin: contEdge,
//                               padding: const EdgeInsets.all(5),
//                               child: InkWell(
//                                 onTap: () async {
//                                   await showDatePicker(
//                                     context: context,
//                                     initialDate: currentDate,
//                                     firstDate: DateTime.now()
//                                         .subtract(const Duration(days: 0)),
//                                     lastDate: DateTime(2100),
//                                   ).then((pickedDate) {
//                                     if (pickedDate != null &&
//                                         pickedDate != currentDate) {
//                                       setState(() => currentDate = pickedDate);
//                                     }
//                                   });
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 1,
//                                       child: getCustomText(
//                                           DateFormat.yMMMd()
//                                               .format(currentDate),
//                                           Constants.primaryColor,
//                                           1,
//                                           TextAlign.start,
//                                           FontWeight.w400,
//                                           15),
//                                     ),
//                                     Icon(
//                                       Icons.calendar_today_outlined,
//                                       color: Constants.textColor,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(3),
//                               margin: contEdge,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(7),
//                                 color: Constants.lightBg,
//                                 border: Border.all(
//                                     color: const Color.fromARGB(
//                                         255, 227, 225, 225)),
//                               ),
//                               child: DropdownButton(
//                                 underline: const SizedBox(),
//                                 isExpanded: true,
//                                 hint: Text(
//                                   'Select Flat No',
//                                   style: TextStyle(
//                                       color:
//                                           Constants.getColorFromHex('CDCDCD'),
//                                       fontFamily: Constants.fontsFamily),
//                                 ),
//                                 iconEnabledColor:
//                                     Constants.getColorFromHex('CDCDCD'),
//                                 items: controller.propertyModel.value.flatNoList
//                                     .map((item) {
//                                   return DropdownMenuItem(
//                                     value: item.flatNo,
//                                     child: Text(
//                                       item.flatNo,
//                                       style: TextStyle(
//                                         fontFamily: Constants.fontsFamily,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newVal) {
//                                   setState(() => selectFlat = newVal);
//                                 },
//                                 value: selectFlat,
//                               ),
//                             ),
//                             height(25),
//                             GestureDetector(
//                               onTap: () async {
//                                 var sharedPreferences = await _prefs;
//                                 if (userId == 'null' || userId == 'guest') {
//                                   showCustomToast(context,
//                                       'You are not ${AppConfig.appName} user. Please Login/Register');
//                                 } else if (dropdownValueGuest == null ||
//                                     dropdownValueGuest == 'null' ||
//                                     dropdownValueGuest.isEmpty) {
//                                   showCustomToast(
//                                       context, 'Select valid month');
//                                 } else if (dropdownValueMonth == null ||
//                                     dropdownValueMonth == 'null' ||
//                                     dropdownValueMonth.isEmpty) {
//                                   showCustomToast(
//                                       context, 'Select valid month');
//                                 } else if (selectFlat == null ||
//                                     selectFlat == 'null' ||
//                                     selectFlat.isEmpty) {
//                                   showCustomToast(
//                                       context, 'Select flat number');
//                                 } else {
//                                   setState(() => loadingLeads = true);
//                                   final f = DateFormat('yyyy-MM-dd');

//                                   Map<String, int> listMap = getMapData();
//                                   int flatId = listMap[selectFlat]!;
//                                   String url =
//                                       "${AppConfig.checkout}?id=$flatId&checkin=${f.format(currentDate)}&duration=$dropdownValueMonth&guest=$dropdownValueGuest";
//                                   dynamic result = await getCheckOut(
//                                       url,
//                                       sharedPreferences
//                                           .getString(Constants.token)
//                                           .toString());
//                                   bool success = result["success"];
//                                   if (success) {
//                                     bool isBack = await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => CheckOutPage(
//                                                   from: from,
//                                                   currentDate: currentDate,
//                                                   propertyModel:
//                                                       widget.propertyModel,
//                                                   checkoutModel:
//                                                       CheckoutModel.fromJson(
//                                                           result['data']),
//                                                 )));
//                                     if (isBack) {
//                                       setState(() => loadingLeads = false);
//                                       Navigator.pop(context);
//                                     }
//                                   } else {
//                                     setState(() => loadingLeads = false);
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width * 0.70,
//                                 height: 50,
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Constants.primaryColor,
//                                   borderRadius: BorderRadius.circular(40),
//                                 ),
//                                 child: loadingLeads
//                                     ? const Center(
//                                         child: SizedBox(
//                                           height: 20,
//                                           width: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 3,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       )
//                                     : Center(
//                                         child: Text(
//                                           'Submit',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontFamily: Constants.fontsFamily,
//                                               color: Colors.white,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                             height(15),
//                           ],
//                         ))),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//           ),
//           SizedBox(
//             height: 320,
//             child: CustomScrollView(
//               physics: const NeverScrollableScrollPhysics(),
//               slivers: [
//                 SliverPadding(
//                   padding: const EdgeInsets.all(0),
//                   sliver: SliverToBoxAdapter(
//                       child: Obx(
//                     () => SizedBox(
//                       height: 320,
//                       child: controller.propertyModel.value.images.length > 1
//                           ? ScrollPageView(
//                               controller: ScrollPageController(),
//                               delay: const Duration(seconds: 4),
//                               indicatorAlign: Alignment.bottomLeft,
//                               indicatorPadding: EdgeInsets.only(
//                                   bottom:
//                                       MediaQuery.of(context).size.height * 0.10,
//                                   left: 5),
//                               indicatorWidgetBuilder: _indicatorBuilder,
//                               children: controller.propertyModel.value.images
//                                   .map((image) => _imageView(image))
//                                   .toList(),
//                             )
//                           : _imageView(
//                               controller.propertyModel.value.images.first),
//                     ),
//                   )),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//               bottom: 0,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: 450,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Container(
//                     padding: const EdgeInsets.only(left: 10, top: 20),
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20)),
//                       color: Colors.white,
//                       border: Border.all(
//                           color: const Color.fromARGB(255, 227, 225, 225)),
//                     ),
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         WidgetSpan(
//                                           child: Text(Constants.currency,
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 18,
//                                                   fontFamily:
//                                                       Constants.fontsFamily,
//                                                   fontWeight:
//                                                       FontWeight.normal)),
//                                         ),
//                                         WidgetSpan(
//                                           child: Text(
//                                               '.${controller.propertyModel.value.price}',
//                                               style: TextStyle(
//                                                   fontFamily:
//                                                       Constants.fontsFamily,
//                                                   color: Constants.black,
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.bold)),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text("Per Month",
//                                       style: TextStyle(
//                                           fontFamily: Constants.fontsFamily,
//                                           color: Constants.primaryColor,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.normal))
//                                 ],
//                               ),
//                               width(10),
//                               Container(
//                                 margin: const EdgeInsets.only(top: 5),
//                                 height: 20,
//                                 width: 2,
//                                 color: Colors.black,
//                               ),
//                               width(10),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 3),
//                                 child: Text(
//                                   '${controller.propertyModel.value.plots} Plots',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.fade,
//                                   style: TextStyle(
//                                       fontFamily: Constants.fontsFamily,
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15, right: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                     width: 200,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 3),
//                                           child: iconWidget('location', 13, 13),
//                                         ),
//                                         SizedBox(
//                                           width: 180,
//                                           child: Text(
//                                               controller
//                                                   .propertyModel.value.address,
//                                               maxLines: 2,
//                                               style: TextStyle(
//                                                   fontFamily:
//                                                       Constants.fontsFamily,
//                                                   color: Constants.textColor,
//                                                   fontSize: 12,
//                                                   fontWeight:
//                                                       FontWeight.normal)),
//                                         )
//                                       ],
//                                     )),
//                                 SizedBox(
//                                   width: 120,
//                                   height: 40,
//                                   child: ElevatedButton.icon(
//                                       onPressed: () {
//                                         openDialPad(
//                                             controller
//                                                 .propertyModel.value.ownerPhone,
//                                             context);
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Constants.primaryColor,
//                                       ),
//                                       icon: iconWidget('phone', 30, 30),
//                                       label: Text(
//                                         'Contact',
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             fontFamily: Constants.fontsFamily,
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                 )
//                               ],
//                             ),
//                           ),
//                           height(15),
//                           sTitle(
//                               'Property Details',
//                               15,
//                               const Color.fromARGB(255, 73, 72, 72),
//                               FontWeight.w500),
//                           height(5),
//                           Text(
//                             controller.propertyModel.value.name,
//                             maxLines: 1,
//                             overflow: TextOverflow.fade,
//                             style: TextStyle(
//                                 fontFamily: Constants.fontsFamily,
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.normal),
//                           ),
//                           height(15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                   width: 150,
//                                   child: columnTxt('Floor',
//                                       controller.propertyModel.value.floor)),
//                               SizedBox(
//                                   width: 150,
//                                   child: columnTxt('Facility',
//                                       controller.propertyModel.value.facility))
//                             ],
//                           ),
//                           height(15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                   width: 150,
//                                   child: columnTxt('Flat Type',
//                                       controller.propertyModel.value.type)),
//                               SizedBox(
//                                   width: 150,
//                                   child: columnTxt('Covered Area',
//                                       '${controller.propertyModel.value.area} Sqft'))
//                             ],
//                           ),
//                           height(15),
//                           columnTxt(
//                               'City', controller.propertyModel.value.city),
//                           height(15),
//                           sTitle(
//                               'Description :',
//                               17,
//                               const Color.fromARGB(255, 73, 72, 72),
//                               FontWeight.w500),
//                           height(5),
//                           Text(
//                             controller.propertyModel.value.description,
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontFamily: Constants.fontsFamily,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           height(15),
//                           sTitle(
//                               'Amenities',
//                               17,
//                               const Color.fromARGB(255, 73, 72, 72),
//                               FontWeight.w500),
//                           height(10),
//                           SizedBox(
//                             height: 70,
//                             child: ListView(
//                                 shrinkWrap: true,
//                                 scrollDirection: Axis.horizontal,
//                                 physics: const BouncingScrollPhysics(),
//                                 children: controller
//                                     .propertyModel.value.amenitiesList
//                                     .map((e) => iconCard(mapIcon(e)!))
//                                     .toList()),
//                           ),
//                           height(10),
//                           sTitle(
//                               'Have a question?',
//                               15,
//                               const Color.fromARGB(255, 73, 72, 72),
//                               FontWeight.w500),
//                           height(3),
//                           sTitle('Get a quick answer right here', 11,
//                               Colors.grey, FontWeight.normal),
//                           height(10),
//                           Container(
//                             height: 45,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7),
//                               color: Colors.white,
//                               border: Border.all(
//                                   color:
//                                       const Color.fromARGB(255, 214, 212, 212)),
//                             ),
//                             child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: TextField(
//                                       controller: controller.askQController,
//                                       decoration: InputDecoration(
//                                           hoverColor: Constants.hint,
//                                           hintText: '',
//                                           border: InputBorder.none),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       if (controller
//                                           .askQController.text.isEmpty) {
//                                         showSnackBar(
//                                             context, 'Enter valid Question');
//                                       } else {
//                                         issuesRequest();
//                                       }
//                                     },
//                                     child: Container(
//                                       height: 45,
//                                       width: 100,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(7),
//                                         color: Constants.primaryColor,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Ask now',
//                                           style: TextStyle(
//                                               fontFamily: Constants.fontsFamily,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ]),
//                           ),
//                           height(10),
//                           SizedBox(
//                             height: 50,
//                             child: ListView(
//                               shrinkWrap: true,
//                               scrollDirection: Axis.horizontal,
//                               physics: const BouncingScrollPhysics(),
//                               children: [
//                                 chip('Price negotiable?'),
//                                 chip('Still available?'),
//                                 chip('Can you show me more?')
//                               ],
//                             ),
//                           ),
//                           height(10),
//                           Container(
//                             height: screenHeight * 0.20,
//                             padding: const EdgeInsets.only(right: 10),
//                             child: GoogleMap(
//                                 markers: markers,
//                                 mapType: MapType.normal,
//                                 initialCameraPosition: CameraPosition(
//                                     target: LatLng(
//                                         double.parse(widget.propertyModel.latlng
//                                             .split(',')[0]),
//                                         double.parse(widget.propertyModel.latlng
//                                             .split(',')[1])),
//                                     zoom: 13.0,
//                                     tilt: 0,
//                                     bearing: 0),
//                                 onMapCreated: (GoogleMapController controller) {
//                                   _controller.complete(controller);
//                                 }),
//                           ),
//                           height(20),
//                           FutureBuilder<List<ReviewModel>>(
//                               future: futureReview,
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   if (snapshot.data!.isNotEmpty) {
//                                     return Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         sTitle(
//                                             snapshot.data!.isNotEmpty
//                                                 ? ('${snapshot.data!.length} Reviews')
//                                                 : 'Reviews',
//                                             15,
//                                             const Color.fromARGB(
//                                                 255, 73, 72, 72),
//                                             FontWeight.w500),
//                                         height(20),
//                                         Container(
//                                           height: 45,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(7),
//                                             color: Colors.white,
//                                             border: Border.all(
//                                                 color: const Color.fromARGB(
//                                                     255, 214, 212, 212)),
//                                           ),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Expanded(
//                                                   child: TextField(
//                                                     controller: controller
//                                                         .askQController,
//                                                     decoration: InputDecoration(
//                                                         hoverColor:
//                                                             Constants.hint,
//                                                         hintText:
//                                                             'Write your review',
//                                                         border:
//                                                             InputBorder.none),
//                                                   ),
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     if (userId == 'guest' ||
//                                                         userId == 'null' ||
//                                                         userId == 'Null' ||
//                                                         userId == 'NULL') {
//                                                       showSnackBar(context,
//                                                           'You are not Rentiseazy user. Please login');
//                                                     } else if (controller
//                                                         .reviewController
//                                                         .text
//                                                         .isEmpty) {
//                                                       showSnackBar(context,
//                                                           'Enter your review');
//                                                     } else {
//                                                       reviewRequest();
//                                                     }
//                                                   },
//                                                   child: Container(
//                                                     height: 45,
//                                                     width: 100,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               7),
//                                                       color: Constants
//                                                           .primaryColor,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         'Review',
//                                                         style: TextStyle(
//                                                             fontFamily: Constants
//                                                                 .fontsFamily,
//                                                             color: Colors.white,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ]),
//                                         ),
//                                         height(10),
//                                         ListView.builder(
//                                             itemCount: snapshot.data!.length,
//                                             shrinkWrap: true,
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                             itemBuilder: (context, index) {
//                                               return Card(
//                                                 child: ListTile(
//                                                   leading: iconWidget(
//                                                       'user_vec', 40, 40),
//                                                   title: Text(
//                                                     snapshot
//                                                         .data![index].review,
//                                                     style: TextStyle(
//                                                         fontFamily: Constants
//                                                             .fontsFamily),
//                                                   ),
//                                                   subtitle: Text(
//                                                     getFormatedDate(snapshot
//                                                         .data![index]
//                                                         .createdOn),
//                                                     style: TextStyle(
//                                                         fontFamily: Constants
//                                                             .fontsFamily),
//                                                   ),
//                                                 ),
//                                               );
//                                             }),
//                                       ],
//                                     );
//                                   } else {
//                                     return const Text('');
//                                   }
//                                 } else if (snapshot.hasError) {
//                                   return Text(snapshot.error.toString());
//                                 }
//                                 return loading();
//                               }),
//                           height(70),
//                         ]),
//                   ),
//                 ),
//               )),
//           Positioned(
//               right: 15,
//               top: MediaQuery.of(context).size.height * 0.05,
//               child: circleContainer(
//                   IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.favorite_rounded,
//                         size: 18,
//                         color: Colors.black,
//                       )),
//                   Colors.white,
//                   100,
//                   35,
//                   35)),
//           Positioned(
//               left: 15,
//               top: MediaQuery.of(context).size.height * 0.05,
//               child: circleContainer(
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(
//                         Icons.arrow_back_sharp,
//                         size: 18,
//                         color: Colors.black,
//                       )),
//                   Colors.white,
//                   100,
//                   35,
//                   35)),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(flex: 1, child: containerBtn('Book Now', context)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
