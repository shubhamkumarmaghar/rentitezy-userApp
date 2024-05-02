import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key, required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
          backgroundColor: Constants.primaryColor,
          title: Text(
            title,
            style: TextStyle(
                fontFamily: Constants.fontsFamily, color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Html(
                  data: data,
                ),
              ],
            ),
          ),
        ));
  }
}
