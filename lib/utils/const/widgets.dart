import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/custom_theme.dart';
import '../../widgets/custom_photo_view.dart';
import 'appConfig.dart';

double screenWidth = Get.width;
double screenHeight = Get.height;
String assetImg = 'assets/images/app_logo.png';
String userVec = 'assets/images/user_vec.png';

Widget loading() {
  return Center(
    child: SpinKitFadingCircle(
      color: CustomTheme.appTheme,
      size: 40.0,
    ),
  );
}

Widget title(String title, double fSize, {FontWeight fontWeight = FontWeight.w500}) {
  return Text(
    title,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: poppinsStyle(color: Colors.black, fontSize: fSize, fontWeight: fontWeight),
  );
}

const poppinsStyle = GoogleFonts.poppins;

Widget titleClr(String title, double fSize, Color clr, FontWeight fw) {
  return Text(
    title,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: TextStyle(fontFamily: Constants.fontsFamily, color: clr, fontSize: fSize, fontWeight: fw),
  );
}

Widget height(double h) {
  return SizedBox(
    height: screenHeight * h,
  );
}

Widget width(double w) {
  return SizedBox(
    width: screenWidth * w,
  );
}

double get getScreenHeight => Get.size.height;

double get getScreenWidth => Get.size.width;

void showCustomToast(
  BuildContext context,
  String texts,
) {
  Fluttertoast.showToast(
    msg: texts,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

Widget iconWidget(String name, double he, double wi, [Color? color]) {
  return Image.asset(
    'assets/images/$name.png',
    fit: BoxFit.fill,
    height: he,
    width: wi,
    color: color,
  );
}
Widget drawerIconWidget(String name, double he, double wi, [Color? color]) {
  return Image.asset(
    'assets/images/$name.png',
    fit: BoxFit.fill,
    height: he,
    width: wi,
    color: color,
  );
}


Widget imgLoadWidCircle(String imgUrl, String asset, double h, double w, BoxFit fit, double radius) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: FadeInImage.assetNetwork(
        fit: fit,
        height: h,
        width: w,
        placeholderFit: fit,
        placeholder: asset,
        image: imgUrl,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            asset,
            fit: fit,
            height: h,
            width: w,
          );
        }),
  );
}

Widget imgLoadWid(String imgUrl, String asset, double h, double w, BoxFit fit) {
  return CachedNetworkImage(
      height: h,
      width: w,
      memCacheWidth: w.toInt(),
      memCacheHeight: h.toInt(),
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => GestureDetector(
        onTap: () {
          Get.to(() => CustomPhotoView(
            imageUrl: imgUrl,
          ));
        },
        child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
      ),
      placeholder: (context, url) => loading(),
      errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(image: AssetImage(assetImg), fit: BoxFit.contain),
            ),
          ));
  return FadeInImage.assetNetwork(
      fit: fit,
      height: h,
      width: w,
      placeholderFit: fit,
      placeholder: asset,
      image: imgUrl,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(
          asset,
          fit: fit,
          //height: h,
          //width: w,
        );
      });
}

String dateConvert(String date) {
  String dateTime;
  try {
    if (date != 'null' && date.isNotEmpty) {
      DateTime datee = DateTime.parse(date);
      dateTime = DateFormat('dd-MM-yyyy').format(datee);
    } else {
      dateTime = 'NA';
    }
  } catch (e) {
    log('error exception ::$e');
    dateTime = 'NA';
  }
  return dateTime;
}
