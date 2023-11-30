import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/screen/my_bookings/appbar_widget.dart';
import 'package:rentitezy/screen/my_bookings/my_booking_controller.dart';
import 'package:rentitezy/widgets/const_widget.dart';

class MyBookingsScreen extends StatelessWidget {
  MyBookingsScreen({super.key, required this.from});
  final bool from;
  final MyBookingController bookingController = Get.put(MyBookingController());
  @override
  Widget build(BuildContext context) {
    Widget rowTxt(String title, String value) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.fontsFamily),
            )),
            width(5),
            Expanded(
                child: Text(
              value,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.fontsFamily),
            ))
          ],
        ),
      );
    }

    void refresh() {
      bookingController.fetchMyBooking();
      bookingController.myBookingData.refresh();
    }

    return Scaffold(
      appBar: appBarBooking('My Bookings', context, from, (() => refresh())),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(10),
          child: Obx(() => bookingController.isLoading.value
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 100, horizontal: screenWidth / 2.25),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Constants.primaryColor),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookingController.myBookingData.length,
                  itemBuilder: (context, index) {
                    var item = bookingController.myBookingData[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rowTxt('Booking id', item.bookingId.toString()),
                              rowTxt(
                                  'Movie In date', item.moveIn.split('T')[0]),
                              rowTxt(
                                  'Move out date', item.moveOut.split('T')[0]),
                              Visibility(
                                visible: item.property != null,
                                child: rowTxt(
                                    'Property name',
                                    item.property != null
                                        ? item
                                            .property!.propListing.property.name
                                        : 'NA'),
                              ),
                              Visibility(
                                visible: item.property != null,
                                child: rowTxt(
                                    'BHK Type',
                                    item.property != null
                                        ? item.property!.propListing.unitType
                                        : 'NA'),
                              ),
                              rowTxt(
                                  'Booking status', item.status.split('00')[0])
                            ]),
                      ),
                    );
                  },
                ))),
    );
  }
}
