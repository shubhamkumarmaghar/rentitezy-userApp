import 'package:get/get.dart';
import 'package:rentitezy/invoices/model/invoice_model.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../web_view/webview_payment.dart';

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

  Future<void> fetchInvoices() async {
    String url = '${AppUrls.invoice}?bookingId=$bookingId';

    final response = await apiService.getApiCallWithURL(endPoint: url);

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
    String url = AppUrls.invoicePay;
    showProgressLoader(Get.context!);
    final response = await apiService.postApiCall(endPoint: url, bodyParams: {
      "invoiceId": invoiceId,
    });
    cancelLoader();
    if (response['message'].toString().toLowerCase().contains('success')) {
      String longUrl = response['data']['longurl'];
      Get.off(WebViewContainer(url: longUrl));
    } else {
      RIEWidgets.getToast(message: response['message'].toString(), color: CustomTheme.errorColor);
    }
  }
}
