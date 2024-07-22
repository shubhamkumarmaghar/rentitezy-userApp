import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';

import 'const_widget.dart';

Widget getMenuSideBar({required Widget leading, required Text title, required Function onTap, Widget? trailing}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      height: screenHeight * 0.06,
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.03,
          ),
          Container(
            height: screenHeight * 0.04,
            width: screenWidth * 0.08,
            decoration:
                BoxDecoration(color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.only(
                left: screenWidth * 0.01,
                right: screenWidth * 0.01,
                top: screenHeight * 0.007,
                bottom: screenHeight * 0.007),
            child: leading,
          ),
          SizedBox(
            width: screenWidth * 0.03,
          ),
          title,
          const Spacer(),
          trailing ??
              Icon(
                Icons.arrow_right,
                size: 22,
                color: Colors.grey.shade400,
              ),
          SizedBox(
            width: screenWidth * 0.02,
          ),
        ],
      ),
    ),
  );
}
