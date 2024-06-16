import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rentitezy/add_kyc/controller/add_kyc_controller.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/widgets/app_bar.dart';
import 'package:rentitezy/utils/widgets/text_field.dart';

import '../../utils/const/appConfig.dart';
import '../../utils/widgets/data_alert_dialog.dart';

class AddKycScreen extends StatelessWidget {
  final int guestCount;
  final String bookingId;

  const AddKycScreen({super.key, required this.guestCount,required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GetBuilder<AddKycController>(
        init: AddKycController(guestCount: guestCount,bookingId: bookingId),
        builder: (controller) {
          return Scaffold(
            appBar: appBarWidget(title: 'Kyc Documents',showLeading: false),
            body: Container(
              width: screenWidth,
              height: screenHeight,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
              child: ListView.separated(
                itemCount: guestCount,
                separatorBuilder: (context, index) => height(0.02),
                itemBuilder: (context, index) {
                  return guestDocumentView(context: context, controller: controller, index: index);
                },
              ),
            ),
            bottomNavigationBar: Container(
              height: screenHeight * 0.08,
              width: screenWidth * 0.5,
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: controller.submitKycDocs,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget guestDocumentView({required BuildContext context, required AddKycController controller, required int index}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Constants.primaryColor.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kyc document for Guest ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: CustomTheme.appThemeContrast),
          ),
          height(0.01),
          Align(
            alignment: Alignment.center,
            child: _pickerButton(
                onTap: () async {
                  final kycType = await showDataDialog(
                      context: context, title: 'Document Type', dataList: controller.kycDocumentsList);
                  if (kycType != null) {
                    controller.documentModelList[index].documentName = kycType;
                    controller.update();
                  }
                },
                hintText: controller.documentModelList[index].documentName ?? 'Select kyc document type'),
          ),
          height(0.02),
          textField(
            hintText: 'Name',
            borderRadius: 10,
            textInputType: TextInputType.name,
            onChanged: (name) {
              controller.documentModelList[index].name = name;
            },
          ),
          height(0.01),
          textField(
            hintText: 'Phone',
            borderRadius: 10,
            textInputType: TextInputType.phone,
            onChanged: (phone) {
              controller.documentModelList[index].phone = phone;
            },
          ),
          height(0.01),
          textField(
            hintText: 'Email',
            borderRadius: 10,
            textInputType: TextInputType.emailAddress,
            onChanged: (email) {
              controller.documentModelList[index].email = email;
            },
          ),
          height(0.01),
          textField(
            hintText: 'Nationality',
            borderRadius: 10,
            textInputType: TextInputType.name,
            onChanged: (country) {
              controller.documentModelList[index].nationality = country;
            },
          ),
          height(0.02),
          controller.documentModelList[index].documentUrl == null
              ? InkWell(
                  onTap: () {
                    controller.showImagePickerDialog(documentIndex: index);
                  },
                  child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.22,
                      decoration: BoxDecoration(
                          color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 100,
                        color: Constants.primaryColor,
                      )),
                )
              : InkWell(
                  onTap: () {
                    controller.documentModelList.forEach((element) {
                      log('file -- ${element.toString()}');
                    });
                  },
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.24,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 15,
                          child: SizedBox(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.22,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    controller.documentModelList[index].documentUrl ?? '',
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                controller.deleteDocumentDialog(index);
                              },
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.close_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
          height(0.02),
        ],
      ),
    );
  }

  Widget _pickerButton({required Function onTap, required String hintText}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Constants.primaryColor.withOpacity(0.1),
        ),
        height: screenHeight * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.7,
              child: Text(
                hintText,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_outlined,
              color: Constants.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
