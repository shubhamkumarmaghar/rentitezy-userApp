import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../invoices/model/invoice_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';

void showRentBreakDownSheet({required List<Details> rentDetailsList, required BuildContext context}) async {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    builder: (context) {
      return Container(
        padding: MediaQuery.of(context).viewInsets,
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 250),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Rent Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 170,
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return index == rentDetailsList.length
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              expandableCurrencyTextStyle(
                                  'Total ',
                                  '${rentDetailsList.map(
                                        (e) => e.pending ?? 0,
                                      ).toList().fold<int>(0, (previousValue, element) => previousValue + element)}'),
                            ],
                          )
                        : expandableCurrencyTextStyle(
                            rentDetailsList[index].type ?? '', rentDetailsList[index].pending?.toString() ?? '');
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: rentDetailsList.length + 1),
            ),
          ],
        ),
      );
    },
  );
}

Widget expandableCurrencyTextStyle(String title, dynamic value) {
  return Visibility(
    visible: value != null,
    replacement: const SizedBox.shrink(),
    child: Container(
      padding: EdgeInsets.only(bottom: screenHeight * 0.008),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.2,
            child: Text(
              title.capitalizeFirst.toString(),
              style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          width(0.01),
          SizedBox(
            width: screenWidth * 0.5,
            child: Text(
              '${Constants.currency} ${value.toString().capitalizeFirst.toString()}',
              style: TextStyle(
                color: Colors.blueGrey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget expandableStatusStyle(String title, String? value) {
  return Container(
    padding: EdgeInsets.only(bottom: screenHeight * 0.008),
    child: value != null && value.isNotEmpty
        ? Row(
            children: [
              SizedBox(
                width: screenWidth * 0.2,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              width(0.01),
              SizedBox(
                width: screenWidth * 0.5,
                child: Text(
                  value.toString().capitalizeFirst.toString(),
                  style: TextStyle(
                    color:
                        value.toLowerCase().contains('pending') ? CustomTheme.appThemeContrast : CustomTheme.myFavColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )
        : const SizedBox.shrink(),
  );
}

Widget expandableTitleStyle(String title, dynamic value) {
  return Visibility(
    visible: value != null,
    replacement: const SizedBox.shrink(),
    child: Container(
      padding: EdgeInsets.only(bottom: screenHeight * 0.008),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.2,
            child: Text(
              title.capitalizeFirst.toString(),
              style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          width(0.01),
          SizedBox(
            width: screenWidth * 0.5,
            child: Text(
              value.toString().capitalizeFirst.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blueGrey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

int calculatePaid({int? amount, int? pending}) {
  if (amount == null || pending == null) {
    return 0;
  } else {
    return amount - pending;
  }
}

Widget rentButton(
    {required bool show,
    required String title,
    required IconData icon,
    required void Function() onTap,
    required Color color}) {
  return Visibility(
    visible: show,
    replacement: const SizedBox.shrink(),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 12,
            )
          ],
        ),
      ),
    ),
  );
}
