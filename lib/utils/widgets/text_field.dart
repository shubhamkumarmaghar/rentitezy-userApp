import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/appConfig.dart';
import '../const/widgets.dart';

Widget textField(
    {TextEditingController? controller,
      required String hintText,
      TextInputType? textInputType,
      Function(String)? onChanged,
      double borderRadius=40,
      bool? obscureText}) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Constants.primaryColor.withOpacity(0.1),
    ),
    height: screenHeight * 0.065,
    child: TextField(
      controller: controller,
      keyboardType: textInputType,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
          hoverColor: Constants.hint,
          contentPadding: const EdgeInsets.only(left: 10, right: 20),
          hintText: hintText,
          border: InputBorder.none),
    ),
  );
}