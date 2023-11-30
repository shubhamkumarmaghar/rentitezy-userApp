import 'package:flutter/material.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/screen/home_screen.dart';

PreferredSizeWidget appBarBooking(
    String title, BuildContext context, bool from, Function() onTap) {
  return AppBar(
    toolbarHeight: 70,
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: TextStyle(
          fontFamily: Constants.fontsFamily,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18),
    ),
    centerTitle: true,
    leading: IconButton(
        onPressed: () {
          if (from) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
                (route) => false);
          } else {
            Navigator.pop(context);
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
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
    ),
  );
}
