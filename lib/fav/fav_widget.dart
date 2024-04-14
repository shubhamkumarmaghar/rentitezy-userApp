import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/fav_model.dart';
import '../single_property_details/view/single_properties_screen_new.dart';
import '../utils/const/widgets.dart';
import '../widgets/const_widget.dart';
import '../widgets/wrap_items.dart';

class WishListWidget extends StatefulWidget {
  final WishListSingleData? wishListSingleDataModel;

  const WishListWidget({Key? key, required this.wishListSingleDataModel}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.wishListSingleDataModel != null && widget.wishListSingleDataModel?.listing?.images != null) {
      if (widget.wishListSingleDataModel?.listing?.images?.first.url == null ||
          widget.wishListSingleDataModel?.listing?.images?.first.url == '') {
        imageProvider = const AssetImage('assets/images/app_logo.png');
      } else {
        imageProvider = NetworkImage('${widget.wishListSingleDataModel?.listing?.images?.first.url}');
      }
    } else {
      imageProvider = const AssetImage('assets/images/app_logo.png');
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 15, top: 0),
      margin: const EdgeInsets.all(10),
      child: GestureDetector(
          onTap: () {
            Get.to(
                () => PropertiesDetailsPageNew(
                      propertyId: '${widget.wishListSingleDataModel?.listing?.id.toString()}',
                    ),
                arguments: '${widget.wishListSingleDataModel?.listing?.id.toString()}');
          },
          child: Stack(children: [
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
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
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                  ),
                  Container(
                      margin: const EdgeInsets.all(8),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            child: SizedBox(
                                              width: Get.width * 0.6,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${widget.wishListSingleDataModel?.listing?.property?.name}',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Constants.textColor,
                                                        fontSize: 13,
                                                        fontFamily: Constants.fontsFamily,
                                                        fontWeight: FontWeight.normal),
                                                  ),
                                                  height(0.005),
                                                  Text(
                                                    '${Constants.currency} ${widget.wishListSingleDataModel?.listing?.price}/ Month',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: Constants.fontsFamily,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  height(0.005),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      wrapItems('${widget.wishListSingleDataModel?.listing?.area}',
                                                          'sqr_feet', 80),
                                                      wrapItems(
                                                          '${widget.wishListSingleDataModel?.listing?.property?.floor}',
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
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          Get.to(
                                                              () => PropertiesDetailsPageNew(
                                                                    propertyId:
                                                                        '${widget.wishListSingleDataModel?.listing?.id.toString()}',
                                                                  ),
                                                              arguments:
                                                                  '${widget.wishListSingleDataModel?.listing?.id.toString()}');
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Constants.primaryColor,
                                                        ),
                                                        child: Text(
                                                          'Book',
                                                          style: TextStyle(
                                                              fontSize: 12,
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
                                              ),
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
            const Positioned(
                right: 15,
                top: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Icon(
                    Icons.favorite,
                    color: Color(
                      0XFFFF0000,
                    ),
                    size: 20,
                  ),
                )),
          ])),
    );
  }
}
