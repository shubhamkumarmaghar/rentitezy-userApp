import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentitezy/my_bookings/appbar_widget.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../ticket/view/get_all_ticket.dart';
import '../controller/my_booking_controller.dart';
import 'invoice_screen.dart';

class BookingDetailsPage extends StatelessWidget {
 // final MyBookingModelData bookingModelData;
  MyBookingController myBookingController = Get.find();
   BookingDetailsPage({super.key,
     //required this.bookingModelData
   });
  @override

  @override
  Widget build(BuildContext context) {

    var data = myBookingController.getSingleBooking?.data;
    log('$data');
    return Scaffold(
      appBar: appBarBooking(
          'Booking Details  ( Flat no. ${data?.id} )',
          context,
          false,
          (() {})),
      body: Container(
        width: getScreenWidth,
        height: getScreenHeight,
        padding: EdgeInsets.symmetric(
            horizontal: getScreenWidth * 0.03,
            vertical: getScreenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getPropInfoView(context: context,),
            SizedBox(
              height: getScreenHeight*0.02,
            ),
            Divider(),
            SizedBox(
              height: getScreenHeight*0.01,
            ),
            Text('Financial Info',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),
            SizedBox(
              height: getScreenHeight*0.01,
            ),
            getPropPaymentView(context: context),
            SizedBox(
              height: getScreenHeight*0.02,
            ),
            Divider(),
            SizedBox(
              height: getScreenHeight*0.01,
            ),
            Text('User Info',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),
            SizedBox(
              height: getScreenHeight*0.01,
            ),
            getPropUserView(context: context),
            SizedBox(
              height: getScreenHeight*0.02,
            ),
            Divider(),
            SizedBox(
              height: getScreenHeight*0.01,
            ),
            Text('Booking Info',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),
            SizedBox(
              height: getScreenHeight*0.01,
            ),
            getPropBookingView(context: context),
            SizedBox(
              height: getScreenHeight*0.02,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(CustomTheme.appTheme),

                ),
                onPressed: () async {
                 await  myBookingController.fetchBookingInvoices(bookingID: '${data?.id.toString()}');
                 Get.to(InvoiceScreen());
                },
                child: const Text('Invoice(s)')),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(CustomTheme.appTheme),

                  ),
                  onPressed: (){
                    Get.to(const GetAllTickets(),arguments: myBookingController.getSingleBooking?.data?.id.toString());
                  },
                  child: const Text('Create Ticket')),
            ],)
          ],
        ),
      ),
    );
  }

  Widget getPropInfoView({required BuildContext context,}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 2,
              child: Container(
                height: getScreenHeight*0.15,
                width: getScreenWidth*0.25,
                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(
                  myBookingController.getSingleBooking?.data?.propListing !=
                    null &&
                    myBookingController.getSingleBooking?.data?.propListing?.images!.length != 0
                    ? myBookingController.getSingleBooking?.data?.propListing?.images![0].url ?? ''
                    : '',),fit: BoxFit.cover,)),
                /*child: Image.network(myBookingController.getSingleBooking?.data?.propListing !=
                            null &&
                    myBookingController.getSingleBooking?.data?.propListing?.images!.length != 0
                    ? myBookingController.getSingleBooking?.data?.propListing?.images![0].url ?? ''
                    : '',),*/
              ),
            ),
          ),
          SizedBox(width: getScreenWidth*0.015,),
          Container(
            width: getScreenWidth*0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.house,size: getScreenWidth*0.05,color: Colors.grey,),
                    SizedBox(width: getScreenWidth*0.01,),
                    Text('${myBookingController.getSingleBooking?.data?.propListing?.property?.name ?? ''}',style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(height: getScreenHeight*0.005,),

                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.home_max,size: getScreenWidth*0.05,color: Colors.grey,),
                      SizedBox(width: getScreenWidth*0.01,),
                   Container(
                        width: Get.width*0.52,
                        child: Text('Address: ${myBookingController.getSingleBooking?.data?.propListing?.property?.address ?? ''}',
                          maxLines:3,style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w600),),
                      ),
                    ],

                ),
                SizedBox(height: getScreenHeight*0.005,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,size: getScreenWidth*0.05,color: Colors.grey,),
                    SizedBox(width: getScreenWidth*0.01,),
                    Container(

                        width: getScreenWidth*0.58,
                        child: Text('${myBookingController.getSingleBooking?.data?.propListing?.property?.latlng ?? ''}',style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w500),)),
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
              Text('Rent',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.18,),
              Text('₹ ${myBookingController.getSingleBooking?.data?.rent ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Deposit',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.13,),
              Text('₹ ${myBookingController.getSingleBooking?.data?.deposit ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Onboarding',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.07,),
              Text('₹ ${myBookingController.getSingleBooking?.data?.onboarding ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Amount Paid',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.05,),
              Text('₹ ${myBookingController.getSingleBooking?.data?.amountPaid ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
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
              Text('Name',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.12,),
              Text('${myBookingController.getSingleBooking?.data?.name ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Email',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.12,),
              Text('${myBookingController.getSingleBooking?.data?.email ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Mobile',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.1,),
              Text('${myBookingController.getSingleBooking?.data?.phone ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
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
              Text('No. of Guest',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.07,),
              Text('${myBookingController.getSingleBooking?.data?.guest ?? ''}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Move-In',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.14,),
              Text('${myBookingController.getSingleBooking?.data?.from.toString().split('T')[0]}'
                ,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: getScreenHeight*0.005,),
          Row(
            children: [
              Text('Move-Out',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(width: getScreenWidth*0.115,),
              Text('${myBookingController.getSingleBooking?.data?.till.toString().split('T')[0]}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
            ],
          ),
        ],
      ),
    );
  }
}
