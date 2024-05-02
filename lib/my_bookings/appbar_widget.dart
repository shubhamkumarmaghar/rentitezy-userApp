import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/home/home_view/home_screen.dart';

import '../dashboard/controller/dashboard_controller.dart';

PreferredSizeWidget appBarBooking(String title, BuildContext context, bool from, Function() onTap) {
  return AppBar(

    title: Text(
      title,
      style:
          TextStyle(fontFamily: Constants.fontsFamily, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
    ),
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          if (from) {
            Get.find<DashboardController>().setIndex(0);
            Get.offAll(() => const DashboardView());
          } else {
            Get.back();
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        )),
    actions: [
      IconButton(
          onPressed: onTap,
          icon: const Icon(
            Icons.refresh_rounded,
            size: 20,
            color: Colors.white,
          ))
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
    ),
  );
}
