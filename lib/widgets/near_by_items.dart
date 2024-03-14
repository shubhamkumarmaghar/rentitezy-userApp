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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.propertyModel?.images?.first == '') {
      imageProvider = const AssetImage('assets/images/app_logo.png');
    } else {
      imageProvider = NetworkImage('${widget.propertyModel?.images?.first.url}');
    }
    return GestureDetector (
      onTap: () async{
        log('property id : ${widget.propertyModel?.id.toString()}');
        Get.to(() => PropertiesDetailsPageNew(
          propertyId: '${widget.propertyModel?.id.toString()}',
        ),arguments:'${widget.propertyModel?.id.toString()}' );
      },
      child: Container(
          padding: const EdgeInsets.only(right: 8.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.03,
                    vertical: Get.width * 0.02,
                  ),
                  width: Get.width * 0.55,
                  height: Get.height* 0.4,
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
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      height: Get.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Container(width: Get.width*0.45,
                              child: Text(
                                '${widget.propertyModel?.title.toString().capitalizeFirst!}',
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(width: Get.width*0.44,
                            child: Text(
                              '₹${widget.propertyModel?.property?.address}',
                              maxLines: 2,
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
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: IconButton(
                    onPressed: () {
                    //  openDialPad(widget.propertyModel?.ownerPhone, context);
                    },
                    icon: iconWidget('phone', 25, 25),
                  ),
                ),
                Positioned(
                    right: 22,
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
                              size: 16,
                              color:  widget.propertyModel!.wishlist == 1
                                  ? Colors.red
                                  : Colors.black,
                            )),
                        Colors.white,
                        100,
                        30,
                        30)),
              ]
                ),
            ),
          ),
    );
  }
}
