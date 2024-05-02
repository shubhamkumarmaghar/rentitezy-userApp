
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/widgets.dart';

import '../../theme/custom_theme.dart';
import '../appbar_widget.dart';
import '../controller/my_booking_controller.dart';
import '../model/booking_model.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  MyBookingController myBookingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: appBarBooking(
            'Invoices',
            context,
            false,
            (() {})),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: myBookingController.invoices.length,
        itemBuilder: (context, index) {
          var data = myBookingController.invoices[index];
            return getInvoice(invoices: data);

        }
      )
    );
  }

  Widget getInvoice({required Invoices invoices}){
    return
      Card(margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.start
                ,children: [
                  Container(
                    width: Get.width*0.4,
                    margin: EdgeInsets.only(right: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Text('Invoice ID : ',), Text(invoices.id)],),
                  ),
                  Container(width: Get.width*0.4,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Type : ',),
                        Text(invoices.type),
                      ],
                    ),
                  ),
                ]),

            Row(mainAxisAlignment: MainAxisAlignment.start
                ,children: [
                  Container(
                    width: Get.width*0.4,
                    margin: EdgeInsets.only(right: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Text('From Date : ',),
                        Text(dateConvert(invoices.fromDate))],),
                  ),
                  Container(width: Get.width*0.4,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payable : ',),
                        Text(invoices.payable),
                      ],
                    ),
                  ),
                ]),

            Row(mainAxisAlignment: MainAxisAlignment.start
                ,children: [

                  Container(width: Get.width*0.4,
                    margin: EdgeInsets.only(right: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To Date : ',),
                        Text(dateConvert(invoices.tillDate)),
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width*0.4,

                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Text('Paid: ',),
                        Text(invoices.paid)],),
                  ),
                ]),
            Row(mainAxisAlignment: MainAxisAlignment.start
                ,children: [
                  Container(
                    width: Get.width*0.4,
                    margin: EdgeInsets.only(right: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Text('Status : ',), Text(invoices.status)],),
                  ),
                  Visibility(
                    visible: invoices.status.toLowerCase() != 'closed',
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CustomTheme.appTheme),

                        ),
                        onPressed: () async {
                          await myBookingController.invoicePayment(invoiceId: invoices.id);
                          // await  myBookingController.fetchBookingInvoices(bookingID: bookingModelData.id.toString());
                          // Get.to(InvoiceScreen());
                        },
                        child: const Text('Pay Now')),
                  ),
                ]),

          ]),
        ),
      );
  }
}
