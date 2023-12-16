// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rentitezy/const/appConfig.dart';
// import 'package:rentitezy/home_controller.dart';
// import 'package:rentitezy/model/property_model.dart';
// import 'package:rentitezy/view/main_view_controller.dart';
// import 'package:rentitezy/widgets/const_widget.dart';
// import 'package:rentitezy/widgets/near_by_items.dart';
// import 'package:rentitezy/widgets/recommend_items.dart';

// Widget searchWidget(BuildContext context) {
//   return Container(
//     height: 50,
//     margin: const EdgeInsets.only(top: 10),
//     decoration: BoxDecoration(
//         color: Constants.lightSearch, borderRadius: BorderRadius.circular(30)),
//     child: const ListTile(
//       leading: Icon(Icons.search),
//       horizontalTitleGap: 0,
//     ),
//   );
// }

// final homeApiController = Get.put(PropertyApiController());
// final mainController = Get.put(MainViewController());
// Widget buildTabBar(BuildContext context) {
//   return Obx(() => homeApiController.isLoadingLocation.value
//       ? load()
//       : MediaQuery.removePadding(
//           context: context,
//           removeLeft: true,
//           child: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               itemCount: homeApiController.categories.length,
//               itemBuilder: (ctx, i) {
//                 return GestureDetector(
//                   onTap: () {
//                     homeApiController.selectedIndex.value = i;
//                     homeApiController
//                         .locationFunc(homeApiController.categories[i]);
//                   },
//                   child: AnimatedContainer(
//                       margin: EdgeInsets.only(right: screenWidth * 0.01),
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(
//                             i == homeApiController.selectedIndex.value
//                                 ? 18
//                                 : 15)),
//                         color: i == homeApiController.selectedIndex.value
//                             ? Constants.primaryColor
//                             : Colors.grey[200],
//                       ),
//                       duration: const Duration(milliseconds: 300),
//                       child: Center(
//                         child: Text(
//                           homeApiController.categories[i],
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 13.0,
//                             fontWeight: FontWeight.w500,
//                             color: i == homeApiController.selectedIndex.value
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       )),
//                 );
//               }),
//         ));
// }

// Widget buildOnGoingList() {
//   return SizedBox(
//       height: screenHeight * 0.30,
//       child: Obx(
//         () => homeApiController.isLoadingLocation.value
//             ? Center(child: loading())
//             : ListView.builder(
//                 shrinkWrap: false,
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: homeApiController.allPropertyData.length > 5
//                     ? 3
//                     : homeApiController.allPropertyData.length,
//                 itemBuilder: (context, index) {
//                   return nearProperties(
//                       homeApiController.allPropertyData[index]);
//                 },
//               ),
//       ));
// }

// Widget nearProperties(PropertyModel propertyModel) {
//   return NearByItem(
//     propertyModel: propertyModel,
//   );
// }

// Widget recommendWidget(PropertyModel propertyModel) {
//   return RecommendItem(
//     propertyModel: propertyModel,
//   );
// }
