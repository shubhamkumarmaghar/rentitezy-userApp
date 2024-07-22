
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/site_visit/controller/site_visit_controller.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/app_bar.dart';

class SiteVisitScreen extends StatelessWidget {
  final String propertyId;

  const SiteVisitScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SiteVisitController>(
      init: SiteVisitController(propertyId: propertyId),
      builder: (controller) {
        return Scaffold(
          appBar: appBarWidget(title: 'Site Visit'),
          body: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Radio(
                              activeColor: CustomTheme.appThemeContrast,
                              value: 'Online',
                              groupValue: controller.radioGroupValue,
                              onChanged: controller.onSiteVisitModeChange,
                            ),
                          ),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.blueGrey.shade500,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                          ),
                          Transform.scale(
                            scale: 1.2,
                            child: Radio(
                              activeColor: CustomTheme.appThemeContrast,
                              value: 'Offline',
                              groupValue: controller.radioGroupValue,
                              onChanged: controller.onSiteVisitModeChange,
                            ),
                          ),
                          Text(
                            'Offline',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.blueGrey.shade500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      const Text(
                        'Mobile Number',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: CustomTheme.appThemeContrast.withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.04,
                            ),
                            Icon(
                              Icons.phone,
                              color: CustomTheme.appThemeContrast,
                              size: 20,
                            ),
                            SizedBox(
                              width: screenWidth * 0.78,
                              child: TextFormField(
                                controller: controller.phoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                ],
                                maxLength: 10,
                                decoration: InputDecoration(
                                    hoverColor: Constants.hint,
                                    hintText: 'Mobile number',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                                    border: InputBorder.none,
                                    labelStyle:
                                        const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      const Text(
                        'Date',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Center(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: CustomTheme.appThemeContrast.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: controller.onShowCalender,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.03,
                                ),
                                Icon(Icons.calendar_today_outlined, color: CustomTheme.appThemeContrast, size: 20),
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                Text(DateFormat.yMMMd().format(controller.selectedDate)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.45,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (controller.phoneController.text.isNotEmpty) {
                              controller.submitSiteVisit();
                            } else {
                              RIEWidgets.getToast(message: 'Phone number can not be empty', color: Colors.white);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: CustomTheme.appThemeContrast,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
