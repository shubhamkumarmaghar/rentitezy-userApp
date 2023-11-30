// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rentitezy/const/appConfig.dart';
// import 'package:rentitezy/screen/faq_screen.dart';
// import 'package:rentitezy/screen/login_screen.dart';
// import 'package:rentitezy/screen/my_bookings/my_booking_screen.dart';
// import 'package:rentitezy/screen/update_profile.dart';
// import 'package:rentitezy/view/main_view_controller.dart';
// import 'package:rentitezy/web_view/webview.dart';
// import 'package:rentitezy/widgets/const_widget.dart';

// class MainActivity extends StatelessWidget {
//   MainActivity({super.key});

//   final controller = Get.put(MainViewController());
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   Widget drawer(BuildContext context) {
//     return Drawer(
//       width: 240,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
//       ),
//       child: ListView(
//         padding: const EdgeInsets.all(0),
//         children: [
//           DrawerHeader(
//               decoration: BoxDecoration(
//                   color: Constants.primaryColor,
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25))),
//               child: Column(
//                 children: [
//                   imgLoadWid(
//                       controller.profileImg.value.contains('http://')
//                           ? controller.profileImg.value
//                           : AppConfig.imagesRentIsEasyUrl +
//                               controller.profileImg.value,
//                       'assets/images/user_vec.png',
//                       80,
//                       80),
//                   height(5),
//                   Text(
//                     controller.userName.value,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontFamily: Constants.fontsFamily,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ) //UserAccountDrawerHeader
//               ), //DrawerHeaderRS
//           ListTile(
//             leading: iconWidget('profile_edit', 30, 30),
//             trailing: arrowBack(),
//             title: Text(' Profile Edit ',
//                 style: TextStyle(
//                   fontFamily: Constants.fontsFamily,
//                 )),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const UpdateProfilePage()));
//             },
//           ),

//           ListTile(
//             leading: iconWidget('shopping_bag', 26, 26),
//             trailing: arrowBack(),
//             title: Text('My Bookings ',
//                 style: TextStyle(
//                   fontFamily: Constants.fontsFamily,
//                 )),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => MyBookingsScreen(
//                             from: false,
//                           )));
//             },
//           ),

//           ListTile(
//             leading: iconWidget('help', 26, 26),
//             trailing: arrowBack(),
//             title: Text(' Faq ',
//                 style: TextStyle(
//                   fontFamily: Constants.fontsFamily,
//                 )),
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => const FaqScreen()));
//             },
//           ),

//           Obx(() => Visibility(
//                 visible: controller.isTenant.value,
//                 child: ListTile(
//                     leading: iconWidget('agreement', 30, 30),
//                     trailing: arrowBack(),
//                     title: Text(' Agreement ',
//                         style: TextStyle(
//                           fontFamily: Constants.fontsFamily,
//                         )),
//                     onTap: () {
//                       controller.showInvoice(
//                           controller.tempPdf, controller.tenantName.value);
//                     }),
//               )),
//           ListTile(
//             leading: iconWidget('privacy_policy', 30, 30),
//             trailing: arrowBack(),
//             title: Text(' Privacy Policy',
//                 style: TextStyle(
//                   fontFamily: Constants.fontsFamily,
//                 )),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const WebViewPage(
//                             title: 'Privacy And Policy',
//                             uri: 'https://rentiseazy.com/privecy',
//                           )));
//             },
//           ),
//           ListTile(
//             leading: iconWidget('about_us', 30, 30),
//             trailing: arrowBack(),
//             title: Text(' About Us ',
//                 style: TextStyle(
//                   fontFamily: Constants.fontsFamily,
//                 )),
//             onTap: () async {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const WebViewPage(
//                             title: 'Privacy And Policy',
//                             uri: ' https://rentiseazy.com/about',
//                           )));
//             },
//           ),
//           Obx(
//             () => ListTile(
//               trailing: arrowBack(),
//               leading: Icon(
//                 controller.isValidUser()
//                     ? Icons.logout_rounded
//                     : Icons.login_rounded,
//                 color: Colors.black,
//               ),
//               title: Text(controller.isValidUser() ? 'Logout' : 'Login',
//                   style: TextStyle(
//                     fontFamily: Constants.fontsFamily,
//                   )),
//               onTap: () {
//                 if (controller.isValidUser()) {
//                   AppConfig.alertDialog(
//                       context, 'LOG OUT', '* Do you want Logout *');
//                 } else {
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginScreen()),
//                       (route) => false);
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget appBarMainWidget(
//     String title,
//     String image,
//   ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         RichText(
//           text: TextSpan(
//             children: [
//               WidgetSpan(
//                 child: Text("Hi, ",
//                     style: TextStyle(
//                         color: Constants.black,
//                         fontSize: 19,
//                         fontFamily: Constants.fontsFamily,
//                         fontWeight: FontWeight.bold)),
//               ),
//               WidgetSpan(
//                 child: Text(title,
//                     style: TextStyle(
//                         color: Constants.black,
//                         fontSize: 19,
//                         fontFamily: Constants.fontsFamily,
//                         fontWeight: FontWeight.normal)),
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//             onPressed: () {
//               print('onTap');
//               if (scaffoldKey.currentState!.isDrawerOpen) {
//                 print('onTap -close');
//                 scaffoldKey.currentState!.closeDrawer();
//               } else {
//                 print('onTap - open');
//                 scaffoldKey.currentState!.openDrawer();
//               }
//             },
//             icon: const Icon(
//               Icons.auto_awesome_mosaic_rounded,
//               size: 30,
//               color: Colors.black,
//             )),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       drawer: drawer(context),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         padding: EdgeInsets.only(
//             top: screenHeight * 0.05,
//             left: screenWidth * 0.03,
//             right: screenWidth * 0.03),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Obx(() => appBarMainWidget(
//                   controller.userName.value,
//                   controller.profileImg.value,
//                 )),
//             searchWidget(context),
//             height(screenHeight * 0.02),
//             SizedBox(
//                 height: 45, width: screenWidth, child: buildTabBar(context)),
//             height(screenHeight * 0.02),
//             title("Near by Properties", 18),
//             height(screenHeight * 0.02),
//             buildOnGoingList(),
//             height(screenHeight * 0.02),
//             title("Recommended", 18),
//             height(screenHeight * 0.02),
//             Obx(
//               () => homeApiController.isLoading.value
//                   ? Center(child: loading())
//                   : Column(
//                       children: [
//                         ListView.builder(
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: homeApiController.allPropertyData.length,
//                           itemBuilder: (context, index) {
//                             return recommendWidget(
//                                 homeApiController.allPropertyData[index]);
//                           },
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(5),
//                           margin: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(30)),
//                           child: TextButton(
//                               onPressed: () {
//                                 homeApiController.scrollListener(false);
//                               },
//                               child: Text(
//                                 'LOAD MORE',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: Constants.fontsFamily,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold),
//                               )),
//                         )
//                       ],
//                     ),
//             ),
//             height(screenHeight * 0.02),
//           ],
//         ),
//       ),
//     );
//   }
// }
