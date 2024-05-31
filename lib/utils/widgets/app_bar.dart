import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

PreferredSizeWidget appBarWidget(
    {required String title, Function()? onBack, Function()? onRefresh, Color? backgroundColor}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
    ),
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          if (onBack == null) {
            Get.back();
          } else {
            onBack();
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        )),
    actions: [
      Visibility(
          visible: onRefresh != null,
          replacement: const SizedBox.shrink(),
          child: IconButton(
              onPressed: onRefresh,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 20,
                color: Colors.white,
              ))),
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Constants.primaryColor,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
    ),
  );
}
