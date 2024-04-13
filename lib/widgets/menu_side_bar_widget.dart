import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/widgets.dart';

import 'const_widget.dart';

Widget getMenuSideBar({required Widget leading, required Text title, required Function onTap, Widget? trailing}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      height: screenHeight*0.06,
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: screenWidth*0.03,),
          leading,
          SizedBox(width: screenWidth*0.03,),
          title,
          const Spacer(),
          trailing ??  Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey.shade400,
          ),
           SizedBox(width: screenWidth*0.02,),
        ],
      ),
    ),
  );
}
