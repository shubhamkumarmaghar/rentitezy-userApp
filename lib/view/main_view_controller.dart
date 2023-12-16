import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/pdf/pdf_api.dart';
import 'package:rentitezy/pdf/pdf_new.dart';
import 'package:rentitezy/home/home_view/home_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/const/app_urls.dart';

class MainViewController extends GetxController {
  var userName = 'guest'.obs;
  var userId = 'guest'.obs;
  var userPhone = 'guest'.obs;
  var tenantId = 'guest'.obs;
  var tenantName = 'guest'.obs;
  var profileImg = 'guest'.obs;
  var isTenant = false.obs;
  final Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final propertyApiController = Get.put(HomeController());
  static MainViewController get to => Get.find();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void addToFav(String listingId) async {
    final response = await http.post(Uri.parse(AppUrls.addFav),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Auth-Token": GetStorage().read(Constants.token).toString()
        },
        body: jsonEncode(<String, String>{
          "listingId": listingId,
        }));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success']) {
        toast('Error', "Enter all address fields");
      }
    }
  }

  showInvoice(AgreementDet agreementDet, String tenantName) async {
    agreementDet.between = tenantName;
    final pdfFile = await PdfInvoice.generate(agreementDet);
    PdfApi.openFile(pdfFile);
  }

  AgreementDet tempPdf = AgreementDet(
      'Residential Rental Agreement',
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
      '',
      'TempAbout',
      'Rentiseazy',
      'TempValOne',
      'TempValTwo',
      'TempValFirstParty',
      'Coimbatore',
      'commencingFrom',
      'commencingEnding',
      'licenseAmount',
      'totalAdvance',
      'deducting',
      'licenseCharged',
      'notice1',
      'notice2',
      'premisesBearing',
      'consisting');

  bool isValidUser() {
    return userId.value.isNotEmpty ||
        userId.value != 'null' ||
        userId.value != 'guest';
  }
}
