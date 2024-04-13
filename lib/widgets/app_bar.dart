// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import '../utils/const/app_urls.dart';
import '../utils/const/widgets.dart';
import 'const_widget.dart';

Widget appBarWidget({required String title,required String image,required Function() function,required Function() onDrawerTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Text("Hi, ",
                  style: TextStyle(
                      color: Constants.black,
                      fontSize: 19,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.bold)),
            ),
            WidgetSpan(
              child: Text(title,
                  style: TextStyle(
                      color: Constants.black,
                      fontSize: 19,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.normal)),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: function,
        child: imgLoadWid( image,
            'assets/images/user_vec.png', 40, 40, BoxFit.contain),
      ),
    ],
  );
}


