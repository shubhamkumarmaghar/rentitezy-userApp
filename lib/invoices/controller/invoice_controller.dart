import 'package:get/get.dart';
import 'package:rentitezy/invoices/model/invoice_model.dart';
import 'package:rentitezy/invoices/view/invoice_payment_screen.dart';
import 'package:rentitezy/razorpay_payment/model/razorpay_payment_response_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';

class InvoiceController extends GetxController {
  final String bookingId;
  final apiService = RIEUserApiService();
  List<InvoiceModel>? invoicesList;

  InvoiceController({required this.bookingId});

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices({bool? showLoader}) async {
    if (showLoader != null && showLoader) {
      showProgressLoader(Get.context!);
    }
    String url = '${AppUrls.invoice}?bookingId=$bookingId';

    final response = await apiService.getApiCallWithURL(endPoint: url);
    if (showLoader != null && showLoader) {
      cancelLoader();
    }
    if (response['message'].toString().toLowerCase().contains('success')) {
      if (response['data'] != null) {
        Iterable iterable = response['data'] as Iterable;
        invoicesList = iterable.map((data) => InvoiceModel.fromJson(data)).toList();
      }
    } else {
      RIEWidgets.getToast(message: response['message'].toString(), color: CustomTheme.errorColor);
    }
    update();
  }

  Future<void> invoicePayment({required String invoiceId}) async {
    String url = AppUrls.payInvoice;
    showProgressLoader(Get.context!);
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {"id": invoiceId, "source": 'app'});
    cancelLoader();
    if (response['message'].toString().toLowerCase().contains('success') && response['data'] != null) {
      final paymentModel = RazorpayPaymentResponseModel.fromJson(response['data']);
      Get.to(() => InvoicePaymentScreen(paymentResponseModel: paymentModel));
    }
  }
}
