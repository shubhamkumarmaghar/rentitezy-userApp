import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import '../utils/const/widgets.dart';
EdgeInsetsGeometry contEdge =
    const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0);


Widget arrowBack() {
  return const Icon(
    Icons.arrow_forward_ios_rounded,
    size: 18,
  );
}

SnackbarController toast(String title, String value) {
  return Get.snackbar(
    title,
    value,
    backgroundColor: Constants.primaryColor,
    colorText: Colors.white,
  );
}

Widget sTitle(String title, double fSize, Color color, FontWeight fontWeight) {
  return Text(
    title,
    style: TextStyle(
        color: color,
        fontSize: fSize,
        fontWeight: fontWeight,
        fontFamily: Constants.fontsFamily),
  );
}

Widget loading() {
  return SizedBox(
    height: 20,
    width: 20,
    child: Center(
      child: CircularProgressIndicator(
        color: Constants.primaryColor,
        strokeWidth: 2,
      ),
    ),
  );
}

Widget load() {
  return const Center(
    child: SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    ),
  );
}

Widget reloadErr(String error, Function() function) {
  return Center(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height(0.005),
          title(error, 15),
          height(0.005),
          ElevatedButton(
              onPressed: function,
              child: sTitle('RELOAD', 13, Colors.white, FontWeight.bold)),
          height(0.005),
        ]),
  );
}

snackBarIcon(BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.black,
    duration: const Duration(milliseconds: 500),
    content: Row(
      children: [
        const Icon(
          Icons.info,
          color: Colors.white,
        ),
        width(10),
        Text(msg)
      ],
    ),
  ));
}

Widget circleContainer(
    Widget child, Color color, double radius, double height, double width) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(radius)),
    child: child,
  );
}

Widget getCustomText(String? text, Color color, int maxLine,
    TextAlign textAlign, FontWeight fontWeight, double textSizes) {
  return Text(
    text!,
    overflow: TextOverflow.ellipsis,
    style: poppinsStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        color: color,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

