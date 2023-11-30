// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/checkout_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/screen/my_bookings/my_booking_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CheckOutPage extends StatefulWidget {
  final CheckoutModel checkoutModel;
  final String from;
  final PropertyModel? propertyModel;
  final DateTime? currentDate;
  const CheckOutPage(
      {super.key,
      required this.checkoutModel,
      required this.from,
      this.currentDate,
      this.propertyModel});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Widget textWid(String txt, Color clr, double font, FontWeight fw) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: Constants.fontsFamily,
          color: clr,
          fontSize: font,
          fontWeight: fw),
    );
  }

  Widget columnTxt(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWid(title, Constants.black, 15, FontWeight.normal),
        textWid(subTitle, Constants.black, 13, FontWeight.bold)
      ],
    );
  }

  bool loadingLeads = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void apiReq(StateSetter setState, String cartId, BuildContext context) async {
    var sharedPreferences = await _prefs;
    dynamic result = await checkOutUrl(
      nameController.text,
      emailController.text,
      phoneController.text,
      cartId,
      sharedPreferences.getString(Constants.token).toString(),
    );
    if (result['success']) {
      debugPrint("longurl ${result['data']}");
      String longurl = result['data']['longurl'];
      launchUrlString(longurl);
      if (widget.from == 'Request') {
        leadsRequest();
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBookingsScreen(
                      from: true,
                    )));
      }
      setState(() => loadingLeads = true);
    }
  }

  void showBottomDetails(String data, BuildContext context) {
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Name",
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Email",
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Phone",
                                ),
                              ),
                            ),
                            height(25),
                            GestureDetector(
                              onTap: () async {
                                if (nameController.text.isEmpty) {
                                  showCustomToast(context, 'Enter valid name');
                                } else if (emailController.text.isEmpty) {
                                  showCustomToast(context, 'Enter valid email');
                                } else if (phoneController.text.isEmpty) {
                                  showCustomToast(context, 'Enter valid phone');
                                } else if (phoneController.text.length != 10) {
                                  showCustomToast(
                                      context, 'Enter valid phone digit');
                                } else {
                                  setState(() => loadingLeads = true);
                                  apiReq(setState, data, context);
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
                            height(15),
                          ],
                        ))),
          );
        });
  }

  void leadsRequest() async {
    print('create-leads');
    var sharedPreferences = await _prefs;
    if (widget.propertyModel != null) {
      try {
        dynamic result = await createLeadsApi(
            sharedPreferences.getString(Constants.usernamekey).toString(),
            sharedPreferences.getString(Constants.phonekey).toString(),
            widget.propertyModel!.address.isEmpty
                ? 'NA'
                : widget.propertyModel!.address,
            'NA',
            widget.propertyModel!.facility,
            DateFormat.yMMMd().format(widget.currentDate!),
            widget.propertyModel!.price,
            sharedPreferences.getString(Constants.userId).toString(),
            widget.propertyModel!.id,
            widget.propertyModel!.bhkType);
        if (result['success']) {
          showCustomToast(context, result['message']);
          Navigator.pop(context, true);
        } else {
          showCustomToast(context, result['message']);
        }
      } on Exception catch (error) {
        showCustomToast(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Constants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          height: 80,
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
                'Checkout',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: StatefulBuilder(
                    builder: ((context, setState) => ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt(
                                          "Name", widget.checkoutModel.name)),
                                  Expanded(
                                      child: columnTxt("Address",
                                          widget.checkoutModel.address))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt("Move In",
                                          widget.checkoutModel.moveIn)),
                                  Expanded(
                                      child: columnTxt("Move Out",
                                          widget.checkoutModel.moveOut))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt("Duration",
                                          widget.checkoutModel.duration)),
                                  Expanded(
                                      child: columnTxt("Rent",
                                          '${Constants.currency}.${widget.checkoutModel.rent}'))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt("Deposit",
                                          '${Constants.currency}.${widget.checkoutModel.deposit}')),
                                  Expanded(
                                    child: columnTxt("OnBoarding",
                                        widget.checkoutModel.onboarding),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt(
                                          "Guest", widget.checkoutModel.guest)),
                                  Expanded(
                                      child: columnTxt("Lock In",
                                          widget.checkoutModel.lockIn))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt("Amount",
                                          '${Constants.currency}.${widget.checkoutModel.amount}')),
                                  Expanded(
                                      child: columnTxt("Total",
                                          '${Constants.currency}.${widget.checkoutModel.total}'))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: columnTxt("Maintenance",
                                          '${Constants.currency}.${widget.checkoutModel.maintenance}'))
                                ],
                              ),
                            ),
                            height(20),
                            InkWell(
                              onTap: () async {
                                var sharedPreferences = await _prefs;
                                nameController = TextEditingController(
                                    text: sharedPreferences
                                        .getString(Constants.usernamekey)
                                        .toString());
                                phoneController = TextEditingController(
                                    text: sharedPreferences
                                        .getString(Constants.phonekey)
                                        .toString());
                                emailController = TextEditingController(
                                    text: sharedPreferences
                                        .getString(Constants.emailkey)
                                        .toString());
                                showBottomDetails(
                                    widget.checkoutModel.cardId, context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
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
                          ],
                        )))))
      ]),
    );
  }
}
