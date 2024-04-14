import 'package:flutter/cupertino.dart';

import '../theme/custom_theme.dart';
import '../utils/const/appConfig.dart';
import '../utils/const/widgets.dart';

Widget wrapItems(String text, String icon, double width1) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      iconWidget(icon, 15, 15,CustomTheme.appThemeContrast),
      width(0.03),
      SizedBox(
        width: width1,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Constants.textColor,
              fontSize: 13,
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.normal),
        ),
      ),
    ],
  );
}