// import 'dart:collection';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:rentitezy/const/api.dart';
// import 'package:rentitezy/const/appConfig.dart';
// import 'package:rentitezy/localDb/db_helper.dart';
// import 'package:rentitezy/model/property_model.dart';
// import 'package:rentitezy/screen/single_properties_screen.dart';
// import 'package:rentitezy/widgets/const_widget.dart';
// import 'package:rentitezy/widgets/fav_list_item.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyFavScreen extends StatefulWidget {
//   const MyFavScreen({super.key});

//   @override
//   State<MyFavScreen> createState() => _MyFavState();
// }

// class _MyFavState extends State<MyFavScreen> {
//   final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
//   final dbFavItem = DbHelper.instance;
//   late Future<List<PropertyModel>> futureFavorites;
//   List<PropertyModel> cartItemsList = [];

//   @override
//   void initState() {
//     futureFavorites = fetchFavItemsApi();
//     super.initState();
//   }

//   Future<List<PropertyModel>> fetchFavItemsApi() async {
//     final SharedPreferences sharedPreferences = await prefs;

//     HashMap cardIdVsCount = await dbFavItem.getFavIdVsCountMap(
//         sharedPreferences.getString(Constants.userId).toString(), true);

//     if (cardIdVsCount.isNotEmpty) {
//       cartItemsList = [];

//       List<PropertyModel> cartItemsListTemp = await fetchAllProductsById(
//           cardIdVsCount.keys
//               .map((e) => int.parse(e.toString().split("-")[0]))
//               .toList());
//       HashMap petIdMap = HashMap();
//       for (PropertyModel model in cartItemsListTemp) {
//         petIdMap[model.id.toString()] = model;
//       }

//       List<String> imgTempList = [];
//       cartItemsList = cardIdVsCount.keys.map((key) {
//         PropertyModel petModel = petIdMap[key.split("-").first].copyWith();
//         var imageDynamic = petModel.photo;
//         if (imageDynamic.toString().contains("[")) {
//           var imageDynamicList = jsonDecode(petModel.photo);
//           for (var img in imageDynamicList) {
//             imgTempList.add(img.toString());
//           }
//         } else {
//           imgTempList.add(imageDynamic);
//         }
//         petModel.images = imgTempList;
//         return petModel;
//       }).toList();
//     } else {}
//     setState(() {});
//     return cartItemsList;
//   }

//   Widget getCartListItems(List<PropertyModel> products) {
//     return ListView.builder(
//       itemCount: products.length,
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5),
//         child: Dismissible(
//             key: Key(products[index].id.toString()),
//             direction: DismissDirection.endToStart,
//             onDismissed: (direction) async {
//               var sharedPreferences = await prefs;
//               String userId = "guest";
//               if (sharedPreferences.containsKey(Constants.userId)) {
//                 userId =
//                     sharedPreferences.getString(Constants.userId).toString();
//               }
//               dbFavItem.deleteFav(products[index].id.toString(), userId);
//               setState(() {
//                 products.removeAt(index);
//               });
//               futureFavorites = fetchFavItemsApi();
//             },
//             background: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFE6E6),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Row(
//                 children: [
//                   const Spacer(),
//                   SvgPicture.asset("assets/images/trash.svg"),
//                 ],
//               ),
//             ),
//             child: FavListItem(
//               product: products[index],
//               onView: (view) {
//                 if (view) {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PropertiesDetailsPage(
//                                 propertyModel: products[index],
//                               )));
//                 }
//               },
//             )),
//       ),
//     );
//   }

//   Widget favListWidget() {
//     return FutureBuilder<List<PropertyModel>>(
//         future: futureFavorites,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data!.isNotEmpty) {
//               return getCartListItems(snapshot.data!);
//             } else {
//               return Center(
//                 child: AppConfig.emptyWidget(
//                     'https://assets6.lottiefiles.com/packages/lf20_ksrabxwb.json'),
//               );
//             }
//           } else if (snapshot.hasError) {
//             return reloadErr(snapshot.error.toString(), (() {
//               futureFavorites = fetchFavItemsApi();
//             }));
//           }
//           return loading();
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         Navigator.pop(context, true);
//         return Future.value(true);
//       },
//       child: Scaffold(
//         // appBar: AppBar(
//         //   toolbarHeight: 0,
//         //   backgroundColor: Constants.primaryColor,
//         //   systemOverlayStyle: SystemUiOverlayStyle.light,
//         // ),
//         body: Stack(children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//           ),
//           Container(
//             height: 80,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 color: Constants.primaryColor,
//                 borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30))),
//             child: Stack(children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context, true);
//                   },
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   'My Favourite',
//                   style: TextStyle(
//                       fontFamily: Constants.fontsFamily,
//                       color: Colors.white,
//                       fontSize: 23,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ]),
//           ),
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height - 150,
//                   child: favListWidget()))
//         ]),
//       ),
//     );
//   }
// }

// class RentRemin {
//   final String name;
//   final int id;
//   final String date;
//   final String price;
//   final bool isPaid;
//   const RentRemin(this.name, this.id, this.price, this.date, this.isPaid);
// }
