import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../../bookings/view/bookings_screen.dart';
import '../../login/view/login_screen.dart';
import '../../pdf/pdf_api.dart';
import '../../pdf/pdf_new.dart';
import '../../screen/faq_screen.dart';
import '../../social/view/app_social_screen.dart';
import '../../terms_conditions.dart/policy_data.dart';
import '../../terms_conditions.dart/terms_and_condition.dart';
import '../../update_profile/view/update_profile.dart';
import '../const/appConfig.dart';
import '../model/agreement_det.dart';
import '../styles/menu_text_style.dart';
import 'menu_side_bar_widget.dart';

class AppDrawer extends StatelessWidget {
  final String userName = GetStorage().read(Constants.firstName) ?? '';
  final String userId = GetStorage().read(Constants.userId)?.toString() ?? "guest";
  final bool isLogin = GetStorage().read(Constants.isLogin) ?? false;

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
                    borderRadius: BorderRadius.circular(screenHeight * 0.07),
                    child: imgLoadWid(GetStorage().read(Constants.profileUrl) ?? "", 'assets/images/user_vec.png',
                        screenHeight * 0.11, screenWidth * 0.24, BoxFit.cover),
                  ),
                  height(0.015),
                  Text(
                    userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ) //UserAccountDrawerHeader
              ), //DrawerHeaderRS
          getMenuSideBar(
            leading: Icon(
              Icons.edit,
              size: 20,
              color: Constants.primaryColor,
            ),
            title: Text('Edit Profile ', style: menuTextStyle()),
            onTap: () {
              Get.to(() => const UpdateProfilePage());
            },
          ),

          getMenuSideBar(
            leading: Icon(
              Icons.question_answer_rounded,
              size: 20,
              color: Constants.primaryColor,
            ),
            title: Text(' Faq ', style: menuTextStyle()),
            onTap: () {
              Get.to(() => const FaqScreen());
            },
          ),
          //
          getMenuSideBar(
            leading: Icon(
              Icons.contact_page,
              size: 20,
              color: Constants.primaryColor,
            ),
            title: Text(' Contact us ', style: menuTextStyle()),
            onTap: () {
              Get.to(() => const AppSocialScreen());
            },
          ),
          getMenuSideBar(
            leading: Icon(
              Icons.policy_rounded,
              size: 20,
              color: Constants.primaryColor,
            ),
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
            leading: Icon(
              Icons.library_books_rounded,
              size: 20,
              color: Constants.primaryColor,
            ),
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
            leading: Icon(
              Icons.free_cancellation_rounded,
              size: 20,
              color: Constants.primaryColor,
            ),
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
              isLogin ? Icons.logout_rounded : Icons.login,
              size: 20,
              color: Constants.primaryColor,
            ),
            title: Text(isLogin ? 'Logout' : 'Login', style: menuTextStyle()),
            onTap: () {
              if (isLogin) {
                logoutAlertDialog(context);
              } else {
                Get.offAll(() => const LoginScreen());
              }
            },
          ),
        ],
      ),
    );
  }
}
