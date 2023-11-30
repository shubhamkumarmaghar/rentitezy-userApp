// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rentitezy/const/appConfig.dart';
// import 'package:rentitezy/controller.dart';
// import 'package:rentitezy/screen/home_page/home_main_controller.dart';
// import 'package:rentitezy/screen/search/all_properties_page.dart';
// import 'package:rentitezy/view/main_view/main_widgets.dart';
// import 'package:rentitezy/widgets/app_bar.dart';
// import 'package:rentitezy/widgets/const_widget.dart';

// class HomeMainPage extends StatelessWidget {
//   HomeMainPage({super.key});
//   final controller = Get.put(HomeMainController());
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   final propertyController = Get.put(PropertyApiController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           padding: EdgeInsets.symmetric(
//               vertical: screenHeight * 0.05, horizontal: screenWidth * 0.02),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Obx(() => appBarWidget(controller.userName.value,
//                   controller.profilePic.value, () => controller.goToProfile())),
//               searchWidget(context),
//               height(15),
//               SizedBox(height: 45, width: screenWidth, child: buildTabBar()),
//               height(15),
//               title("Near by Properties", 18),
//               height(15),
//               buildOnGoingList(),
//               height(15),
//               title("Recommended", 18),
//               Obx(
//                 () => propertyController.isLoading.value
//                     ? Center(child: loading())
//                     : Column(
//                         children: [
//                           ListView.builder(
//                             scrollDirection: Axis.vertical,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount:
//                                 propertyController.allPropertyData.length,
//                             itemBuilder: (context, index) {
//                               return recommendWidget(
//                                   propertyController.allPropertyData[index]);
//                             },
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(5),
//                             margin: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(30)),
//                             child: TextButton(
//                                 onPressed: () {
//                                   homeApiController.scrollListener(false);
//                                 },
//                                 child: Text(
//                                   'LOAD MORE',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontFamily: Constants.fontsFamily,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 )),
//                           )
//                         ],
//                       ),
//               ),
//             ],
//           )),
//     );
//   }

//   Widget searchWidget(BuildContext context) {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.only(top: 10),
//       decoration: BoxDecoration(
//           color: Constants.lightSearch,
//           borderRadius: BorderRadius.circular(30)),
//       child: ListTile(
//         onTap: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => AllPropertiesPage()));
//         },
//         leading: const Icon(Icons.search),
//         title: const TextField(
//           enabled: false,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             hintText: 'Search by property name',
//           ),
//         ),
//         horizontalTitleGap: 0,
//       ),
//     );
//   }

//   Widget buildTabBar() {
//     return Obx(() => propertyController.isLoadingLocation.value
//         ? Center(child: loading())
//         : ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             itemCount: homeApiController.categories.length,
//             itemBuilder: (ctx, i) {
//               return GestureDetector(
//                 onTap: () {
//                   homeApiController.selectedIndex.value = i;
//                   homeApiController
//                       .locationFunc(homeApiController.categories[i]);
//                 },
//                 child: Obx(() => AnimatedContainer(
//                     margin: EdgeInsets.fromLTRB(i == 0 ? 15 : 5, 0, 5, 0),
//                     width: 100,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(
//                           i == homeApiController.selectedIndex.value
//                               ? 18
//                               : 15)),
//                       color: i == homeApiController.selectedIndex.value
//                           ? Constants.primaryColor
//                           : Colors.grey[200],
//                     ),
//                     duration: const Duration(milliseconds: 300),
//                     child: Center(
//                       child: Text(
//                         homeApiController.categories[i],
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500,
//                           color: i == homeApiController.selectedIndex.value
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ),
//                     ))),
//               );
//             }));
//   }
// }
