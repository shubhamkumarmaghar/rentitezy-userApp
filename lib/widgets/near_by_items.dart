import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/screen/single_properties_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';

class NearByItem extends StatefulWidget {
  final PropertyModel propertyModel;

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

    if (widget.propertyModel.images.first == '') {
      imageProvider = AssetImage('assets/images/app_logo.png');
    } else {
      imageProvider = NetworkImage(widget.propertyModel.images.first);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertiesDetailsPage(
                      propertyId: widget.propertyModel.id.toString(),
                    )));
      },
      child: Column(children: [
        FittedBox(
          child: Padding(
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
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.width * 0.55,
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
                          height: Get.width * 0.25,
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
                                child: Text(
                                  widget.propertyModel.name.capitalizeFirst!,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹${widget.propertyModel.price}/Month',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'No Of Floor : ${widget.propertyModel.floor}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    widget.propertyModel.type,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      bottom: 15,
                      child: IconButton(
                        onPressed: () {
                          openDialPad(widget.propertyModel.ownerPhone, context);
                        },
                        icon: iconWidget('phone', 25, 25),
                      ),
                    ),
                  ]
                    ),
                ),
              )
          ),

       /* Stack(children: [
        /*   SizedBox(
          height: screenHeight * 0.30,
          width: screenWidth * 0.20,
        ),*/
        /* Positioned(
            bottom: 0,
            child: Container(
              height: screenHeight * 0.20,
              width: screenWidth * 0.41,
              decoration: BoxDecoration(
                  color: Constants.lightBg,
                  borderRadius: BorderRadius.circular(15)),
            )
        ),*/
        Positioned(
          top: screenHeight * 0.175,
          child: Container(
            width: screenWidth * 0.41,
            decoration: BoxDecoration(
                color: Constants.lightBg,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.propertyModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 11,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.normal),
                ),
                height(3),
                Text(
                  '${Constants.currency}.${widget.propertyModel.price}/ Month',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.bold),
                ),
                height(3),
                Text(
                  widget.propertyModel.floor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 10,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.normal),
                ),
                height(3),
                Text(
                  widget.propertyModel.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Constants.textColor,
                      fontSize: 11,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.41,
          height: screenHeight * 0.20,
          child: Align(
            alignment: Alignment.topCenter,
            child: imgLoadWid(
                widget.propertyModel.images.first,
                'assets/images/app_logo.png',
                screenHeight * 0.23,
                screenWidth,
                BoxFit.contain),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 15,
          child: IconButton(
            onPressed: () {
              openDialPad(widget.propertyModel.ownerPhone, context);
            },
            icon: iconWidget('phone', 25, 25),
          ),
        ),
      ])
        ,*/]
        ,),
    );
  }
}
