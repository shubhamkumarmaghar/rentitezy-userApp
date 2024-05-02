
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/ticket/view/create_ticket_screen.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../../theme/custom_theme.dart';
import '../appbar_widget.dart';
import '../controller/my_booking_controller.dart';
import 'invoice_screen.dart';

class BookingDetailsPage extends StatelessWidget {
  final MyBookingController myBookingController = Get.find();

  BookingDetailsPage({
    super.key,
  });

  @override
  @override
  Widget build(BuildContext context) {
    var data = myBookingController.getSingleBooking?.data;
    return Scaffold(
      appBar: appBarBooking('Booking Details  ( Flat no. ${data?.id} )', context, false, (() {})),
      body: Container(
        width: getScreenWidth,
        height: getScreenHeight,
        padding: EdgeInsets.symmetric(horizontal: getScreenWidth * 0.03, vertical: getScreenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getPropInfoView(
                context: context,
              ),
              SizedBox(
                height: getScreenHeight * 0.02,
              ),
              Row(
                children: [
                  Text(
                    'Booking Status : ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  Text(
                    data?.status?.capitalizeFirst ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: data!.status!.toLowerCase().contains('cancel')
                            ? CustomTheme.errorColor
                            : CustomTheme.myFavColor),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: getScreenHeight * 0.01,
              ),
              Text(
                'Financial Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(
                height: getScreenHeight * 0.01,
              ),
              getPropPaymentView(context: context),
              SizedBox(
                height: getScreenHeight * 0.02,
              ),
              Divider(),
              SizedBox(
                height: getScreenHeight * 0.01,
              ),
              Text(
                'User Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(
                height: getScreenHeight * 0.01,
              ),
              getPropUserView(context: context),
              SizedBox(
                height: getScreenHeight * 0.02,
              ),
              Divider(),
              SizedBox(
                height: getScreenHeight * 0.01,
              ),
              Text(
                'Booking Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(
                height: getScreenHeight * 0.01,
              ),
              getPropBookingView(context: context),
              SizedBox(
                height: getScreenHeight * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CustomTheme.appThemeContrast),
                        ),
                        onPressed: () async {
                          showProgressLoader(context);
                          await myBookingController.fetchBookingInvoices(bookingID: data.id.toString());
                          cancelLoader();
                          Get.to(() => const InvoiceScreen());
                        },
                        child: const Text('Invoice(s)')),
                  ),
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Constants.primaryColor),
                        ),
                        onPressed: () {
                          if( data.status!.toLowerCase().contains('cancel')){
                            RIEWidgets.getToast(message: "Can't create ticket for cancelled booking!",color: CustomTheme.errorColor);
                            return;
                          }
                          Get.to(CreateTicketScreen(
                            bookingId: myBookingController.getSingleBooking!.data!.id.toString(),
                          ));
                        },
                        child: const Text('Create Ticket')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getPropInfoView({
    required BuildContext context,
  }) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Container(
                height: getScreenHeight * 0.15,
                width: getScreenWidth * 0.32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage(
                        myBookingController.getSingleBooking?.data?.propListing != null &&
                                myBookingController.getSingleBooking?.data?.propListing?.images!.length != 0
                            ? myBookingController.getSingleBooking?.data?.propListing?.images![0].url ?? ''
                            : '',
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          SizedBox(
            width: getScreenWidth * 0.015,
          ),
          Container(
            width: getScreenWidth * 0.57,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.house,
                      size: getScreenWidth * 0.05,
                      color: CustomTheme.propertyTextColor,
                    ),
                    SizedBox(
                      width: getScreenWidth * 0.01,
                    ),
                    SizedBox(
                      width: getScreenWidth * 0.47,
                      child: Text(
                        '${myBookingController.getSingleBooking?.data?.propListing?.property?.name ?? ''}',
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getScreenHeight * 0.005,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_searching,
                      size: getScreenWidth * 0.05,
                      color: CustomTheme.propertyTextColor,
                    ),
                    SizedBox(
                      width: getScreenWidth * 0.01,
                    ),
                    Container(
                      width: Get.width * 0.47,
                      child: Text(
                        '${myBookingController.getSingleBooking?.data?.propListing?.property?.address ?? ''}',
                        maxLines: 3,
                        style:
                            TextStyle(color: CustomTheme.propertyTextColor, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getScreenHeight * 0.005,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: getScreenWidth * 0.05,
                      color: CustomTheme.propertyTextColor,
                    ),
                    SizedBox(
                      width: getScreenWidth * 0.01,
                    ),
                    Container(
                        width: getScreenWidth * 0.47,
                        child: Text(
                          '${myBookingController.getSingleBooking?.data?.propListing?.property?.latlng ?? ''}',
                          style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getPropPaymentView({required BuildContext context}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Rent',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.18,
              ),
              Text(
                '₹ ${myBookingController.getSingleBooking?.data?.rent ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Deposit',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.13,
              ),
              Text(
                '₹ ${myBookingController.getSingleBooking?.data?.deposit ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Onboarding',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.07,
              ),
              Text(
                '₹ ${myBookingController.getSingleBooking?.data?.onboarding ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Amount Paid',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.05,
              ),
              Text(
                '₹ ${myBookingController.getSingleBooking?.data?.amountPaid ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getPropUserView({required BuildContext context}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Name',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.12,
              ),
              Text(
                '${myBookingController.getSingleBooking?.data?.name ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Email',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.12,
              ),
              Text(
                '${myBookingController.getSingleBooking?.data?.email ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Mobile',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.1,
              ),
              Text(
                '${myBookingController.getSingleBooking?.data?.phone ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getPropBookingView({required BuildContext context}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'No. of Guest',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.07,
              ),
              Text(
                '${myBookingController.getSingleBooking?.data?.guest ?? ''}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Move-In',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.14,
              ),
              Text(
                '${myBookingController.getSingleBooking?.data?.from.toString().split('T')[0]}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight * 0.005,
          ),
          Row(
            children: [
              Text(
                'Move-Out',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: getScreenWidth * 0.115,
              ),
              Text(
                '${myBookingController.getSingleBooking?.data?.till.toString().split('T')[0]}',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
