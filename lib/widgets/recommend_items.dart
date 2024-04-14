// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/single_property_details/view/single_properties_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/widgets/wrap_items.dart';

import '../home/model/property_list_nodel.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/api.dart';
import '../utils/const/widgets.dart';

class RecommendItem extends StatefulWidget {
  final PropertySingleData? propertyModel;

  const RecommendItem({Key? key, required this.propertyModel}) : super(key: key);

  @override
  State<RecommendItem> createState() => RecommendListItemState();
}

class RecommendListItemState extends State<RecommendItem> {

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.propertyModel != null && widget.propertyModel?.images != null) {
      if (widget.propertyModel?.images?.first.url == null || widget.propertyModel?.images?.first == '') {
        imageProvider = const AssetImage('assets/images/app_logo.png');
      } else {
        imageProvider = NetworkImage('${widget.propertyModel?.images?.first.url}');
      }
    } else {
      imageProvider = const AssetImage('assets/images/app_logo.png');
    }
    return GestureDetector(
        onTap: () {
          Get.to(
              () => PropertiesDetailsPageNew(
                    propertyId: '${widget.propertyModel?.id.toString()}',
                  ),
              arguments: '${widget.propertyModel?.id.toString()}');
        },
        child: Stack(children: [
          Card(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 15),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: CustomTheme.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Get.height * 0.23,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: CustomTheme.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),

                    //padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Container(
                            width: Get.width * 0.58,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.propertyModel?.title}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Constants.textColor,
                                      fontSize: 18,
                                      //fontFamily: Constants.fontsFamily,
                                      fontWeight: FontWeight.normal),
                                ),
                                height(0.005),
                                Text(
                                  '${Constants.currency} ${widget.propertyModel?.price}/ Month',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: CustomTheme.peach,
                                      fontFamily: Constants.fontsFamily,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                height(0.005),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    wrapItems('${widget.propertyModel?.area}', 'sqr_feet', 80),
                                    wrapItems('${widget.propertyModel?.property?.floor}', 'sofa', 80),
                                  ],
                                ),
                                height(0.005),

                                wrapItems('${widget.propertyModel?.property?.address}', 'location', 150),
                                height(0.005),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    Get.to(
                                        () => PropertiesDetailsPageNew(
                                              propertyId: '${widget.propertyModel?.id.toString()}',
                                            ),
                                        arguments: '${widget.propertyModel?.id.toString()}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'Book',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomTheme.white,
                                        fontFamily: Constants.fontsFamily,
                                        fontWeight: FontWeight.bold),
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
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    shape: BoxShape.rectangle,
                                    color: Constants.primaryColor),
                                child: iconWidget('phone', 26, 26),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
          Positioned(
              right: 25,
              top: 25,
              child: circleContainer(
                  IconButton(
                      onPressed: () async {
                        bool response = await likeProperty(listingId: '${widget.propertyModel?.id}');
                        if (response) {
                          final val = widget.propertyModel!.wishlist;
                          if (val != null) {
                            setState(() {
                              if (val == 0) {
                                widget.propertyModel!.wishlist = 1;
                              } else {
                                widget.propertyModel!.wishlist = 0;
                              }
                            });
                          }
                        }
                      },
                      icon: Icon(
                        widget.propertyModel!.wishlist == 1 ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18,
                        color: widget.propertyModel!.wishlist == 1 ? const Color(0XFFFF0000) : Colors.black,
                      )),
                  Colors.white,
                  100,
                  35,
                  35)),
        ]));
  }
}
