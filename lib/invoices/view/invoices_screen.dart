import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rentitezy/invoices/controller/invoice_controller.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/functions/util_functions.dart';
import '../../bookings/appbar_widget.dart';
import '../../theme/custom_theme.dart';
import '../../utils/view/rie_widgets.dart';
import '../model/invoice_model.dart';

class InvoiceScreen extends StatelessWidget {
  final String bookingId;

  const InvoiceScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      init: InvoiceController(bookingId: bookingId),
      builder: (controller) {
        return Scaffold(
            appBar: appBarBooking('Invoices', context, false, (() {})),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20,bottom: 20),
              child: controller.invoicesList == null
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : controller.invoicesList != null && controller.invoicesList!.isEmpty
                      ? RIEWidgets.noData(message: 'No invoices found!')
                      : ListView.separated(
                          itemCount: controller.invoicesList?.length ?? 0,
                          separatorBuilder: (context, index) => SizedBox(
                                height: screenHeight * 0.02,
                              ),
                          itemBuilder: (context, index) {
                            var data = controller.invoicesList![index];
                            return invoiceView(context: context, invoice: data, controller: controller);
                          }),
            ));
      },
    );
  }

  Widget invoiceView(
      {required BuildContext context, required InvoiceModel invoice, required InvoiceController controller}) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: screenHeight * 0.01),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              expandableTitleStyle('Invoice id', invoice.id),
              expandableTitleStyle('Type', invoice.type),
              expandableCurrencyTextStyle('Payable', invoice.payable),
              expandableCurrencyTextStyle('Paid', invoice.paid),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              expandableStatusStyle('Status', invoice.status),
              expandableTitleStyle('From Date', getLocalTime(invoice.fromDate)),
              expandableTitleStyle('To Date', getLocalTime(invoice.tillDate)),
              Visibility(
                visible: invoice.status?.toLowerCase() != 'closed',
                replacement: const SizedBox.shrink(),
                child: GestureDetector(
                  onTap: () async {
                    await controller.invoicePayment(invoiceId: invoice.id?.toString() ?? '');
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Constants.primaryColor, borderRadius: BorderRadius.circular(5)),
                    height: screenHeight * 0.03,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02, top: 5),
                    width: screenWidth * 0.25,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Pay Now',
                          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
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
              ),
            ],
          ),
        ],
      ),
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
              width: screenWidth * 0.18,
              child: Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            width(0.01),
            SizedBox(
              width: screenWidth * 0.2,
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

  Widget expandableCurrencyTextStyle(String title, dynamic value) {
    return Visibility(
      visible: value != null,
      replacement: const SizedBox.shrink(),
      child: Container(
        padding: EdgeInsets.only(bottom: screenHeight * 0.008),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.18,
              child: Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            width(0.01),
            Text(
              '${Constants.currency} ${value.toString().capitalizeFirst.toString()}',
              style: TextStyle(
                color: Colors.blueGrey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget expandableStatusStyle(String title, dynamic value) {
    return Container(
      padding: EdgeInsets.only(bottom: screenHeight * 0.008),
      child: Visibility(
        visible: value != null,
        replacement: const SizedBox.shrink(),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.18,
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
              width: screenWidth * 0.2,
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
        ),
      ),
    );
  }
}
