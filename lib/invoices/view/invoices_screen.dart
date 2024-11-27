import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/invoices/controller/invoice_controller.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/functions/util_functions.dart';
import '../../theme/custom_theme.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/app_bar.dart';
import '../model/invoice_model.dart';
import '../widgets/invoice_widgets.dart';

class InvoiceScreen extends StatelessWidget {
  final String bookingId;

  const InvoiceScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      init: InvoiceController(bookingId: bookingId),
      builder: (controller) {
        return Scaffold(
            appBar: appBarWidget(title: 'Invoices', onRefresh: () => controller.fetchInvoices(showLoader: true)),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //expandableTitleStyle('Invoice id', invoice.id),
          expandableTitleStyle('From Date', convertDateTimeToLocalTime(invoice.fromDate)),
          expandableTitleStyle('To Date', convertDateTimeToLocalTime(invoice.tillDate)),
          expandableCurrencyTextStyle('Amount', invoice.amount ?? ''),
          expandableCurrencyTextStyle('Pending', invoice.pending ?? ''),
          expandableCurrencyTextStyle('Paid', calculatePaid(amount: invoice.amount, pending: invoice.pending)),
          Row(
            children: [
              const Spacer(),
              const Spacer(),
              rentButton(
                  show: invoice.details != null && invoice.details!.isNotEmpty,
                  title: 'View Breakdown',
                  color: CustomTheme.appThemeContrast,
                  icon: Icons.remove_red_eye_rounded,
                  onTap: () {
                    if (invoice.details != null && invoice.details!.isNotEmpty) {
                      showRentBreakDownSheet(rentDetailsList: invoice.details!, context: context);
                    }
                  }),
              const Spacer(),
              rentButton(
                  show: invoice.amount != null && invoice.amount != 0,
                  title: 'Pay Now',
                  color: Constants.primaryColor,
                  icon: Icons.arrow_forward,
                  onTap: () async {
                    await controller.invoicePayment(invoiceId: invoice.id?.toString() ?? '');
                  }),
            ],
          )
        ],
      ),
    );
  }
}
