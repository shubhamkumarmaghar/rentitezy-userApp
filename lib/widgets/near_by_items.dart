import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/single_property_details/view/single_properties_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';

import '../home/model/property_list_nodel.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/api.dart';
import '../utils/const/widgets.dart';

class NearByItem extends StatefulWidget {
  final PropertySingleData? propertyModel;

  const NearByItem({Key? key, required this.propertyModel}) : super(key: key);

  @override
  State<NearByItem> createState() => NearListItemState();
}

class NearListItemState extends State<NearByItem> {
  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.propertyModel?.images?.first == '') {
      imageProvider = const AssetImage('assets/images/app_logo.png');
    } else {
      imageProvider = NetworkImage('${widget.propertyModel?.images?.first.url}');
    }
    return GestureDetector(
      onTap: () async {
        Get.to(
            () => PropertiesDetailsPageNew(
                  propertyId: '${widget.propertyModel?.id.toString()}',
                ),
            arguments: '${widget.propertyModel?.id.toString()}');
      },
      child: Container(
        padding: const EdgeInsets.only(right: 8.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.03,
                vertical: Get.width * 0.02,
              ),
              width: Get.width * 0.55,
              height: Get.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.14,
                    minHeight: Get.width * 0.2,
                  ),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  // height: Get.width * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FittedBox(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: Get.width * 0.45,
                            child: Text(
                              '${widget.propertyModel?.title.toString().capitalizeFirst!}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.44,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            '${widget.propertyModel?.property?.address}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '₹${widget.propertyModel?.price}/Month',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomTheme.peach,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 5,
              bottom: 0,
              child: IconButton(
                onPressed: () {
                  //  openDialPad(widget.propertyModel?.ownerPhone, context);
                },
                icon: iconWidget('phone', 25, 25),
              ),
            ),
            Positioned(
                right: screenWidth * 0.05,
                top: screenHeight * 0.02,
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
                          size: 16,
                          color: widget.propertyModel!.wishlist == 1 ? Colors.red : Colors.black,
                        )),
                    Colors.white,
                    100,
                    30,
                    30)),
          ]),
        ),
      ),
    );
  }
}
