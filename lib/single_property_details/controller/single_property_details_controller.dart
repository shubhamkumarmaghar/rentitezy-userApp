import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../../home/home_controller/home_controller.dart';
import '../../model/checkout_model.dart';
import '../../screen/checkout_screen.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/api.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/view/rie_widgets.dart';
import '../../web_view/webview_payment.dart';
import '../model/single_property_details_model.dart';

class SinglePropertyDetailsController extends GetxController {
  String? id = '';
  String cfrom = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool singlePage = true.obs;
  List<bool> list = [true, false];
  List<bool> sitiVisitTypeList = [true, false];

  void setChip({required int selectedIndex}) {
    list = list.map((e) => false).toList();
    list[selectedIndex] = true;
    //update();
  }

  void setSourceChip({required int selectedIndex}) {
    sitiVisitTypeList = sitiVisitTypeList.map((e) => false).toList();
    sitiVisitTypeList[selectedIndex] = true;
    //update();
  }

  RxString proFetch = 'Data Fetching...Please wait'.obs;
  List<String> guestList = ['1', '2', '3', '4', '5'];
  List<String> monthList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11'
  ];
  List<String> sourceList = [
    'Source',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11'
  ];

  List<String> getDailyList() {
    List<String> monthList = [];
    for (int i = 1; i < 32; i++) {
      monthList.add('$i');
    }
    return monthList;
  }

  var dropdownValueGuest;
  var dropdownValueMonth = '11';
  var dropdownValueSource = 'Source';
  var dropdownValueDaily = '1';
  var selectFlat;
  CheckoutModel? checkoutModel;

  DateTime currentDate = DateTime.now();
  HomeController homeController = Get.find();
  SinglePropertyDetails? singleProPerty;
  final List propertyImages = [];

  @override
  void onInit() {
    super.onInit();
    //id= Get.arguments ??'0';
    // getSinglePropertyDetails();
    getalldata();
  }

  void getalldata() async {
    id = await Get.arguments ?? '0';
    log('property ID $id');
    await getSinglePropertyDetails();
    nameController = TextEditingController(
        text: GetStorage().read(Constants.usernamekey)
            .toString());
    phoneController = TextEditingController(
        text: GetStorage().read(Constants.phonekey)
            .toString());
    emailController = TextEditingController(
        text: GetStorage().read(Constants.emailkey)
            .toString());
  }

  Future<void> getSinglePropertyDetails() async {
    String url = '${AppUrls.listingDetail}?id=$id';
    singlePage.value = true;
    final response = await homeController.apiService.getApiCallWithURL(
        endPoint: url);
    String success = response["message"];
    if (success == 'success') {
      singleProPerty = SinglePropertyDetails.fromJson(response);
      update();
    }
    else {
      proFetch.value = 'Currently unavailable';
      update();
    }
    singlePage.value = false;
    update();
  }

  void submitReqBooking(String from) async {
    cfrom = from;
    String duration = '';
    singlePage.value = true;
    final f = DateFormat('yyyy-MM-dd');
    if (list[0] == true) {
      duration = '${dropdownValueMonth}m';
    }
    else {
      duration = '${dropdownValueDaily}d';
    }
    String url =
        "${AppUrls.checkout}?checkin=${f.format(
        currentDate)}&duration=$duration&guest=$dropdownValueGuest&listingId=${singleProPerty
        ?.data?.id}";
    final response = await homeController.apiService.getApiCallWithURL(
        endPoint: url);

    /* dynamic result = await getCheckOut(
        url, GetStorage().read(Constants.token).toString());*/
    debugPrint(response.toString());
    String success = response["message"];
    if (success == 'success') {
      checkoutModel = CheckoutModel.fromJson(response['data']);
      singlePage.value = false;
      await Get.to(CheckOutPage(
          from: from,
          currentDate: currentDate,
          propertyModel: singleProPerty,
          checkoutModel: checkoutModel
      ));
    }
    else {
      singlePage.value = false;
      Get.back();
    }

    /*
    if (success) {
      bool isBack = Get.to(CheckOutPage(
        from: from,
        currentDate: currentDate,
        propertyModel: singlePropertyDetailsController.singleProPerty,
        checkoutModel: CheckoutModel.fromJson(result['data']),
      ));
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
          )
      );
      if (isBack) {
        setState(() => loadingLeads = false);
        Navigator.pop(context);
      }
    } else {
      setState(() => loadingLeads = false);
    }*/
  }

  void submitSiteVisit(String from) async {
    cfrom = from;
    String duration = '';
    singlePage.value = true;
    final f = DateFormat('yyyy-MM-dd');
    String url = AppUrls.siteVisit;
    final response = await homeController.apiService.postApiCall(
        endPoint: url,
    bodyParams: {
      'phone':phoneController.text,
      'listingId':id,
      'date':currentDate.toString(),
      'type':sitiVisitTypeList[0]==true ? 'online' :'offline',
      'source':'app'
    });

    /* dynamic result = await getCheckOut(
        url, GetStorage().read(Constants.token).toString());*/
    debugPrint(response.toString());
    String success = response["message"];
    if (success.toString().toLowerCase() == 'success') {
      RIEWidgets.getToast(message: 'You have successfully scheduled site visit', color: CustomTheme.white);
      singlePage.value = false;
      Get.back();
    }
    else {
      Get.back();
      singlePage.value = false;
    }

    /*
    if (success) {
      bool isBack = Get.to(CheckOutPage(
        from: from,
        currentDate: currentDate,
        propertyModel: singlePropertyDetailsController.singleProPerty,
        checkoutModel: CheckoutModel.fromJson(result['data']),
      ));
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
          )
      );
      if (isBack) {
        setState(() => loadingLeads = false);
        Navigator.pop(context);
      }
    } else {
      setState(() => loadingLeads = false);
    }*/
  }



  void paymentRequest(String cartId) async {
    String url = AppUrls.checkout;
    // String a = 'intent://pay?pa=BasisPay1779@icici&pn=Rentiseazy&mc=&tr=ATC2933673&tn=PayTo:6546032&am=11000.00&mam=11000.00&cu=INR&/#Intent;scheme=upi;package=net.one97.paytm;end';
    // String uaa = a.replaceAll('intent', 'upi');
    //UrlLauncher.launchUrl(Uri.parse(uaa));
//
    // log('abced :::: $uaa');
    singlePage.value = true;
    // await launchUrlString('https://www.instamojo.com/@Rentiseazy/492e2287666a4abc9fddcad9c8208768');
    final response = await homeController.apiService.postApiCall(endPoint: url,
        bodyParams: {
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "cartId": cartId,
        });
    if (response['success']) {
      debugPrint("longurl ${response['data']}");
      String longurl = response['data']['longurl'];
      log('abced $longurl');

      //await launchUrlString(longurl);
      if (cfrom == 'Request') {
        leadsRequest();
      } else {
        singlePage.value = false;
        Get.offAll(WebViewContainer(url: longurl));
        /*  Get.to(MyBookingsScreen(
          from: true,
        ));*/
      }
      //singlePage.value = false;
    }
  }


  void leadsRequest() async {
    print('create-leads');
    var data = singleProPerty?.data;
    var propertyData = data?.property;
    if (propertyData != null) {
      try {
        dynamic result = await createLeadsApi(
          GetStorage().read(Constants.usernamekey).toString(),
          GetStorage().read(Constants.phonekey).toString(),
          propertyData.address == ''
              ? 'NA'
              : '${propertyData.address}',
          'NA',
          '${propertyData.facilities}',
          DateFormat.yMMMd().format(currentDate),
          '${data?.price}',
          GetStorage().read(Constants.userId).toString(),
          '${propertyData.id}',
          '${data?.listingType}',);
        if (result['success']) {
          RIEWidgets.getToast(
              message: result['message'], color: CustomTheme.white);

          // showCustomToast(context, result['message']);
          Get.back();
        } else {
          RIEWidgets.getToast(
              message: result['message'], color: CustomTheme.white);
          //showCustomToast(context, result['message']);
        }
      } on Exception catch (error) {
        RIEWidgets.getToast(
            message: error.toString(), color: CustomTheme.white);
        // showCustomToast(context, error.toString());
      }
    }
  }

}