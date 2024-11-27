import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/image_consts.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:unicons/unicons.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/functions/util_functions.dart';
import '../../utils/widgets/app_bar.dart';
import '../../web_view/webview.dart';

class AppSocialScreen extends StatelessWidget {
  const AppSocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: 'Contact us',
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          children: [
            Row(
              children: [
                iconWidget('contact_us', 20, 20),
                SizedBox(
                  width: screenWidth * 0.04,
                ),
                Text(
                  'Contact Info',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Constants.primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(left: screenWidth * 0.09),
              child: Column(
                children: [
                  callViewTile('+918867319955'),
                  const Divider(),
                  callViewTile(AppUrls.phone),
                  const Divider(),
                  callViewTile('+918867319933'),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.07,
            ),
            navigateToWebsite(),
            SizedBox(
              height: screenHeight * 0.07,
            ),
            Row(
              children: [
                iconWidget('follow_us', 20, 20),
                SizedBox(
                  width: screenWidth * 0.04,
                ),
                Text(
                  'Follow us on',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Constants.primaryColor),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.08,
                ),
                getYoutubeButton(
                    icon: youtubeIcon,
                    onTap: () {
                      Get.to(() => const WebViewPage(
                            title: 'Youtube',
                            uri: 'https://www.youtube.com/@sowerentbng',
                          ));
                    }),
                SizedBox(
                  width: screenWidth * 0.15,
                ),
                getFollowingButton(
                    icon: pinterestIcon,
                    onTap: () {
                      Get.to(() => const WebViewPage(
                            title: 'Pinterest',
                            uri: 'https://in.pinterest.com/sowerent/',
                          ));
                    }),
                SizedBox(
                  width: screenWidth * 0.15,
                ),
                getFollowingButton(
                    icon: linkedinIcon,
                    onTap: () {
                      Get.to(() => const WebViewPage(
                            title: 'Linkedin',
                            uri: 'https://www.linkedin.com/in/sowerent/',
                          ));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getFollowingButton({required String icon, required Function onTap}) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: screenWidth*0.14,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          color: Colors.white
          ),
          child: Image.asset(icon,fit: BoxFit.fill,),
        ));
  }

  Widget getYoutubeButton({required String icon, required Function onTap}) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: screenHeight*0.1,
          width: screenWidth*0.14,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
          ),
          child: Image.asset(icon,fit: BoxFit.cover,),
        ));
  }

  Widget callViewTile(String mobileNumber) {
    return GestureDetector(
      onTap: () => openDialPad(mobileNumber),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Constants.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.call,
              size: 15,
              color: Constants.primaryColor,
            ),
          ),
          SizedBox(
            width: screenWidth * 0.03,
          ),
          Text(
            mobileNumber.toString().replaceRange(3, 3, ' '),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.blueGrey.shade500),
          ),
        ],
      ),
    );
  }

  Widget navigateToWebsite() {
    return GestureDetector(
      onTap: () async {
        Get.to(() => const WebViewPage(
              title: 'Website',
              uri: 'https://sowerent.com/',
            ));
      },
      child: Row(
        children: [
          iconWidget('web_site', 20, 20),
          SizedBox(
            width: screenWidth * 0.04,
          ),
          Text('SoWeRent',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Constants.primaryColor)),
         const Spacer(),
          Container(
            decoration:
                BoxDecoration(color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
            height: screenHeight * 0.03,
            margin: EdgeInsets.only(right: screenWidth * 0.03,),
            width: screenWidth * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Go to Website',
                  style: TextStyle(fontSize: 14, color: Constants.primaryColor, fontWeight: FontWeight.w400),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Constants.primaryColor,
                  size: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
