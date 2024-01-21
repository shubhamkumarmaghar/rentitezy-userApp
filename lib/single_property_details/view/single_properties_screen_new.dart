// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import 'package:rentitezy/localDb/db_helper.dart';

import 'package:rentitezy/model/checkout_model.dart';
import 'package:rentitezy/widgets/const_widget.dart';

import 'package:scroll_page_view/scroll_page.dart';

import '../../theme/custom_theme.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/const/widgets.dart';
import '../../utils/view/rie_widgets.dart';
import '../../screen/checkout_screen.dart';

import '../controller/single_property_details_controller.dart';

class PropertiesDetailsPageNew extends StatefulWidget {
  const PropertiesDetailsPageNew({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<PropertiesDetailsPageNew> createState() => _PropertiesDetailsPageNew();
}

class _PropertiesDetailsPageNew extends State<PropertiesDetailsPageNew> {
  SinglePropertyDetailsController singlePropertyDetailsController =
      Get.put(SinglePropertyDetailsController(), permanent: false);
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController askQController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();

  Set<Marker> markers = {};
  String listingDetailsId = 'guest';
  String? availFrom;
  String bookingType = 'm';
  DateTime availFromDate = DateTime.now();
  final dbFavItem = DbHelper.instance;

  //PropertyModel? singleProPerty;

  @override
  void initState() {
    //singlePropertyDetailsController.getSinglePropertyDetails();
    //fetchSingleProperties(widget.propertyId);
    super.initState();
  }

/*
  void fetchSingleProperties(String id) async {


    String url = '${AppUrls.listingDetail}?id=$id';
    final response =
    await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "Auth-Token": GetStorage().read(Constants.token).toString()
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      bool success = body["success"];
      try {
        if (success) {
          singleProPerty = PropertyModel.fromJson(body["data"]);
          Future.delayed(const Duration(seconds: 3));
          if (singleProPerty != null) {
            await fetchUser(singleProPerty!);
            await fetchPropertyDetails(singleProPerty!);
            singlePropertyDetailsController.singlePage.value = false;
          } else {
            singlePropertyDetailsController.proFetch.value = 'Currently unavailable';
          }
        }
      } catch (e) {
        singlePropertyDetailsController.proFetch.value = 'Currently unavailable';
        debugPrint(e.toString());
      }
    } else {
      Get.snackbar("Error", 'Error during fetch api data');
    }
    setState(() {});
  }
*/
  Widget _imageView(String image) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: imgLoadWid(image, 'assets/images/user_vec.png', 320, screenWidth,
            BoxFit.cover),
      ),
    );
  }

  Widget containerBtn(String title) {
    return GestureDetector(
      onTap: () {
        // selectBookingTypeAlertDialog(context, 'Select Booking type',);
        showBottomLeads(title);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Constants.primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget? _indicatorBuilder(BuildContext context, int index, int length) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_outlined,
            size: 15,
            color: Colors.white,
          ),
          width(0.025),
          RichText(
            text: TextSpan(
              text: '${index + 1}',
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: Constants.fontsFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '/',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: Constants.fontsFamily,
                      color: Colors.white),
                ),
                TextSpan(
                  text: '$length',
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: Constants.fontsFamily,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget columnTxt(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Constants.textColor,
              fontSize: 13,
              fontWeight: FontWeight.normal),
        ),
        height(0.005),
        Text(
          subTitle,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget iconCard(String icon) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 241, 239, 239)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: iconWidget(icon, 30, 30),
        // child: Icon(
        //   iconData,
        //   size: 35,
        // ),
      ),
    );
  }

  Widget chip(String val) {
    return GestureDetector(
      onTap: () {
        askQController.value = TextEditingValue(text: val);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Constants.primaryColor),
        ),
        child: Center(
            child: Text(
          val,
          style: TextStyle(
              fontFamily: Constants.fontsFamily,
              fontSize: 13,
              color: const Color.fromARGB(255, 110, 109, 109)),
        )),
      ),
    );
  }

  bool loadingLeads = false;

  //TextEditingController flatNoController = TextEditingController();
  void showBottomLeads(String from) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
                builder: (BuildContext context, setState) =>
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'Please Fill Your Details',
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Center(
                                child: Container(
                              height: 1,
                              width: 40,
                              color: Colors.black,
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FilterChip(
                                    label: Text('Monthly Booking'),
                                    selectedColor: Colors.red.shade900,
                                    backgroundColor: Colors.grey,
                                    labelStyle: TextStyle(color: Colors.white),
                                    selected:
                                        singlePropertyDetailsController.list[0],
                                    onSelected: (value) {
                                      singlePropertyDetailsController.setChip(
                                          selectedIndex: 0);
                                      log('${value}');
                                      //  _peopleListController.showList = _peopleListController.maleList;
                                      // navigator?.pop();
                                      setState(() {});
                                    }),
                                FilterChip(
                                    label: Text('Daily Booking'),
                                    selectedColor: Colors.red.shade900,
                                    backgroundColor: Colors.grey,
                                    labelStyle: TextStyle(color: Colors.white),
                                    selected:
                                        singlePropertyDetailsController.list[1],
                                    onSelected: (value) {
                                      singlePropertyDetailsController.setChip(
                                          selectedIndex: 1);
                                      log('${value}');
                                      //  _peopleListController.showList = _peopleListController.maleList;
                                      // navigator?.pop();
                                      setState(() {});
                                    }),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              margin: contEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Constants.lightBg,
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 227, 225, 225)),
                              ),
                              child: DropdownButton(
                                underline: const SizedBox(),
                                isExpanded: true,
                                hint: Text(
                                  'Select Guest',
                                  style: TextStyle(
                                      color:
                                          Constants.getColorFromHex('CDCDCD'),
                                      fontFamily: Constants.fontsFamily),
                                ),
                                iconEnabledColor:
                                    Constants.getColorFromHex('CDCDCD'),
                                items: singlePropertyDetailsController.guestList
                                    .map((item) {
                                  return DropdownMenuItem(
                                    value: item.toString(),
                                    child: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() => singlePropertyDetailsController
                                      .dropdownValueGuest = newVal);
                                },
                                value: singlePropertyDetailsController
                                    .dropdownValueGuest,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            singlePropertyDetailsController.list[1] == true
                                ? title('Select Days', 15)
                                : title('Select Months', 15),
                            singlePropertyDetailsController.list[1] == true
                                ? Container(
                                    padding: const EdgeInsets.all(3),
                                    margin: contEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Constants.lightBg,
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 227, 225, 225)),
                                    ),
                                    child: DropdownButton(
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      hint: Text(
                                        'Select Days',
                                        style: TextStyle(
                                            color: Constants.getColorFromHex(
                                                'CDCDCD'),
                                            fontFamily: Constants.fontsFamily),
                                      ),
                                      iconEnabledColor:
                                          Constants.getColorFromHex('CDCDCD'),
                                      items: singlePropertyDetailsController
                                          .getDailyList()
                                          .map((item) {
                                        return DropdownMenuItem(
                                          value: item.toString(),
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontFamily: Constants.fontsFamily,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() =>
                                            singlePropertyDetailsController
                                                    .dropdownValueDaily =
                                                newVal.toString());
                                      },
                                      value: singlePropertyDetailsController
                                          .dropdownValueDaily,
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(3),
                                    margin: contEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Constants.lightBg,
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 227, 225, 225)),
                                    ),
                                    child: DropdownButton(
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      hint: Text(
                                        'Select Months',
                                        style: TextStyle(
                                            color: Constants.getColorFromHex(
                                                'CDCDCD'),
                                            fontFamily: Constants.fontsFamily),
                                      ),
                                      iconEnabledColor:
                                          Constants.getColorFromHex('CDCDCD'),
                                      items: singlePropertyDetailsController
                                          .monthList
                                          .map((item) {
                                        return DropdownMenuItem(
                                          value: item.toString(),
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontFamily: Constants.fontsFamily,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() =>
                                            singlePropertyDetailsController
                                                    .dropdownValueMonth =
                                                newVal.toString());
                                      },
                                      value: singlePropertyDetailsController
                                          .dropdownValueMonth,
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            title('Select Date', 15),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                color: Constants.lightBg,
                              ),
                              margin: contEdge,
                              padding: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () async {
                                  if (availFrom != null) {
                                    DateTime newDate = availFromDate
                                        .add(const Duration(days: 7));
                                    await showDatePicker(
                                      context: context,
                                      initialDate:
                                          singlePropertyDetailsController
                                              .currentDate,
                                      firstDate: availFromDate,
                                      lastDate: newDate,
                                    ).then((pickedDate) {
                                      if (pickedDate != null &&
                                          pickedDate !=
                                              singlePropertyDetailsController
                                                  .currentDate) {
                                        setState(() =>
                                            singlePropertyDetailsController
                                                .currentDate = pickedDate);
                                      }
                                    });
                                  } else {
                                    await showDatePicker(
                                      context: context,
                                      initialDate:
                                          SinglePropertyDetailsController()
                                              .currentDate,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 0)),
                                      lastDate: DateTime(2100),
                                    ).then((pickedDate) {
                                      if (pickedDate != null &&
                                          pickedDate !=
                                              singlePropertyDetailsController
                                                  .currentDate) {
                                        setState(() =>
                                            singlePropertyDetailsController
                                                .currentDate = pickedDate);
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: getCustomText(
                                          DateFormat.yMMMd().format(
                                              singlePropertyDetailsController
                                                  .currentDate),
                                          Constants.primaryColor,
                                          1,
                                          TextAlign.start,
                                          FontWeight.w400,
                                          15),
                                    ),
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Constants.textColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            height(0.05),
                            GestureDetector(
                              onTap: () async {
                                if (singlePropertyDetailsController.userId ==
                                        'null' ||
                                    singlePropertyDetailsController.userId ==
                                        'guest') {
                                  RIEWidgets.getToast(
                                      message:
                                          'You are not ${AppUrls.appName} user. Please Login/Register',
                                      color: CustomTheme.white);
                                } else if (singlePropertyDetailsController
                                            .dropdownValueGuest ==
                                        null ||
                                    singlePropertyDetailsController
                                            .dropdownValueGuest ==
                                        'null' ||
                                    singlePropertyDetailsController
                                        .dropdownValueGuest.isEmpty) {
                                  RIEWidgets.getToast(
                                      message: 'Select valid month',
                                      color: CustomTheme.white);
                                } else if (singlePropertyDetailsController
                                    .dropdownValueMonth.isEmpty) {
                                  RIEWidgets.getToast(
                                      message: 'Select valid month',
                                      color: CustomTheme.white);
                                } else {
                                  if (int.parse(singlePropertyDetailsController
                                          .dropdownValueGuest
                                          .toString()) >
                                      1) {
                                    alertDialog(
                                        context,
                                        'Booking Alert',
                                        'Valid ID /KYC should be provided at the time on check in',
                                        from);
                                  } else {
                                    singlePropertyDetailsController
                                        .submitReqBooking(from);
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: loadingLeads
                                    ? const Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'Submit',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: Constants.fontsFamily,
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                            ),
                            height(0.05),
                          ],
                        ))),
          );
        });
  }

  void submitReqBooking(String from) async {
    setState(() => loadingLeads = true);
    final f = DateFormat('yyyy-MM-dd');
    String url =
        "${AppUrls.checkout}?checkin=${f.format(singlePropertyDetailsController.currentDate)}&duration=$singlePropertyDetailsController.dropdownValueMonth&guest=$singlePropertyDetailsController.dropdownValueGuest&listingId=${singlePropertyDetailsController.singleProPerty?.data?.id}";
    dynamic result =
        await getCheckOut(url, GetStorage().read(Constants.token).toString());
    debugPrint("result");
    debugPrint(result.toString());
    bool success = result["success"];
    if (success) {
      bool isBack = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CheckOutPage(
                    from: from,
                    currentDate: singlePropertyDetailsController.currentDate,
                    propertyModel:
                        singlePropertyDetailsController.singleProPerty,
                    checkoutModel: CheckoutModel.fromJson(result['data']),
                  )));
      if (isBack) {
        setState(() => loadingLeads = false);
        Navigator.pop(context);
      }
    } else {
      setState(() => loadingLeads = false);
    }
  }

  Future<void> alertDialog(
      BuildContext context, String title, String subttitle, String from) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                fontFamily: Constants.fontsFamily,
              )),
          content: Text(subttitle,
              style: TextStyle(
                fontFamily: Constants.fontsFamily,
              )),
          actions: [
            CupertinoDialogAction(
                child: Text("YES",
                    style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                    )),
                onPressed: () async {
                  singlePropertyDetailsController.submitReqBooking(from);
                }),
            CupertinoDialogAction(
              child: Text("NO",
                  style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> selectBookingTypeAlertDialog(
    BuildContext context,
    String title,
  ) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                fontFamily: Constants.fontsFamily,
              )),
          actions: [
            CupertinoDialogAction(
                child: Text("Daily Booking",
                    style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                    )),
                onPressed: () async {
                  bookingType = 'd';
                  Navigator.of(context).pop();
                  showBottomLeads(title);
                  // singlePropertyDetailsController.submitReqBooking(from);
                }),
            CupertinoDialogAction(
              child: Text("Monthly Booking",
                  style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                  )),
              onPressed: () {
                bookingType = 'm';
                Navigator.of(context).pop();
                showBottomLeads(title);
              },
            )
          ],
        );
      },
    );
  }

  void issuesRequest({required String id}) async {
    try {
      dynamic result = await createIssuesApi(
        GetStorage().read(Constants.userId).toString(),
        id.toString(),
        askQController.text,
      );
      if (result['success']) {
        askQController.value = const TextEditingValue(text: '');
        showSnackBar(context, result['message']);
      } else {
        showSnackBar(context, result['message']);
      }
    } on Exception catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SinglePropertyDetailsController>(
        init: SinglePropertyDetailsController(),
        builder: (controller) {
          var data = controller.singleProPerty?.data;
          var images = data?.images;
          return Scaffold(
            body: controller.singlePage.value
                ? SizedBox(
                    height: screenHeight,
                    width: screenHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Constants.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        title(controller.proFetch.value, 14)
                      ],
                    ))
                : Stack(
                    children: [
                    /*  SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),*/
                      CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(0),
                            sliver: SliverToBoxAdapter(
                              child: SizedBox(
                                height: Get.height*0.36,
                                child: controller.singleProPerty?.data !=
                                            null &&
                                        controller.singleProPerty?.data
                                                ?.images !=
                                            null &&
                                        controller.singleProPerty!.data!
                                                .images!.length >
                                            1
                                    ? ScrollPageView(
                                        controller: ScrollPageController(),
                                        delay: const Duration(seconds: 4),
                                        indicatorAlign: Alignment.bottomLeft,
                                        indicatorPadding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.10,
                                            left: 5),
                                        indicatorWidgetBuilder:
                                            _indicatorBuilder,
                                        children: images!
                                            .map((image) =>
                                                _imageView('${image.url}'))
                                            .toList(),
                                      )
                                    : _imageView('${images?.first.url}'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: Get.height*0.64,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                decoration: BoxDecoration(
                                /*  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),*/
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 227, 225, 225)),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Text(
                                                          Constants.currency,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontFamily: Constants
                                                                  .fontsFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ),
                                                    WidgetSpan(
                                                      child: Text(
                                                          '.${data?.price}',
                                                          style: TextStyle(
                                                              fontFamily: Constants
                                                                  .fontsFamily,
                                                              color: Constants
                                                                  .black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text("Per Month",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      color: Constants
                                                          .primaryColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ],
                                          ),
                                          width(0.05),
                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 5),
                                            height: 20,
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          width(0.05),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Text(
                                                          Constants.currency,
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black,
                                                              fontSize: 18,
                                                              fontFamily: Constants
                                                                  .fontsFamily,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal)),
                                                    ),
                                                    WidgetSpan(
                                                      child: Text(
                                                          '.${data?.price}',
                                                          style: TextStyle(
                                                              fontFamily: Constants
                                                                  .fontsFamily,
                                                              color: Constants
                                                                  .black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text("Daily",
                                                  style: TextStyle(
                                                      fontFamily:
                                                      Constants.fontsFamily,
                                                      color: Constants
                                                          .primaryColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight.normal))
                                            ],
                                          ),
                                          width(0.05),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            height: 20,
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          width(0.05),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              '${data?.property?.plots} Plots',
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.fontsFamily,
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                width: 200,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3),
                                                      child: iconWidget(
                                                          'location', 13, 13),
                                                    ),
                                                    SizedBox(
                                                      width: 180,
                                                      child: Text(
                                                          '${data?.property!.address}',
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontFamily: Constants
                                                                  .fontsFamily,
                                                              color: Constants
                                                                  .textColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    )
                                                  ],
                                                )),
                                            SizedBox(
                                              width: 120,
                                              height: 40,
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    /*   openDialPad(
                                                      '${data?.property?.ownerPhone}',
                                                      context);*/
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Constants.primaryColor,
                                                  ),
                                                  icon: iconWidget(
                                                      'phone', 30, 30),
                                                  label: Text(
                                                    'Contact',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: Constants
                                                            .fontsFamily,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      height(0.005),
                                      sTitle(
                                          'Property Details',
                                          15,
                                          const Color.fromARGB(255, 73, 72, 72),
                                          FontWeight.w500),
                                      height(0.005),
                                      Text(
                                        '${data!.property?.name}',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontFamily: Constants.fontsFamily,
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      height(0.005),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 150,
                                              child: columnTxt('BHK',
                                                  '${data.listingType}')),
                                          SizedBox(
                                              width: 150,
                                              child: columnTxt('Floor',
                                                  '${data.property?.floor}'))
                                        ],
                                      ),
                                      height(0.005),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 150,
                                              child: columnTxt('Flat Type',
                                                  '${data.furnishType}')),
                                          SizedBox(
                                              width: 150,
                                              child: columnTxt('Covered Area',
                                                  '${data.area} Sqft'))
                                        ],
                                      ),
                                      height(0.005),
                                      columnTxt(
                                          'City', '${data.property?.city} '),
                                      height(0.005),
                                      sTitle(
                                          'Description :',
                                          17,
                                          const Color.fromARGB(255, 73, 72, 72),
                                          FontWeight.w500),
                                      width(0.005),
                                      Text(
                                        '${data.description}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: Constants.fontsFamily,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      height(0.005),
                                      sTitle(
                                          'Amenities',
                                          17,
                                          const Color.fromARGB(255, 73, 72, 72),
                                          FontWeight.w500),
                                      height(0.005),
                                      // SizedBox(
                                      //   height: 70,
                                      //   child: ListView(
                                      //       shrinkWrap: true,
                                      //       scrollDirection: Axis.horizontal,
                                      //       physics: const BouncingScrollPhysics(),
                                      //       children: singleProPerty!.amenitiesList
                                      //           .map((e) => iconCard(mapIcon(e)!))
                                      //           .toList()),
                                      // ),
                                      // height(10),
                                      sTitle(
                                          'Have a question?',
                                          15,
                                          const Color.fromARGB(255, 73, 72, 72),
                                          FontWeight.w500),
                                      width(0.005),
                                      sTitle('Get a quick answer right here',
                                          11, Colors.grey, FontWeight.normal),
                                      height(0.005),
                                      Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 214, 212, 212)),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: askQController,
                                                  decoration: InputDecoration(
                                                      hoverColor:
                                                          Constants.hint,
                                                      hintText: '',
                                                      border: InputBorder.none),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (askQController
                                                      .text.isEmpty) {
                                                    showSnackBar(context,
                                                        'Enter valid Question');
                                                  } else {
                                                    issuesRequest(
                                                        id: data.id.toString());
                                                  }
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    color:
                                                        Constants.primaryColor,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Ask now',
                                                      style: TextStyle(
                                                          fontFamily: Constants
                                                              .fontsFamily,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ),
                                      height(0.005),
                                      SizedBox(
                                        height: 50,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          children: [
                                            chip('Price negotiable?'),
                                            chip('Still available?'),
                                            chip('Can you show me more?')
                                          ],
                                        ),
                                      ),
                                      height(0.005),
                                      Container(
                                        height: screenHeight * 0.20,
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GoogleMap(
                                            markers: markers,
                                            mapType: MapType.normal,
                                            initialCameraPosition: CameraPosition(
                                                target: data!
                                                            .property?.latlng ==
                                                        'undefined,undefined'
                                                    ? const LatLng(0.0, 0.0)
                                                    : LatLng(
                                                        double.parse(
                                                            '${data!.property?.latlng}'
                                                                .split(',')[0]),
                                                        double.parse(
                                                            '${data!.property?.latlng}'
                                                                .split(
                                                                    ',')[1])),
                                                zoom: 13.0,
                                                tilt: 0,
                                                bearing: 0),
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              _controller.complete(controller);
                                            }),
                                      ),
                                      height(0.009),
                                    ]),
                              ),
                            ),
                          )),
                      /*        Positioned(
                        right: 15,
                        top: MediaQuery.of(context).size.height * 0.05,
                        child: circleContainer(
                            IconButton(
                                onPressed: () async {
                                  if (listingDetailsId.isNotEmpty) {
                                    dynamic result =
                                        await addToFav(listingDetailsId);
                                    if (result['message'].toString() == 'Success') {
                                      addToFavItem(singleProPerty!);
                                    }
                                  }
                                },
                                icon: Icon(
                                  singleProPerty!.isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: singleProPerty!.isFav
                                      ? Colors.red
                                      : Colors.black,
                                )),
                            Colors.white,
                            100,
                            35,
                            35)),*/
                      Positioned(
                          left: 15,
                          top: MediaQuery.of(context).size.height * 0.05,
                          child: circleContainer(
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_sharp,
                                    size: 18,
                                    color: Colors.black,
                                  )),
                              Colors.white,
                              100,
                              35,
                              35)),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Visibility(
                          visible: data.availFrom == null ||
                              checkforBooking(data.availFrom) == true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Expanded(flex: 1, child: containerBtn('Request')),
                                Expanded(
                                    flex: 1, child: containerBtn('Book Now')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}

bool checkforBooking(String date) {
  String dateTime;

  DateTime datee = DateTime.parse(date);
  dateTime = DateFormat('dd-MM-yyyy').format(datee);
  if (DateTime.now().isAfter(datee)) {
    return true;
  } else {
    return false;
  }
}
