import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rentitezy/utils/const/widgets.dart';

import '../utils/widgets/app_bar.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key, required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          title: title,
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
