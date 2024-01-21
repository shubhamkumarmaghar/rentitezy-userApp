import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/fav_model.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/widgets.dart';
/*
class FavWidget extends StatelessWidget {
  FavWidget({super.key, required this.favModel});
  final FavModel favModel;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
 // final controller = Get.put(FavController());
  final dbFavItem = DbHelper.instance;
  @override
  Widget build(BuildContext context) {
    debugPrint('listingId ${favModel.listingId.toString()}');
    return FutureBuilder<FlatModel?>(
       // future: controller.fetchProperties(favModel.listingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<PropertyModel>>(
                  //future: controller.fetchListingDetails(favModel.listingId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return loading();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return loading();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        PropertyModel data = snapshot.data!.first;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Dismissible(
                              key: Key(data.id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                var sharedPreferences = await prefs;
                                String userId = "guest";
                                if (sharedPreferences
                                    .containsKey(Constants.userId)) {
                                  userId = GetStorage().read(Constants.userId)
                                      .toString();
                                }
                                dbFavItem.deleteFav(data.id.toString(), userId);
                              },
                              background: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE6E6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    SvgPicture.asset("assets/images/trash.svg"),
                                  ],
                                ),
                              ),
                              child: FavListItem(
                                product: data,
                                onView: (view) {
                                  if (view) {
                                    Get.to(()=>  PropertiesDetailsPageNew(
                                      propertyId:
                                      data.id.toString(),
                                    ),arguments: data.id.toString()
                                    );
                                  }
                                },
                              )),
                        );
                      } else if (snapshot.hasError) {
                        return reloadErr(snapshot.error.toString(), (() {}));
                      }
                    }

                    return loading();
                  });
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {}));
            }
          }

          return loading();
        });
  }
}
*/
class WishListWidget extends StatefulWidget {
  final WishListSingleData? wishListSingleDataModel;

  const WishListWidget({Key? key, required this.wishListSingleDataModel})
      : super(key: key);

  @override
  State<WishListWidget> createState() => WishListWidgetState();
}

class WishListWidgetState extends State<WishListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget wrapItems(String text, String icon, double width1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconWidget(icon, 15, 15),
        width(0.03),
        SizedBox(
          width: width1,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Constants.textColor,
                fontSize: 13,
                fontFamily: Constants.fontsFamily,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.wishListSingleDataModel != null && widget.wishListSingleDataModel?.listing?.images != null ) {
      if (widget.wishListSingleDataModel?.listing?.images?.first.url == null ||
          widget.wishListSingleDataModel?.listing?.images?.first.url == '') {
        imageProvider = const AssetImage('assets/images/app_logo.png');
      } else {
        imageProvider = NetworkImage('${widget.wishListSingleDataModel?.listing?.images?.first.url}');
      }
    }
    else{
      imageProvider = const AssetImage('assets/images/app_logo.png');
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 15, top: 0),
      margin: const EdgeInsets.all(10),
      child: GestureDetector(
          onTap: () {
            Get.to(()=>PropertiesDetailsPageNew(propertyId: '${widget.wishListSingleDataModel?.listing?.id.toString()}',)
                ,arguments: '${widget.wishListSingleDataModel?.listing?.id.toString()}' );
          },
          child: Stack(children: [Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Constants.lightBg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*  Stack(
                    children: [
                      imgLoadWid(
                          widget.propertyModel.images.first,
                          'assets/images/app_logo.png',
                          screenHeight * 0.23,
                          screenWidth,
                          BoxFit.cover),
                    ],
                  ),*/
                Container(
                  height: Get.height*0.23,decoration: BoxDecoration(image:DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))

                ),
                ),
                Container(
                    margin: EdgeInsets.all(8),
                    //padding: const EdgeInsets.all(4.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: Container(
                                            width: Get.width*0.6,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${widget.wishListSingleDataModel?.listing?.property?.name}',
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                      Constants.textColor,
                                                      fontSize: 13,
                                                      fontFamily:
                                                      Constants.fontsFamily,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                                height(0.005),
                                                Text(
                                                  '${Constants.currency}.${widget.wishListSingleDataModel?.listing?.price}/ Month',
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                      Constants.fontsFamily,
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                height(0.005),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    wrapItems(
                                                        '${widget.wishListSingleDataModel?.listing?.area}',
                                                        'sqr_feet',
                                                        80),
                                                    wrapItems(
                                                        '${widget.wishListSingleDataModel?.listing?.property
                                                            ?.floor}',
                                                        'sofa',
                                                        80),
                                                  ],
                                                ),
                                                height(0.005),
                                                wrapItems(
                                                    '${widget.wishListSingleDataModel?.listing?.property?.address}',
                                                    'location',
                                                    150),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 3),
                                                  child: ElevatedButton(
                                                      onPressed: () async{
                                                        Get.to(() =>PropertiesDetailsPageNew(
                                                          propertyId:
                                                          '${widget.wishListSingleDataModel?.listing?.id.toString()}',
                                                        ),arguments: '${widget.wishListSingleDataModel?.listing?.id.toString()}');
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        Constants
                                                            .primaryColor,
                                                      ),
                                                      child: Text(
                                                        'Book',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily: Constants
                                                                .fontsFamily,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      )),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    /* openDialPad(
                                                        widget.propertyModel
                                                            ?.ownerPhone,
                                                        context);*/
                                                  },
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                        shape: BoxShape
                                                            .rectangle,
                                                        color: Constants
                                                            .primaryColor),
                                                    child: iconWidget(
                                                        'phone', 26, 26),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // height(0.005),
                                            /*    Text('Posted On',
                                                  style: TextStyle(
                                                      color:
                                                          Constants.textColor,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      fontWeight:
                                                          FontWeight.normal)),*/
                                            //height(0.005),
                                            // Text(
                                            //     convertToAgo(widget
                                            //         .propertyModel.),
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontFamily:
                                            //             Constants.fontsFamily,
                                            //         fontSize: 12,
                                            //         fontWeight:
                                            //             FontWeight.bold))
                                          ],
                                        )
                                      ],
                                    ),
                                  ])
                            ],
                          ),
                        ]))
              ],
            ),
          ),
          /*  Positioned(
                right: 15,
                top: 15,
                child: circleContainer(
                    IconButton(
                        onPressed: () async {
                          bool response =  await likeProperty(listingId: '${widget.propertyModel?.id}' );
                          if(response){
                            setState(() {

                            });
                          }
                        },
                        icon: Icon(
                          widget.propertyModel!.wishlist == 1
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: widget.propertyModel!.wishlist == 1
                              ? Colors.red
                              : Colors.black,
                        )),
                    Colors.white,
                    100,
                    35,
                    35)),*/
          ]
          )),
    );
  }
}

