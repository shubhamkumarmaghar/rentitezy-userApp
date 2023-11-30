// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/rent_req_model.dart';
import 'package:rentitezy/model/tenant_model.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:rentitezy/pdf/pdf_api.dart';
import 'package:rentitezy/pdf/pdf_bill.dart';
import 'package:rentitezy/screen/my_bookings/my_booking_controller.dart';
import 'package:rentitezy/screen/thankyou_page.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/const/app_urls.dart';
import 'my_bookings/booking_model.dart';

class RentRemainScreen extends StatefulWidget {
  const RentRemainScreen({super.key});

  @override
  State<RentRemainScreen> createState() => _MartHomeState();
}

class _MartHomeState extends State<RentRemainScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool isTenant = false;
  String userId = '';
  String tenantId = '';
  // late Future<List<TenantModel>> futureTenant;
  late Future<List<RentReqModel>> futureRentHistory;
  late Future<List<RentReqModel>> futureRentPending;

  TenantModel? tempTenant;

  TextEditingController transIdController = TextEditingController();
  var controller = Get.put(MyBookingController());

  @override
  void initState() {
    super.initState();
    // futureTenant = fetchTenant();
    futureRentHistory = fetchRentHistory();
    futureRentPending = fetchRentPending();
    fetchUser();
  }

  void fetchUser() async {
    SharedPreferences sharedPreferences = await prefs;
    if (sharedPreferences.containsKey(Constants.userId) &&
        (sharedPreferences.getString(Constants.userId) != null)) {
      dynamic result = await fetchTenantUserApi(
          '${AppUrls.getUser}?id=${sharedPreferences.getString(Constants.userId).toString()}');
      if (result["success"]) {
        UserModel userModel = UserModel.fromJson(result["data"][0]);
        sharedPreferences.setString(Constants.userId, userModel.id);
        userId = userModel.id.toString();
        // if (result['isTenant']) {
        // TenantModel tempTenant = TenantModel.fromJson(result['tenantDet']);
        if (sharedPreferences.getBool(Constants.isTenant)!) {
          tenantId = userModel.id.toString();
          sharedPreferences.setString(
              Constants.tenantId, userModel.id.toString());
          isTenant = sharedPreferences.getBool(Constants.isTenant)!;
        }
        // sharedPreferences.setBool(Constants.isTenant, true);
        // tenantId = userModel.id;
        // isTenant = sharedPreferences.getBool(Constants.isTenant)!;
        // sharedPreferences.setString(Constants.tenantId, userModel.id);
        sharedPreferences.setString(Constants.profileUrl, userModel.image);
        // sharedPreferences.setBool(Constants.isTenant, true);
        // if (tempTenant.isAgree == 'true') {
        //   sharedPreferences.setBool(Constants.isAgree, true);
        // } else {
        //   sharedPreferences.setBool(Constants.isAgree, false);
        // }
        // } else {
        //   isTenant = false;
        //   sharedPreferences.setString(
        //       Constants.usernamekey, userModel.firstName);
        //   sharedPreferences.setString(Constants.phonekey, userModel.phone);
        //   sharedPreferences.setString(Constants.emailkey, userModel.email);
        //   sharedPreferences.setString(Constants.profileUrl, userModel.image);
        // }
      } else {
        isTenant = false;
        userId = 'guest';
        sharedPreferences.setString(Constants.tenantId, 'guest');
        sharedPreferences.setBool(Constants.isTenant, false);
        sharedPreferences.setBool(Constants.isAgree, false);
      }
    } else {
      isTenant = false;
      userId = 'guest';
      sharedPreferences.setString(Constants.tenantId, 'guest');
      sharedPreferences.setBool(Constants.isTenant, false);
      sharedPreferences.setBool(Constants.isAgree, false);
    }
    setState(() {});
  }

  Future<void> alertDialog(
      BuildContext context, String title, String subttitle, String amount) {
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
                onPressed: () async {}),
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

  Widget boxText(String day) {
    return Container(
      height: 40,
      width: 34,
      padding: const EdgeInsets.only(top: 7, bottom: 7, left: 9, right: 9),
      margin: const EdgeInsets.only(top: 7, bottom: 7, right: 0, left: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Constants.greyLight,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
              fontFamily: Constants.fontsFamily,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  int tabPos = 0;

  Widget tabItem(String title, int pos) {
    return GestureDetector(
      onTap: () {
        tabPos = pos;
        setState(() {});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          height(5),
          Container(
            height: 2,
            width: 100,
            color: tabPos == pos ? Constants.primaryColor : null,
          )
        ],
      ),
    );
  }

  List<String> listTab = ['Pending/0', 'Paid/1'];

  showInvoice(RentReqModel agreementDet) async {
    final pdfFile = await PdfBillInvoice.generate(agreementDet);
    PdfApi.openFile(pdfFile);
  }

  Widget rentPaid(RentReqModel remin) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getFormatedDate(remin.createdOn),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      remin.status.toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${Constants.currency}.${remin.payable}/-',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        onSurface: Colors.grey,
                      ),
                      onPressed: () async {
                        var sharedPreferences = await prefs;
                        remin.userName = sharedPreferences
                            .getString(Constants.usernamekey)
                            .toString();
                        remin.userPhone = sharedPreferences
                            .getString(Constants.phonekey)
                            .toString();
                        showInvoice(remin);
                      },
                      child: Text(
                        'Invoice',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: Constants.fontsFamily,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constants.green,
                ),
                child: Center(
                  child: Text(
                    'Paid',
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  List<String> payTypes = ['RPAY', 'ONLINE', 'UPI'];

//payment alert
  void showPayAlert(String id) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
              content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: title('Select Payment Options', 17),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(payTypes.length, (int index) {
                    return RadioListTile<int>(
                      value: index,
                      groupValue: selectedRadio,
                      title: title(payTypes[index], 13),
                      onChanged: (int? value) {
                        setState(() => selectedRadio = value!);
                      },
                    );
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: title('NO', 15)),
                    width(10),
                    TextButton(
                        onPressed: () {
                          // if (selectedRadio == 0) {
                          //   openCheckout(payAmt);
                          // } else if (selectedRadio == 1) {
                          //   getCashFreeTocken(id, true);
                          // } else {
                          //   getCashFreeTocken(id, false);
                          // }
                          // Navigator.pop(context);
                        },
                        child: title('YES', 15))
                  ],
                )
              ],
            ),
          ));
        });
      },
    );
  }

  void payRequest(String id, String payId, String amt) async {
    var sharedPreferences = await prefs;
    var response = await http.get(Uri.parse(AppUrls.myBooking), headers: {
      'auth-token': sharedPreferences.getString(Constants.token).toString()
    });
    var responseData = jsonDecode(response.body);
    await Future.delayed(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      if (responseData['success']) {
        final List<MyBookingModel> photosList = (responseData["data"] as List)
            .map((stock) => MyBookingModel.fromJson(stock))
            .toList();
        if (photosList.isNotEmpty) {
          try {
            dynamic result = await createPaymentRequest(
                photosList.first.invoicesList.first.id,
                sharedPreferences.getString(Constants.token).toString());

            if (result['success']) {
              String longurl = result['data']['longurl'];
              launchUrlString(longurl);
              await Future.delayed(const Duration(seconds: 3));
              futureRentHistory = fetchRentHistory();
              // futureTenant = fetchTenant();
              showSnackBar(context, result['message']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThankYouPage()));
            } else {
              showSnackBar(context, result['message']);
            }
          } on Exception catch (error) {
            showSnackBar(context, error.toString());
          }
        }
      }
    }
  }

  Widget rentPending(RentReqModel tenant) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 95,
        width: MediaQuery.of(context).size.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.fromDate.split('T')[0],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ID: #${tenant.bookingId}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${Constants.currency}.${tenant.payable}/-',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (tenant.status != 'request') {
                    payRequest('', '', tenant.payable);
                  } else {
                    showSnackBar(context, "The request has already been sent");
                  }
                },
                child: Container(
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        tenant.status != 'request' ? Colors.red : Colors.amber,
                  ),
                  child: Center(
                    child: Text(
                      tenant.status != 'request'
                          ? 'PAY'
                          : tenant.status.toUpperCase(),
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          color: Colors.white,
                          //fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  // Future<List<TenantModel>> fetchTenant() async {
  //   var sharedPreferences = await prefs;
  //   if (sharedPreferences.containsKey(Constants.tenantId)) {
  //     if (sharedPreferences.getString(Constants.tenantId) != 'null' &&
  //         sharedPreferences.getString(Constants.tenantId) != 'guest' &&
  //         sharedPreferences.getString(Constants.tenantId) != 'Null' &&
  //         sharedPreferences.getString(Constants.tenantId) != 'NULL' &&
  //         sharedPreferences.getString(Constants.tenantId)!.isNotEmpty) {
  //       var list = fetchTenantApi(
  //           '${AppConfig.tenant}?id=${sharedPreferences.getString(Constants.tenantId)}');
  //       futureTenant = Future.value(list);
  //       List<TenantModel> listTenant = await list;
  //       if (listTenant.isNotEmpty) {
  //         tempTenant = listTenant.first;
  //       }
  //       setState(() {});
  //       return list;
  //     }
  //   }
  //   return [];
  // }

  Future<List<RentReqModel>> fetchRentHistory() async {
    if (controller.myBookingData.isNotEmpty) {
      var sharedPreferences = await prefs;
      var list = getAllRentReq(
          '${AppUrls.rentReq}?bookingId=${controller.myBookingData.first.bookingId}',
          sharedPreferences.getString(Constants.token).toString());
      return Future.value(list);
    }
    return [];
  }

  Future<List<RentReqModel>> fetchRentPending() async {
    if (controller.myBookingData.isNotEmpty) {
      var sharedPreferences = await prefs;
      var list = getAllRentReq(
          '${AppUrls.rentReq}?bookingId=${controller.myBookingData.first.bookingId}',
          sharedPreferences.getString(Constants.token).toString());
      return Future.value(list);
    }
    return [];
  }

  Widget fetchMyAssetsReq() {
    return FutureBuilder<List<RentReqModel>>(
        future: futureRentHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return listRentReq(snapshot.data!);
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {
                futureRentHistory = fetchRentHistory();
              }));
            }
          }

          return loading();
        });
  }

  Widget fetchMyRentPending() {
    return FutureBuilder<List<RentReqModel>>(
        future: futureRentPending,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return listRemainRent(snapshot.data!);
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {
                futureRentPending = fetchRentPending();
              }));
            }
          }

          return loading();
        });
  }

  Widget listRentReq(List<RentReqModel> rentList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: rentList.length,
      itemBuilder: (BuildContext context, int index) =>
          rentPaid(rentList[index]),
    );
  }

  Widget listRemainRent(List<RentReqModel> rentList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: rentList.length,
      itemBuilder: (BuildContext context, int index) =>
          rentPending(rentList[index]),
    );
  }

  Widget fetchRemainRent() {
    // return FutureBuilder<List<TenantModel>>(
    //     future: futureTenant,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.none) {
    //         return loading();
    //       } else if (snapshot.connectionState == ConnectionState.waiting) {
    //         return loading();
    //       } else if (snapshot.connectionState == ConnectionState.done) {
    //         if (snapshot.hasData) {
    return controller.isLoading.value
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Constants.primaryColor,
            ),
          )
        : Stack(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Stack(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Rent Reminder',
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
            Visibility(
                visible: isTenant,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.height * 0.41,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    height(3),
                                    Text(
                                      controller.myBookingData.first.name
                                                  .length >
                                              11
                                          ? controller.myBookingData.first.name
                                              .substring(0, 11)
                                          : controller.myBookingData.first.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: Constants.fontsFamily,
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      controller.myBookingData.isNotEmpty
                                          ? (controller
                                                      .myBookingData
                                                      .first
                                                      .property!
                                                      .propListing
                                                      .property
                                                      .name
                                                      .length >
                                                  11
                                              ? controller
                                                  .myBookingData
                                                  .first
                                                  .property!
                                                  .propListing
                                                  .property
                                                  .name
                                                  .substring(0, 11)
                                              : controller
                                                  .myBookingData
                                                  .first
                                                  .property!
                                                  .propListing
                                                  .property
                                                  .name)
                                          : 'Not Applicable',
                                      style: TextStyle(
                                          fontFamily: Constants.fontsFamily,
                                          color: Constants.textColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      'Last Pay : --',
                                      style: TextStyle(
                                          fontFamily: Constants.fontsFamily,
                                          color: Constants.primaryColor,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     Row(
                                      children: [
                                        // boxText(getDayCount(
                                        //     snapshot.data!.first.payDate)[0]),
                                        // boxText(getDayCount(
                                        //     snapshot.data!.first.payDate)[1]),
                                      ],
                                    ),
                                    Text(
                                      'Remining Days',
                                      style: TextStyle(
                                          fontFamily: Constants.fontsFamily,
                                          color: Constants.primaryColor,
                                          fontSize: 13),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))),
            Positioned(
                top: isTenant
                    ? MediaQuery.of(context).size.height * 0.29
                    : MediaQuery.of(context).size.height * 0.20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: listTab
                        .map((e) => tabItem(
                            e.split('/')[0], int.parse(e.split('/')[1])))
                        .toList(),
                  ),
                )),
            Visibility(
              visible: tabPos == 0 && isTenant,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: screenHeight * 0.62,
                      child: fetchMyRentPending())),
            ),
            Visibility(
              visible: tabPos == 1 && isTenant,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: screenHeight * 0.62,
                      child: fetchMyAssetsReq())),
            ),
            Visibility(
                visible: !isTenant,
                child: const Center(
                  child: Text('You are not Rentiseasy Tenant'),
                )),
          ]);
    // } else if (snapshot.hasError) {
    //   return reloadErr(snapshot.error.toString(), (() {
    // futureTenant = fetchTenant();
    // }));
    // }
    // }

    //   return loading();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Constants.primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: isTenant
            ? fetchRemainRent()
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    height(15),
                    title('Fetching Tenant Data', 18)
                  ],
                )),
              ),
      ),
    );
  }
}
