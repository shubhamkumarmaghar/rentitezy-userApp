// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:rentitezy/single_property_details/view/single_properties_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';

import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/widgets.dart';

class SearchItem extends StatefulWidget {
  final FlatModel propertyModel;

  const SearchItem({Key? key, required this.propertyModel}) : super(key: key);

  @override
  State<SearchItem> createState() => RecommendListItemState();
}

class RecommendListItemState extends State<SearchItem> {
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
        width(0.001),
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
    return Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 0),
        child: GestureDetector(
            onTap: () async {
              Get.to(()=>PropertiesDetailsPageNew(
                propertyId: widget.propertyModel.id.toString(),
              ),arguments:widget.propertyModel.id.toString() );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Constants.lightBg,
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      imgLoadWid(
                          'https://rie-users.s3.ap-south-1.amazonaws.com/profile-pics/placeholder.png',
                          'assets/images/app_logo.png',
                          screenHeight * 0.23,
                          screenWidth,
                          BoxFit.cover,
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
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
                                          SizedBox(
                                            width: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.propertyModel.property
                                                      .name,
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
                                                height(3),
                                                Text(
                                                  '${Constants.currency}.${widget.propertyModel.price}/ Month',
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
                                                height(3),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    wrapItems(
                                                        widget.propertyModel
                                                            .property.type,
                                                        'sqr_feet',
                                                        80),
                                                    wrapItems(
                                                        widget.propertyModel
                                                            .property.floor,
                                                        'sofa',
                                                        80),
                                                  ],
                                                ),
                                                height(3),
                                                wrapItems(
                                                    widget.propertyModel
                                                        .property.address,
                                                    'location',
                                                    150),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 110,
                                                height: 35,
                                                child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      // openDialPad(
                                                      //     widget.propertyModel
                                                      //         .ownerPhone,
                                                      //     context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Constants
                                                          .primaryColor,
                                                    ),
                                                    icon: iconWidget(
                                                        'phone', 26, 26),
                                                    label: Text(
                                                      'Contact',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: Constants
                                                              .fontsFamily,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ),
                                              height(5),
                                              Text('Posted On',
                                                  style: TextStyle(
                                                      color:
                                                          Constants.textColor,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              height(5),

                                              // Text(
                                              //     convertToAgo(widget
                                              //         .propertyModel.createdOn),
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
            )));
  }
}
