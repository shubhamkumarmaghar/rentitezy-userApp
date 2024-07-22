import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/widgets.dart';

Future<String?> showDataDialog(
    {required BuildContext context, required String title, required List<String> dataList}) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Container(
              height: screenHeight * 0.3,
              width: screenWidth * 0.8,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.01, bottom: screenHeight * 0.02),
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.22,
                    width: screenWidth * 0.7,
                    padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                    child: ListView.separated(
                      itemCount: dataList.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        var data = dataList[index];
                        return InkWell(
                          onTap: () {
                            Get.back(result: data.toString());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.01,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child: Center(
                              child: Text(
                                data.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade500),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
