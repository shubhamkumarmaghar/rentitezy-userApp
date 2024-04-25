import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/utils/const/widgets.dart';

import '../home/home_view/home_screen.dart';
import '../login/view/login_screen.dart';
import '../my_bookings/view/my_booking_screen_list.dart';
import '../pdf/pdf_api.dart';
import '../pdf/pdf_new.dart';
import '../screen/faq_screen.dart';
import '../screen/terms_conditions.dart/policy_data.dart';
import '../screen/terms_conditions.dart/terms_and_condition.dart';
import '../screen/update_profile/view/update_profile.dart';
import '../theme/custom_theme.dart';
import '../utils/const/appConfig.dart';
import '../utils/model/agreement_det.dart';
import '../utils/styles/menu_text_style.dart';
import 'menu_side_bar_widget.dart';

class AppDrawer extends StatelessWidget {
  final String userName = GetStorage().read(Constants.usernamekey);
  final String userId = GetStorage().read(Constants.userId).toString() ?? "guest";
  final bool isTenant = GetStorage().read(Constants.isTenant);

  final AgreementDet tempPdf = AgreementDet(
      'Residential Rental Agreement',
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
      '',
      'TempAbout',
      'Rentiseazy',
      'TempValOne',
      'TempValTwo',
      'TempValFirstParty',
      'Coimbatore',
      'commencingFrom',
      'commencingEnding',
      'licenseAmount',
      'totalAdvance',
      'deducting',
      'licenseCharged',
      'notice1',
      'notice2',
      'premisesBearing',
      'consisting');

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: screenWidth * 0.65,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenHeight*0.07),
                    child: imgLoadWid(
                        GetStorage().read(Constants.profileUrl), 'assets/images/user_vec.png', screenHeight*0.11, screenWidth*0.24, BoxFit.fill),
                  ),
                  height(0.015),
                  Text(
                    userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: Constants.fontsFamily,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ) //UserAccountDrawerHeader
              ), //DrawerHeaderRS
          getMenuSideBar(
            leading: iconWidget('profile_edit', 24, 24, Constants.primaryColor),
            title: Text(' Profile Edit ', style: menuTextStyle()),
            onTap: () {
              Get.to(() => const UpdateProfilePage());
            },
          ),

          getMenuSideBar(
            leading: iconWidget('shopping_bag', 24, 24, Constants.primaryColor),
            title: Text('My Bookings ', style: menuTextStyle()),
            onTap: () {
              Get.to(() => MyBookingsScreenList(
                    from: false,
                  ));
            },
          ),
          getMenuSideBar(
            leading: iconWidget('help', 24, 24, Constants.primaryColor),
            title: Text(' Faq ', style: menuTextStyle()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqScreen()));
            },
          ),

          Visibility(
            visible: isTenant,
            child: getMenuSideBar(
                leading: iconWidget('agreement', 24, 24, Constants.primaryColor),
                title: Text(' Agreement ', style: menuTextStyle()),
                onTap: () {
                  showInvoice();
                }),
          ),
          getMenuSideBar(
            leading: iconWidget('privacy_policy', 24, 24, Constants.primaryColor),
            title: Text(' Privacy Policy', style: menuTextStyle()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(
                            title: 'Privacy And Policy',
                            data: privacyPolicy,
                          )));
            },
          ),
          getMenuSideBar(
            leading: iconWidget('about_us', 24, 24, Constants.primaryColor),
            title: Text(' Terms & Conditions ', style: menuTextStyle()),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(
                            title: 'Terms & Conditions',
                            data: termsPolicy,
                          )));
            },
          ),
          getMenuSideBar(
            leading: iconWidget('about_us', 24, 24, Constants.primaryColor),
            title: Text(' Cancellation Policy ', textAlign: TextAlign.start, style: menuTextStyle()),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(
                            title: 'Cancellation Policy',
                            data: cancelPolicy,
                          )));
            },
          ),
          getMenuSideBar(
            leading: Icon(
              (userId.isNotEmpty || userId != 'null' || userId != 'guest') ? Icons.logout_rounded : Icons.login_rounded,
              color: Constants.primaryColor.withOpacity(0.8),
            ),
            title: Text((userId.isNotEmpty || userId != 'null' || userId != 'guest') ? 'Logout' : 'Login',
                style: menuTextStyle()),
            onTap: () {
              if ((userId.isNotEmpty || userId != 'null' || userId != 'guest')) {
                alertDialog(context, 'LOG OUT', 'do you want to Logout ?');
              } else {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  showInvoice() async {
    tempPdf.between = userName;
    final pdfFile = await PdfInvoice.generate(tempPdf);
    PdfApi.openFile(pdfFile);
  }
}
