import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/functions/util_functions.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../../utils/const/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/widgets/app_bar.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';
import '../controller/bookings_controller.dart';
import 'booking_details_screen.dart';

class BookingsScreen extends StatelessWidget {
  BookingsScreen({super.key, required this.from});

  final bool from;
  final BookingsController bookingController = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: appBarWidget(
              title: 'My Bookings',
              onRefresh: () => bookingController.fetchMyBooking(showLoader: true)),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: bookingController.myBookingData == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : bookingController.myBookingData != null && bookingController.myBookingData!.isEmpty
                    ? RIEWidgets.noData(message: 'No Bookings found!')
                    : ListView.separated(
                        itemCount: bookingController.myBookingData!.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        itemBuilder: (context, index) {
                          var item = bookingController.myBookingData![index];

                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ExpansionTile(
                                  childrenPadding: EdgeInsets.only(
                                    left: screenWidth * 0.04,
                                    right: screenWidth * 0.04,
                                  ),
                                  tilePadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                  shape: const Border(),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      expandableTitleStyle('Booking id', item.id.toString()),
                                      expandableStatusStyle('Status', '${item.status}')
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      expandableTitleStyle('Name', item.name.toString()),
                                    ],
                                  ),
                                  children: [
                                    rowTxt('Amount Paid', item.amountPaid.toString()),
                                    rowTxt('From', getLocalTime(item.from)),
                                    rowTxt('Till', getLocalTime(item.till)),
                                    rowTxt('No. of Guest', item.guest.toString()),
                                    Visibility(
                                      visible: item.propUnit?.listing?.property != null,
                                      child: rowTxt(
                                          'Property name',
                                          item.propUnit?.listing?.property != null
                                              ? '${item.propUnit?.listing?.property?.name}'
                                              : 'NA'),
                                    ),
                                    Visibility(
                                      visible: item.propUnit?.listing?.listingType != null,
                                      child: rowTxt(
                                          'BHK Type',
                                          item.propUnit?.listing?.listingType != null
                                              ? '${item.propUnit?.listing?.listingType}'
                                              : 'NA'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await bookingController.getBookingDetails(bookingId: '${item.id}');

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: CustomTheme.appThemeContrast, borderRadius: BorderRadius.circular(5)),
                                    height: screenHeight * 0.03,
                                    margin: EdgeInsets.only(right: screenWidth * 0.03, bottom: screenHeight * 0.015),
                                    width: screenWidth * 0.25,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'See Details',
                                          style:
                                              TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }

  Widget rowTxt(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenWidth * 0.3,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.5,
          child: Text(
            title.toLowerCase().contains('amount') ? '${Constants.currency} $value' : value.capitalizeFirst.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        )
      ],
    );
  }

  Widget expandableTitleStyle(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.2,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        width(0.01),
        Text(
          value.capitalizeFirst.toString(),
          style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontsFamily),
        )
      ],
    );
  }

  Widget expandableStatusStyle(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.14,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        width(0.01),
        Text(
          value.capitalizeFirst.toString(),
          style: TextStyle(
              color: value.toLowerCase().contains('cancel') ? CustomTheme.errorColor : CustomTheme.myFavColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontsFamily),
        )
      ],
    );
  }
}
