import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/widgets.dart';

import '../utils/const/appConfig.dart';

void showProgressLoader(BuildContext context) {
  showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        backgroundColor: Colors.white,
        elevation: 2.0,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          height: 120.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          constraints: BoxConstraints(
            maxHeight: 200.0,
            maxWidth: screenWidth * 0.3,
          ),
          child: const SizedBox(
            height: 24.0,
            width: 24.0,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    },
  );
}

void showTextAlertDialog(
    {required BuildContext context, required String title, required String subTitle, Function()? onYesTap}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title,
            style: TextStyle(
              fontFamily: Constants.fontsFamily,
            )),
        content: Text(subTitle,
            style: TextStyle(
              fontFamily: Constants.fontsFamily,
            )),
        actions: [
          CupertinoDialogAction(
              onPressed: (){
                if(onYesTap != null){
                  onYesTap();
                }else{
                  Get.back();
                }
              },
              child: Text("YES",
                  style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                  ))),
          CupertinoDialogAction(
            child: Text("NO",
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    },
  );
}

void showImageDialogAlert(
    {required BuildContext context, Icon? icon, required String description, required Color textColor, Text? subText}) {
  showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Container(
                  width: 70,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: textColor,
                    shape: OvalBorder(
                      side: BorderSide(width: 1, color: textColor),
                    ),
                  ),
                  child: icon,
                ),
              if (icon != null)
                SizedBox(
                  height: screenHeight * 0.02,
                ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: textColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              subText ?? const SizedBox.shrink(),
              const SizedBox(height: 10,),
              const CircularProgressIndicator.adaptive()
            ],
          ),
        ),
      );
    },
  );
}
