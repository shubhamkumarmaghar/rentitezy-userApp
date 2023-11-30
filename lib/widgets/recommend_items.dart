// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/screen/single_properties_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';

class RecommendItem extends StatefulWidget {
  final PropertyModel propertyModel;

  const RecommendItem({Key? key, required this.propertyModel})
      : super(key: key);

  @override
  State<RecommendItem> createState() => RecommendListItemState();
}

class RecommendListItemState extends State<RecommendItem> {
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
        width(3),
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
    if (widget.propertyModel.images.first == '') {
      imageProvider = AssetImage('assets/images/app_logo.png');
    } else {
      imageProvider = NetworkImage(widget.propertyModel.images.first);
    }
    return Padding(
        padding: const EdgeInsets.only(bottom: 15, top: 0),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PropertiesDetailsPage(
                            propertyId: widget.propertyModel.id.toString(),
                          )));
            },
            child: Card(
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
                                                  widget.propertyModel.name,
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
                                                        widget
                                                            .propertyModel.type,
                                                        'sqr_feet',
                                                        80),
                                                    wrapItems(
                                                        widget.propertyModel
                                                            .floor,
                                                        'sofa',
                                                        80),
                                                  ],
                                                ),
                                                height(3),
                                                wrapItems(
                                                    widget
                                                        .propertyModel.address,
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
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 3),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PropertiesDetailsPage(
                                                                            propertyId:
                                                                                widget.propertyModel.id.toString(),
                                                                          )));
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
                                                      openDialPad(
                                                          widget.propertyModel
                                                              .ownerPhone,
                                                          context);
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
            )));
  }
}
