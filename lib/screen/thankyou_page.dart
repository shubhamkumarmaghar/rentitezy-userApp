import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/home/home_view/home_screen.dart';
import 'package:rentitezy/widgets/home_button.dart';

import '../dashboard/controller/dashboard_controller.dart';
import '../dashboard/view/dashboard_view.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

Color themeColor = const Color(0xFF43D19E);

class _ThankYouPageState extends State<ThankYouPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: const EdgeInsets.all(35),
              // decoration: BoxDecoration(
              //   color: themeColor,
              //   shape: BoxShape.circle,
              // ),
              child: Image.asset(
                "assets/images/transaction.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Payment status will be updated soon",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "Click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: HomeButton(
                title: 'Home',
                onTap: () {
                  Get.find<DashboardController>().setIndex(0);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardView()),
                      (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
