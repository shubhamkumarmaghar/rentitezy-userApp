// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/localDb/db_helper.dart';
import 'package:rentitezy/localDb/fav_model.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:scroll_page_view/scroll_page.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/const/widgets.dart';
import '../../utils/view/rie_widgets.dart';
import 'package:http/http.dart' as http;

import '../controller/single_property_details_controller.dart';

class PropertiesDetailsPage extends StatefulWidget {
  const PropertiesDetailsPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<PropertiesDetailsPage> createState() => _MartHomeState();
}

class _MartHomeState extends State<PropertiesDetailsPage> {
  TextEditingController askQController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();

  List<String> guestList = ['1', '2', '3', '4', '5'];
  List<String> monthList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
  var dropdownValueGuest;
  var dropdownValueMonth = '11';
  var selectFlat;

  DateTime currentDate = DateTime.now();
  String userId = 'guest';
  String tenantId = 'guest';

  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  String listingDetailsId = 'guest';
  String? availFrom;
  DateTime availFromDate = DateTime.now();

  //final dbFavItem = DbHelper.instance;
  SinglePropertyDetailsController singlePropertyDetailsController = Get.put(SinglePropertyDetailsController());
  PropertyModel? singleProPerty;

  @override
  void initState() {
    //fetchSingleProperties(widget.propertyId);
    super.initState();
  }

  void fetchSingleProperties(String id) async {
    String url = '${AppUrls.listingDetail}?id=$id';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
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

  void addToFavItem(PropertyModel propertyModel) async {
    FavModel favModel = FavModel(
        id: 0,
        proID: propertyModel.id,
        ownerId: propertyModel.ownerId,
        userId: GetStorage().read(Constants.userId).toString(),
        relationShip: 'NA',
        name: propertyModel.name,
        type: propertyModel.type,
        plots: propertyModel.plots,
        floor: propertyModel.floor,
        facility: propertyModel.facility,
        amenities: 'NA',
        address: propertyModel.address,
        area: propertyModel.area,
        city: propertyModel.city,
        latlng: propertyModel.latlng,
        photo: 'NA',
        video: propertyModel.video,
        description: propertyModel.description,
        price: propertyModel.price,
        ownerPhone: propertyModel.ownerPhone,
        images: [],
        amenitiesList: [],
        createdOn: propertyModel.createdOn);
    /*   if (!await dbFavItem.isInFav(
        GetStorage().read(Constants.userId).toString(),
        propertyModel.id.toString())) {
      propertyModel.isFav = true;
     // await dbFavItem.insertFav(favModel);
      showSnackBar(context, 'Successfully added to favorites');
    } else {
      propertyModel.isFav = false;
    //  await dbFavItem.deleteFav(propertyModel.id, userId);
      showSnackBar(context, 'Successfully removed to favorites');
    }
    setState(() {});
    */
  }

  fetchPropertyDetails(PropertyModel model) async {
    if (mounted) {
      /* FavModel? favData = await dbFavItem.getFavItem(
          model.id, GetStorage().read(Constants.userId).toString());*/
      /*  if (favData != null) {
        model.isFav = true;
      } else {
        model.isFav = false;
      }*/
      if (model.availFrom != 'null') {
        availFrom = model.availFrom;
        availFromDate = DateTime.parse(model.availFrom);
      }
      listingDetailsId = model.id.toString();
    }
  }

  fetchUser(PropertyModel model) async {
    if (GetStorage().read(Constants.userId).toString() != 'guest') {
      userId = GetStorage().read(Constants.userId).toString();
      tenantId = GetStorage().read(Constants.tenantId).toString();
    } else {
      GetStorage().write(Constants.userId, 'guest');
      GetStorage().write(Constants.tenantId, 'guest');
      GetStorage().write(Constants.isLogin, false);
      GetStorage().write(Constants.isTenant, false);
      GetStorage().write(Constants.isAgree, false);
    }
    markers = {
      Marker(
        markerId: MarkerId(model.name),
        infoWindow: InfoWindow(title: model.address),
        position: model.latlng == 'undefined,undefined'
            ? const LatLng(0.0, 0.0)
            : LatLng(double.parse(model.latlng.split(',')[0]), double.parse(model.latlng.split(',')[1])),
      ),
    };
  }

  Widget _imageView(String image) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: imgLoadWid(image, 'assets/images/user_vec.png', 320, screenWidth, BoxFit.cover),
      ),
    );
  }

  Widget containerBtn(String title) {
    return GestureDetector(
      onTap: () {
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
                fontFamily: Constants.fontsFamily, color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
                  fontSize: 12, fontFamily: Constants.fontsFamily, color: Colors.white, fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '/',
                  style: TextStyle(fontSize: 12, fontFamily: Constants.fontsFamily, color: Colors.white),
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
          style: TextStyle(color: Constants.textColor, fontSize: 13, fontWeight: FontWeight.normal),
        ),
        height(0.005),
        Text(
          subTitle,
          style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
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
              fontFamily: Constants.fontsFamily, fontSize: 13, color: const Color.fromARGB(255, 110, 109, 109)),
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
                builder: (BuildContext context, setState) => SingleChildScrollView(
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
                          padding: const EdgeInsets.all(3),
                          margin: contEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Constants.lightBg,
                            border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                          ),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            isExpanded: true,
                            hint: Text(
                              'Select Guest',
                              style: TextStyle(
                                  color: Constants.getColorFromHex('CDCDCD'), fontFamily: Constants.fontsFamily),
                            ),
                            iconEnabledColor: Constants.getColorFromHex('CDCDCD'),
                            items: guestList.map((item) {
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
                              setState(() => dropdownValueGuest = newVal);
                            },
                            value: dropdownValueGuest,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: contEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Constants.lightBg,
                            border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                          ),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            isExpanded: true,
                            hint: Text(
                              'Select Months',
                              style: TextStyle(
                                  color: Constants.getColorFromHex('CDCDCD'), fontFamily: Constants.fontsFamily),
                            ),
                            iconEnabledColor: Constants.getColorFromHex('CDCDCD'),
                            items: monthList.map((item) {
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
                              setState(() => dropdownValueMonth = newVal.toString());
                            },
                            value: dropdownValueMonth,
                          ),
                        ),
                        title('Select Date', 15),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(7)),
                            color: Constants.lightBg,
                          ),
                          margin: contEdge,
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () async {
                              if (availFrom != null) {
                                DateTime newDate = availFromDate.add(const Duration(days: 7));
                                await showDatePicker(
                                  context: context,
                                  initialDate: currentDate,
                                  firstDate: availFromDate,
                                  lastDate: newDate,
                                ).then((pickedDate) {
                                  if (pickedDate != null && pickedDate != currentDate) {
                                    setState(() => currentDate = pickedDate);
                                  }
                                });
                              } else {
                                await showDatePicker(
                                  context: context,
                                  initialDate: currentDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 0)),
                                  lastDate: DateTime(2100),
                                ).then((pickedDate) {
                                  if (pickedDate != null && pickedDate != currentDate) {
                                    setState(() => currentDate = pickedDate);
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: getCustomText(DateFormat.yMMMd().format(currentDate), Constants.primaryColor,
                                      1, TextAlign.start, FontWeight.w400, 15),
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
                            if (userId == 'null' || userId == 'guest') {
                              RIEWidgets.getToast(
                                  message: 'You are not ${AppUrls.appName} user. Please Login/Register',
                                  color: CustomTheme.white);
                            } else if (dropdownValueGuest == null ||
                                dropdownValueGuest == 'null' ||
                                dropdownValueGuest.isEmpty) {
                              RIEWidgets.getToast(message: 'Select valid month', color: CustomTheme.white);
                            } else if (dropdownValueMonth.isEmpty) {
                              RIEWidgets.getToast(message: 'Select valid month', color: CustomTheme.white);
                            } else {
                              if (int.parse(dropdownValueGuest.toString()) > 1) {
                                alertDialog(context, 'Booking Alert',
                                    'Valid ID /KYC should be provided at the time on check in', from);
                              } else {
                                submitReqBooking(from);
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
        "${AppUrls.checkout}?checkin=${f.format(currentDate)}&duration=$dropdownValueMonth&guest=$dropdownValueGuest&listingId=$listingDetailsId";
    dynamic result = await getCheckOut(url, GetStorage().read(Constants.token).toString());
    debugPrint("result");
    debugPrint(result.toString());
    bool success = result["success"];
    /*  if (success) {
      bool isBack = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CheckOutPage(
                    from: from,
                    currentDate: currentDate,
                    propertyModel: singleProPerty!,
                    checkoutModel: CheckoutModel.fromJson(result['data']),
                  )));
      if (isBack) {
        setState(() => loadingLeads = false);
        Navigator.pop(context);
      }
    } else {
      setState(() => loadingLeads = false);
    }*/
  }

  Future<void> alertDialog(BuildContext context, String title, String subttitle, String from) {
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
                  submitReqBooking(from);
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

  void issuesRequest(PropertyModel model) async {
    try {
      dynamic result = await createIssuesApi(
        GetStorage().read(Constants.userId).toString(),
        model.id,
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
    return Scaffold(
      body: singlePropertyDetailsController.singlePage.value
          ? SizedBox(
              height: screenHeight,
              width: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
                  title(singlePropertyDetailsController.proFetch.value, 14)
                ],
              ))
          : Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 320,
                  child: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(0),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 320,
                            child: singleProPerty!.images.length > 1
                                ? ScrollPageView(
                                    controller: ScrollPageController(),
                                    delay: const Duration(seconds: 4),
                                    indicatorAlign: Alignment.bottomLeft,
                                    indicatorPadding:
                                        EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.10, left: 5),
                                    indicatorWidgetBuilder: _indicatorBuilder,
                                    children: singleProPerty!.images.map((image) => _imageView(image)).toList(),
                                  )
                                : _imageView(singleProPerty!.images.first),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                            color: Colors.white,
                            border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Text(Constants.currency,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontFamily: Constants.fontsFamily,
                                                        fontWeight: FontWeight.normal)),
                                              ),
                                              WidgetSpan(
                                                child: Text('.${singleProPerty!.price}',
                                                    style: TextStyle(
                                                        fontFamily: Constants.fontsFamily,
                                                        color: Constants.black,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("Per Month",
                                            style: TextStyle(
                                                fontFamily: Constants.fontsFamily,
                                                color: Constants.primaryColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal))
                                      ],
                                    ),
                                    width(0.05),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      height: 20,
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    width(0.05),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        '${singleProPerty!.plots} Plots',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontFamily: Constants.fontsFamily,
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 3),
                                                child: iconWidget('location', 13, 13),
                                              ),
                                              SizedBox(
                                                width: 180,
                                                child: Text(singleProPerty!.address,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontFamily: Constants.fontsFamily,
                                                        color: Constants.textColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.normal)),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        width: 120,
                                        height: 40,
                                        child: ElevatedButton.icon(
                                            onPressed: () {
                                              openDialPad(singleProPerty!.ownerPhone, context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Constants.primaryColor,
                                            ),
                                            icon: iconWidget('phone', 30, 30),
                                            label: Text(
                                              'Contact',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: Constants.fontsFamily,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                height(0.005),
                                sTitle('Property Details', 18, FontWeight.w500),
                                height(0.005),
                                Text(
                                  singleProPerty!.name,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 150, child: columnTxt('BHK', singleProPerty!.bhkType)),
                                    SizedBox(width: 150, child: columnTxt('Floor', singleProPerty!.floor))
                                  ],
                                ),
                                height(0.005),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 150, child: columnTxt('Flat Type', singleProPerty!.type)),
                                    SizedBox(
                                        width: 150, child: columnTxt('Covered Area', '${singleProPerty!.area} Sqft'))
                                  ],
                                ),
                                height(0.005),
                                columnTxt('City', singleProPerty!.city),
                                height(0.005),
                                sTitle('Description :', 18, FontWeight.w500),
                                width(0.005),
                                Text(
                                  singleProPerty!.description,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: Constants.fontsFamily,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                height(0.005),
                                sTitle('Amenities', 18, FontWeight.w500),
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
                                sTitle('Have a question?', 18, FontWeight.w500),
                                width(0.005),
                                const Text(
                                  'Get a quick answer right here',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                height(0.005),
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                    border: Border.all(color: const Color.fromARGB(255, 214, 212, 212)),
                                  ),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: askQController,
                                            decoration: InputDecoration(
                                                hoverColor: Constants.hint, hintText: '', border: InputBorder.none),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (askQController.text.isEmpty) {
                                              showSnackBar(context, 'Enter valid Question');
                                            } else {
                                              issuesRequest(singleProPerty!);
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: Constants.primaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Ask now',
                                                style: TextStyle(
                                                    fontFamily: Constants.fontsFamily,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
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
                                    physics: const BouncingScrollPhysics(),
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
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GoogleMap(
                                      markers: markers,
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                          target: singleProPerty!.latlng == 'undefined,undefined'
                                              ? const LatLng(0.0, 0.0)
                                              : LatLng(double.parse(singleProPerty!.latlng.split(',')[0]),
                                                  double.parse(singleProPerty!.latlng.split(',')[1])),
                                          zoom: 13.0,
                                          tilt: 0,
                                          bearing: 0),
                                      onMapCreated: (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      }),
                                ),
                                height(0.009),
                              ]),
                        ),
                      ),
                    )),
                Positioned(
                    right: 15,
                    top: MediaQuery.of(context).size.height * 0.05,
                    child: circleContainer(
                        IconButton(
                            onPressed: () async {
                              if (listingDetailsId.isNotEmpty) {
                                dynamic result = await addToFav(listingDetailsId);
                                if (result['message'].toString() == 'Success') {
                                  addToFavItem(singleProPerty!);
                                }
                              }
                            },
                            icon: Icon(
                              singleProPerty!.isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 18,
                              color: singleProPerty!.isFav ? Colors.red : Colors.black,
                            )),
                        Colors.white,
                        100,
                        35,
                        35)),
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
                    visible: availFrom != null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Expanded(flex: 1, child: containerBtn('Request')),
                          Expanded(flex: 1, child: containerBtn('Book Now')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
