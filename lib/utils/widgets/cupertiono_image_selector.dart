import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';

Future<ImageSource?> cupertinoGalleryBottomSheet({
  required BuildContext context,
}) async {
  final imageSource = await showCupertinoModalPopup<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back(result: ImageSource.camera);
              },
              child: Text(
                'Camera',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Constants.primaryColor,
                    fontSize: 16
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back(result: ImageSource.gallery);
              },
              child: Text(
                'Gallery',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                  fontSize: 16
                ),
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Get.back();
            },
            child:  Text(
              'Cancel',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: CustomTheme.appThemeContrast,
                  fontSize: 16
              ),

            ),
          ));
    },
  );
  return imageSource;
}

void _onCameraTap() async {
  final cameraPermission = await Permission.camera.request();

  if (cameraPermission.isDenied) {
    Get.back();
    await Permission.camera.request();
  } else if (cameraPermission.isPermanentlyDenied) {
    Get.back();
    openSettingsDialog(imageSource: ImageSource.camera);
  } else {
    Get.back(result: ImageSource.camera);
  }
}

void _photosAndGalleryRequestPermission() async {
  final photosPermission = await Permission.photos.request();

  if (photosPermission.isDenied) {
    await Permission.storage.request();
  } else if (photosPermission.isPermanentlyDenied) {
    openSettingsDialog(imageSource: ImageSource.gallery);
  } else {
    Get.back(result: ImageSource.gallery);
  }
}

void _onGalleryTap() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      final storagePermission = await Permission.storage.request();
      if (storagePermission.isDenied) {
        Get.back();
        await Permission.storage.request();
      } else if (storagePermission.isPermanentlyDenied) {
        Get.back();
        openSettingsDialog(imageSource: ImageSource.gallery);
      } else {
        Get.back(result: ImageSource.gallery);
      }
    } else {
      _photosAndGalleryRequestPermission();
    }
  } else if (Platform.isIOS) {
    _photosAndGalleryRequestPermission();
  }
}

void openSettingsDialog({required ImageSource imageSource}) async {
  showCupertinoDialog(
    context: Get.context!,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        child: Container(
          height: screenHeight * 0.2,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Permission is denied. Please Open settings and allow permission for photo.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade500),
              ),
              height(0.05),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await openAppSettings();
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: Constants.primaryColor.withOpacity(0.1)),
                      child: Text(
                        'Settings',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Constants.primaryColor),
                      ),
                    ),
                  ),
                  width(0.1),
                  InkWell(
                    onTap: () async {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomTheme.appThemeContrast.withOpacity(0.1)),
                      child: Text(
                        'Cancel',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
