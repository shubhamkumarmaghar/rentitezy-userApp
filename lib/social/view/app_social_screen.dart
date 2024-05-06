import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:unicons/unicons.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/functions/util_functions.dart';
import '../../web_view/webview.dart';

class AppSocialScreen extends StatelessWidget {
  const AppSocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (invoked) {
        Get.find<DashboardController>().setIndex(0);
      },
      child: Scaffold(
        appBar: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
            backgroundColor: Constants.primaryColor,
            titleSpacing: -7,
            centerTitle: true,
            title: const Text(
              'Social',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,size: 18,),
              onPressed: () {
                Get.find<DashboardController>().setIndex(0);
              },
            )),
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
                  getFollowingButton(
                      icon: UniconsLine.facebook,
                      onTap: () {
                        Get.to(() => const WebViewPage(
                              title: 'Facebook',
                              uri: 'https://www.facebook.com/people/Rentiseazy/100085212123196/',
                            ));
                      }),
                  SizedBox(
                    width: screenWidth * 0.15,
                  ),
                  getFollowingButton(
                      icon: UniconsLine.twitter,
                      onTap: () {
                        Get.to(() => const WebViewPage(
                              title: 'Twitter',
                              uri: 'https://twitter.com/i/flow/login?redirect_after_login=%2Frentiseazy',
                            ));
                      }),
                  SizedBox(
                    width: screenWidth * 0.15,
                  ),
                  getFollowingButton(
                      icon: UniconsLine.instagram,
                      onTap: () {
                        Get.to(() => const WebViewPage(
                              title: 'Instagram',
                              uri: 'https://www.instagram.com/rentiseazy/',
                            ));
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFollowingButton({required IconData icon, required Function onTap}) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: screenHeight*0.06,
          width: screenWidth*0.135,
          decoration: BoxDecoration(
            border: Border.all(color: Constants.primaryColor.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(60)
          ),
          child: Icon(
            icon,
            size: 25,
            color:Constants.primaryColor,
          ),
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
              uri: 'https://rentiseazy.com/',
            ));
      },
      child: Row(
        children: [
          iconWidget('web_site', 20, 20),
          SizedBox(
            width: screenWidth * 0.04,
          ),
          Text('Rentiseazy',
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
