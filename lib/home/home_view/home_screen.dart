// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/home/home_controller/home_controller.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/model/tenant_model.dart';
import 'package:rentitezy/model/ticketModel.dart';
import 'package:rentitezy/pdf/pdf_api.dart';
import 'package:rentitezy/pdf/pdf_new.dart';
import 'package:rentitezy/login/view/login_screen.dart';
import 'package:rentitezy/screen/profile_screen_new.dart';
import 'package:rentitezy/screen/terms_conditions.dart/terms_and_condition.dart';
import 'package:rentitezy/widgets/app_bar.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/localDb/db_helper.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:rentitezy/screen/rent_remain_screen.dart';
import 'package:rentitezy/screen/update_profile.dart';
import 'package:rentitezy/widgets/near_by_items.dart';
import 'package:rentitezy/widgets/recommend_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../fav/my_fav_screen.dart';
import '../../my_bookings/my_booking_controller.dart';
import '../../my_bookings/my_booking_screen.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/const/widgets.dart';
import '../../utils/view/rie_widgets.dart';
import '../../screen/faq_screen.dart';
import '../../screen/search/all_properties_page.dart';
import '../../screen/terms_conditions.dart/policy_data.dart';
import '../model/property_list_nodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget navWidget = const SizedBox();
  String userId = 'guest';
  String userName = '';
  final dbFavItem = DbHelper.instance;
  bool isTenant = false;
  late Future<List<TicketModel>> futureTicketReq;
  String tenantId = '';
  var othersController = TextEditingController();
  var commentController = TextEditingController();
  TenantModel? tenantDet;
  final homeApiController = Get.put(HomeController());
  final bookingController = Get.put(MyBookingController());

  @override
  void initState() {
    isTenant = GetStorage().read(Constants.isTenant);
    userName =  GetStorage().read(Constants.usernamekey);
    userId = GetStorage().read(Constants.userId)??"guest";
    checkNavPos();
    bookingController.onInit();
    futureTicketReq = fetchTicketReqApi();
    super.initState();
  }


  Widget buildTabBar() {
    return Obx(() => homeApiController.isLoadingLocation.value
        ? Center(child: RIEWidgets.getLoader())
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: homeApiController.categories.length,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                  onTap: () {
                    homeApiController.selectedIndex.value = i;
                    homeApiController
                        .locationFunc(homeApiController.categories[i]);
                  },
                  child: Obx(
                    () => AnimatedContainer(
                        margin: EdgeInsets.fromLTRB(i == 0 ? 15 : 5, 0, 5, 0),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                              i == homeApiController.selectedIndex.value
                                  ? 18
                                  : 15)),
                          color: i == homeApiController.selectedIndex.value
                              ? Constants.primaryColor
                              : Colors.grey[200],
                        ),
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          child: Text(
                            homeApiController.categories[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: i == homeApiController.selectedIndex.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        )),
                  ));
            }));
  }

  Widget nearProperties(PropertySingleData? property) {
    return NearByItem(
      propertyModel: property,
    );
  }

  void goToProfile() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProfileScreenNew()));
  }

  Future<List<TicketModel>> fetchTicketReqApi() async {
    try {

      if (GetStorage().read(Constants.isTenant)!= false) {
        tenantId = GetStorage().read(Constants.userId).toString();
        var list = getAllTicketReq(tenantId);
        futureTicketReq = Future.value(list);
        setState(() {});
        return list;
      } else {

        setState(() {});
        return [];
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
    return [];
  }

//ticket list
  Widget fetchMyTicketReq() {
    return FutureBuilder<List<TicketModel>>(
        future: futureTicketReq,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return RIEWidgets.getLoader();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return listTicketReq(snapshot.data!);
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {
                futureTicketReq = fetchTicketReqApi();
              }));
            }
          }

          return RIEWidgets.getLoader();
        });
  }

  //ticket req Api
  Widget listTicketReq(List<TicketModel> faqModel) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          expandItemTicket(faqModel[index]),
      itemCount: faqModel.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  //ticket list widget
  Widget expandItemTicket(TicketModel faqModel) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            faqModel.ticket,
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            Text(
              faqModel.comments,
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            Text(
              faqModel.resolved,
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
            Text(
              convertToAgo(faqModel.createdOn),
              style: TextStyle(fontFamily: Constants.fontsFamily),
            )
          ],
        ),
      ),
    );
  }

  void ticketRequest(String ticketTxt) async {
    if (bookingController.myBookingData.isNotEmpty) {
      var item = bookingController.myBookingData.first;

      try {
        if (GetStorage().read(Constants.isTenant).toString().isNotEmpty ) {
          dynamic result = await createTicketApi(
              GetStorage().read(Constants.tenantId).toString(),
              ticketTxt,
              commentController.text,
              '${item.propUnit?.flatNo}',
              '${item.id}');
          if (result['success']) {
            futureTicketReq = fetchTicketReqApi();
            othersController.value = const TextEditingValue(text: '');
            commentController.value = const TextEditingValue(text: '');
            showSnackBar(context, result['message']);
            Navigator.pop(context);
          } else {
            showSnackBar(context, result['message']);
          }
        } else {
          showSnackBar(context, 'You are not tenant');
        }
      } on Exception catch (error) {
        Navigator.pop(context);
        showSnackBar(context, error.toString());
      }
    } else {
      showSnackBar(context, 'Property not found');
    }
  }

  List<String> ticketList = [
    'Plumbing',
    'Electrical',
    'General Maintenance',
    'Emergency',
    'Water',
    'Sanitary',
    'Others'
  ];
  String selectedTicket = 'Plumbing';

  void showBottomTickets() {
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
                                'Create your Ticket',
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
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: ticketList
                                    .map(
                                      (temp) => RadioListTile(
                                        contentPadding: const EdgeInsets.all(0),
                                        value: temp,
                                        groupValue: selectedTicket,
                                        selected: temp == selectedTicket,
                                        onChanged: (value) {
                                          setState(
                                            () => selectedTicket =
                                                value.toString(),
                                          );
                                        },
                                        title: Text(
                                          temp,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: Constants.fontsFamily,
                                              fontSize: 15),
                                        ),
                                        activeColor: Constants.primaryColor,
                                      ),
                                    )
                                    .toList()),
                            const SizedBox(height: 10),
                            selectedTicket == 'Others'
                                ? Container(
                                    padding: const EdgeInsets.all(3),
                                    margin: contEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Constants.getColorFromHex(
                                              'EAE7E7')),
                                    ),
                                    child: TextField(
                                      controller: othersController,
                                      style: TextStyle(
                                          fontFamily: Constants.fontsFamily),
                                      decoration: InputDecoration(
                                          hoverColor: Constants.getColorFromHex(
                                              'CDCDCD'),
                                          hintText: '*Your Problem',
                                          hintStyle: TextStyle(
                                              color: Constants.getColorFromHex(
                                                  'CDCDCD'),
                                              fontFamily:
                                                  Constants.fontsFamily),
                                          border: InputBorder.none),
                                    ),
                                  )
                                : height(0),
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
                              child: TextField(
                                controller: commentController,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    hoverColor: Constants.hint,
                                    hintText: '*Your comments',
                                    border: InputBorder.none),
                              ),
                            ),
                            height(0.05),
                            GestureDetector(
                              onTap: () {
                                if (selectedTicket == 'Others') {
                                  if (othersController.text.isEmpty) {
                                    RIEWidgets.showSnackbar(
                                      context: context,
                                      message: 'Enter valid Ticket',
                                      color: CustomTheme.white,
                                    );
                                  } else if (commentController.text.isEmpty) {
                                    RIEWidgets.showSnackbar(
                                      context: context,
                                      message: 'Enter valid Comment',
                                      color: CustomTheme.white,
                                    );
                                  } else {
                                    ticketRequest(othersController.text);
                                  }
                                } else {
                                  if (commentController.text.isEmpty) {
                                    RIEWidgets.showSnackbar(
                                      context: context,
                                      message: 'Enter valid Comment',
                                      color: CustomTheme.white,
                                    );
                                  } else {
                                    ticketRequest(selectedTicket);
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
                            height(0.05),
                          ],
                        ))),
          );
        });
  }

  Widget profileData(String title, String image) {
    return appBarWidget(
      title,
      image,
      () {
        goToProfile();
      },
    );
  }

  void checkNavPos() async {
    if (selectNavPos == 3) {
      navWidget = ListView(
        shrinkWrap: true,
        padding:
            const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 75),
        children: [
          /*  GetStorage().read(Constants.userId).toString() != 'guest'
              ? FutureBuilder<dynamic>(
                  future: fetchTenantUserApi(
                      '${AppUrls.getUser}?id=${GetStorage().read(Constants.userId).toString()}'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!['success']) {
                        return
                            // snapshot.data!['isTenant'] == 'true'
                            //     ? profileData(
                            //         TenantModel.fromJson(
                            //                 snapshot.data!['tenantDet'])
                            //             .name,
                            //         TenantModel.fromJson(
                            //                 snapshot.data!['tenantDet'])
                            //             .photo)
                            //     :
                            profileData(
                                UserModel.fromJson(snapshot.data!["data"][0])
                                    .firstName,
                                UserModel.fromJson(snapshot.data!["data"][0])
                                    .image);
                      } else {
                        GetStorage().write(Constants.userId, 'guest');
                        GetStorage().write(Constants.auth_key, 'guest');
                        GetStorage().write(Constants.token, 'guest');
                        return profileData('Guest', '');
                      }
                    } else if (snapshot.hasError) {
                      return profileData('Guest', '');
                    }
                    return RIEWidgets.getLoader();
                  })
              :*/
          profileData(GetStorage().read(Constants.usernamekey).toString(),
              GetStorage().read(Constants.profileUrl).toString()),
          searchWidget(),
          height(0.015),
          SizedBox(height: 45, width: screenWidth, child: buildTabBar()),
          height(0.015),
          title("Near by Properties", 18),
          height(0.015),
          buildOnGoingList(),
          height(0.015),
          title("Recommended", 18),
          Obx(
            () => homeApiController.isLoading.value
                ? Center(child: RIEWidgets.getLoader())
                : Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            homeApiController.allPropertyData?.data?.length,
                        itemBuilder: (context, index) {
                          return recommendWidget(
                              homeApiController.allPropertyData?.data![0]);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextButton(
                            onPressed: () {
                              homeApiController.scrollListener(false);
                            },
                            child: Text(
                              'LOAD MORE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: Constants.fontsFamily,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
          ),
        ],
      );
    } else if (selectNavPos == 4) {
      navWidget = Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 50, left: 10, right: 10, bottom: 75),
              children: [
                GetStorage().read(Constants.userId).toString() != 'guest'
                    ? FutureBuilder<dynamic>(
                        future: fetchTenantUserApi(
                            '${AppUrls.getUser}?id=${GetStorage().read(Constants.userId).toString()}'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!['success']) {
                              return
                                  // snapshot.data!['isTenant'] == 'true'
                                  //     ? profileData(
                                  //         TenantModel.fromJson(
                                  //                 snapshot.data!['tenantDet'])
                                  //             .name,
                                  //         TenantModel.fromJson(
                                  //                 snapshot.data!['tenantDet'])
                                  //             .photo)
                                  //     :
                                  profileData(
                                      UserModel.fromJson(
                                              snapshot.data!["data"][0])
                                          .firstName,
                                      UserModel.fromJson(
                                              snapshot.data!["data"][0])
                                          .image);
                            } else {
                              GetStorage().write(Constants.userId, 'guest');
                              GetStorage().write(Constants.auth_key, 'guest');
                              GetStorage().write(Constants.token, 'guest');
                              return profileData('Guest', '');
                            }
                          } else if (snapshot.hasError) {
                            return profileData('Guest', '');
                          }
                          return RIEWidgets.getLoader();
                        })
                    : profileData('Guest', ''),
                Visibility(visible: isTenant, child: fetchMyTicketReq()),
                Visibility(
                    visible: !isTenant,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    )),
                Visibility(
                  visible: !isTenant,
                  child: Center(
                    child: Text(
                      'Your are not Tenant',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: Constants.fontsFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isTenant,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                selectNavPos = 3;
                                checkNavPos();
                                setState(() {});
                              },
                              child: Text(
                                'Back to Home',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: Constants.fontsFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            right: 0,
            child: Visibility(
              visible: isTenant,
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    width(0.005),
                    Text(
                      'Raise your ticket',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          showBottomTickets();
                        },
                        icon: const Icon(
                          Icons.add_circle_outline_outlined,
                          size: 26,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      );
    }
    setState(() {});
  }

  showInvoice(AgreementDet agreementDet, String tenantName) async {
    agreementDet.between = tenantName;
    final pdfFile = await PdfInvoice.generate(agreementDet);
    PdfApi.openFile(pdfFile);
  }

  //drawer
  Widget drawer() {
    return Drawer(
      width: 240,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(100), bottomRight: Radius.circular(100)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Column(
                children: [
                  imgLoadWid(GetStorage().read(Constants.profileUrl), 'assets/images/user_vec.png', 70, 70,
                      BoxFit.contain),
                  height(0.015),
                  Text(
                    userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: Constants.fontsFamily,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ) //UserAccountDrawerHeader
              ), //DrawerHeaderRS
          ListTile(
            leading: iconWidget('profile_edit', 30, 30),
            trailing: arrowBack(),
            title: Text(' Profile Edit ',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfilePage()));
            },
          ),
          // ListTile(
          //   leading: iconWidget('household', 30, 30),
          //   trailing: arrowBack(),
          //   title: Text(' Household ',
          //       style: TextStyle(
          //         fontFamily: Constants.fontsFamily,
          //       )),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => HouseholdPage()));
          //   },
          // ),

          // ListTile(
          //   leading: iconWidget('requests', 26, 26),
          //   trailing: arrowBack(),
          //   title: Text(' Our Requests ',
          //       style: TextStyle(
          //         fontFamily: Constants.fontsFamily,
          //       )),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const RequestScreen()));
          //   },
          // ),

          ListTile(
            leading: iconWidget('shopping_bag', 26, 26),
            trailing: arrowBack(),
            title: Text('My Bookings ',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () {
              Get.to(MyBookingsScreen(
                from: false,
              ));
            },
          ),
          ListTile(
            leading: iconWidget('help', 26, 26),
            trailing: arrowBack(),
            title: Text(' Faq ',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FaqScreen()));
            },
          ),

          Visibility(
            visible: isTenant,
            child: ListTile(
                leading: iconWidget('agreement', 30, 30),
                trailing: arrowBack(),
                title: Text(' Agreement ',
                    style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                    )),
                onTap: () {
                  showInvoice(tempPdf, userName);
                }),
          ),
          ListTile(
            leading: iconWidget('privacy_policy', 30, 30),
            trailing: arrowBack(),
            title: Text(' Privacy Policy',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(
                            title: 'Privacy And Policy',
                            data: privacyPolicy,
                          )));
            },
          ),
          ListTile(
            leading: iconWidget('about_us', 30, 30),
            trailing: arrowBack(),
            title: Text(' Terms & Conditions ',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(
                            title: 'Terms & Conditions',
                            data: termsPolicy,
                          )));
            },
          ),
          ListTile(
            leading: iconWidget('about_us', 30, 30),
            trailing: arrowBack(),
            title: Text(' Cancellation Policy ',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(
                            title: 'Cancellation Policy',
                            data: cancelPolicy,
                          )));
            },
          ),
          ListTile(
            trailing: arrowBack(),
            leading: Icon(
              (userId.isNotEmpty || userId != 'null' || userId != 'guest')
                  ? Icons.logout_rounded
                  : Icons.login_rounded,
              color: Colors.black,
            ),
            title: Text(
                (userId.isNotEmpty || userId != 'null' || userId != 'guest')
                    ? 'Logout'
                    : 'Login',
                style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                )),
            onTap: () {
              if ((userId.isNotEmpty ||
                  userId != 'null' ||
                  userId != 'guest')) {
                alertDialog(context, 'LOG OUT', '* Do you want Logout *');
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Constants.lightSearch,
          borderRadius: BorderRadius.circular(30)),
      child: ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AllPropertiesPage()));
        },
        leading: const Icon(Icons.search),
        title: const TextField(
          enabled: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by property name',
          ),
        ),
        horizontalTitleGap: 0,
      ),
    );
  }

  Widget buildOnGoingList() {
    return SizedBox(
        height: screenHeight * 0.30,
        child: Obx(
          () => homeApiController.isLoadingLocation.value
              ? RIEWidgets.getLoader()
              : ListView.builder(
                  shrinkWrap: false,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: homeApiController.allPropertyData != null &&
                          homeApiController.allPropertyData?.data != null
                      ? homeApiController.allPropertyData!.data!.length > 5
                          ? 3
                          : homeApiController.allPropertyData?.data?.length
                      : 0,
                  itemBuilder: (context, index) {
                    return nearProperties(
                        homeApiController.allPropertyData?.data![index]);
                  },
                ),
        ));
  }

  Widget recommendWidget(PropertySingleData? property) {
    return RecommendItem(
      propertyModel: property,
    );
  }

  int selectNavPos = 3;
  List<NavItems> languages = [
    const NavItems('account', 1, Icons.manage_accounts),
    const NavItems('favourite', 2, Icons.favorite),
    const NavItems('home', 3, Icons.home),
    const NavItems('message', 4, Icons.chat),
    const NavItems('notification', 5, Icons.notifications)
  ];

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

  Widget navItems(
    NavItems items,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      height: 50,
      width: 50,
      decoration: selectNavPos == items.id
          ? BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20))
          : null,
      child: IconButton(
        onPressed: () async {
          selectNavPos = items.id;
          checkNavPos();
          if (items.id == 1) {
            selectNavPos = 3;
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else {
              checkNavPos();
              scaffoldKey.currentState!.openDrawer();
            }
          } else if (items.id == 2) {
            try {
              /* bool value = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavScreen()),
              );*/
              Get.to(FavScreen());
              /*  if (value) {
                selectNavPos = 3;
                checkNavPos();
              }*/
            } catch (e) {
              debugPrint(e.toString());
            }
          } else if (items.id == 5) {
            //Get.to( const RentRemainScreen());
            if (isTenant) {
               Get.to( const RentRemainScreen());

            } else {
              selectNavPos = 3;
              checkNavPos();
              showSnackBar(context, 'You are not Rentiseasy Tenant');
            }
          }
        },
        icon: iconWidget(items.name, selectNavPos == items.id ? 30 : 25,
            selectNavPos == items.id ? 30 : 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: drawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Stack(
              children: [
                Positioned(child: navWidget),
                Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Constants.navBg,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: languages
                              .map((e) => navItems(
                                    e,
                                  ))
                              .toList()),
                    )),
              ],
            ),
          ),
        ));
  }
}

class NavItems {
  final String name;
  final int id;
  final IconData iconData;

  const NavItems(this.name, this.id, this.iconData);
}

class AgreementDet {
  String title;
  String executedOn;
  String between;
  String sof;
  String about;
  String residingAt;
  String representative;
  String firstParty;
  String propertyLocated;
  String commencingFrom;
  String commencingEnding;
  String licenseAmount;
  String totalAdvance;
  String deducting;
  String licenseCharged;
  String notice1;
  String notice2;
  String premisesBearing;
  String consisting;

  AgreementDet(
      this.title,
      this.executedOn,
      this.between,
      this.sof,
      this.about,
      this.residingAt,
      this.representative,
      this.firstParty,
      this.propertyLocated,
      this.commencingFrom,
      this.commencingEnding,
      this.licenseAmount,
      this.totalAdvance,
      this.deducting,
      this.licenseCharged,
      this.notice1,
      this.notice2,
      this.premisesBearing,
      this.consisting);
}
