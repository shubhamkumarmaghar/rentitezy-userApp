// ignore_for_file: use_build_context_synchronously

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/tenant_model.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:rentitezy/web_view/webview.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../my_bookings/controller/my_booking_controller.dart';
import '../utils/const/app_urls.dart';
import '../utils/const/widgets.dart';
import 'faq_screen.dart';


class ProfileScreenNew extends StatefulWidget {
  const ProfileScreenNew({super.key});

  @override
  State<ProfileScreenNew> createState() => _MyProfileState();
}

class _MyProfileState extends State<ProfileScreenNew> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TextEditingController askQController = TextEditingController();
  TenantModel? tenantModel;
  final bookingController = Get.put(MyBookingController());

  bool isTenant = false;
  String userId = GetStorage().read(Constants.userId);
  String userName = GetStorage().read(Constants.usernamekey);
  String userEmail = GetStorage().read(Constants.emailkey);
  String userPhone = GetStorage().read(Constants.phonekey);
  String vendorId = GetStorage().read(Constants.userId);
  String profileImg = GetStorage().read(Constants.profileUrl);

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    fetchLocal();
    _initPackageInfo();
    super.initState();
  }

  Widget infoTile(String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Constants.textColor),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  Widget rowText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.black,
                fontSize: 13),
          ),
          Text(
            value,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.grey,
                fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget circleIcon(String text, Color color, String url) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GFButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewPage(
                        title: text,
                        uri: url,
                      )));
        },
        text: text,
        color: color,
        type: GFButtonType.outline,
      ),
    );
  }

  Widget columnVersionText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Version",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey),
        ),
        height(0.001),
        infoTile(packageInfo.version),
      ],
    );
  }

  void fetchLocal() async {
    SharedPreferences sharedPreferences = await prefs;
    if (GetStorage().read(Constants.userId) != null) {
      dynamic result = await fetchTenantUserApi(
          '${AppUrls.getUser}?id=${GetStorage().read(Constants.userId).toString()}');
      if (result["success"]) {
        UserModel userModel = UserModel.fromJson(result["data"][0]);
        GetStorage().write(Constants.userId, userModel.id);
        userId = userModel.id.toString();
        if (GetStorage().read(Constants.isTenant)!) {
          vendorId = userModel.id.toString();
          GetStorage().write(
              Constants.tenantId, userModel.id.toString());
          isTenant = true;
        }
        // if (result['isTenant']) {
        //   GetStorage().write(Constants.isTenant, true);
        // TenantModel tempTenant = TenantModel.fromJson(result['tenantDet']);
        // GetStorage().write(Constants.tenantId, userModel.id);
        GetStorage().write(Constants.usernamekey,
            '${userModel.firstName} ${userModel.lastName}');
        GetStorage().write(Constants.phonekey, userModel.phone);
        // GetStorage().write(Constants.emailkey, tempTenant.email);
        // GetStorage().write(Constants.profileUrl, tempTenant.photo);
        userName = '${userModel.firstName} ${userModel.lastName}';
        userEmail = userModel.email;
        userPhone = userModel.phone;
        profileImg = userModel.image;
        // isTenant = true;
        // vendorId = userModel.id.toString();
        // GetStorage().write(Constants.isTenant, true);
        // isTenant = true;
        // if (tempTenant.isAgree == 'true') {
        //   GetStorage().write(Constants.isAgree, true);
        // } else {
        //   GetStorage().write(Constants.isAgree, false);
        // }
        // } else {
        // isTenant = false;
        // vendorId = 'guest';
        // userId = userModel.id.toString();
        // userName = userModel.firstName;
        // userEmail = userModel.email;
        // userPhone = userModel.phone;
        // profileImg = userModel.image;
        // GetStorage().write(Constants.usernamekey, userModel.firstName);
        // GetStorage().write(Constants.phonekey, userModel.phone);
        GetStorage().write(Constants.emailkey, userModel.email);
        GetStorage().write(Constants.profileUrl, userModel.image);
        // userId = userModel.id.toString();
        // userName = userModel.firstName;
        //}
      } else {
        isTenant = false;
        userId = 'guest';
        userName = 'guest';
        GetStorage().write(Constants.tenantId, 'guest');
        GetStorage().write(Constants.isTenant, false);
        GetStorage().write(Constants.isAgree, false);
      }
    } else {
      isTenant = false;
      userId = 'guest';
      userName = 'guest';
      GetStorage().write(Constants.tenantId, 'guest');
      GetStorage().write(Constants.isTenant, false);
      GetStorage().write(Constants.isAgree, false);
    }
    setState(() {});
  }

  Widget expandItemFaq(String image, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget(image, 30, 30),
          width(0.1),
          Expanded(
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: Constants.fontsFamily, fontSize: 16),
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                if (image == 'faq') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FaqScreen()));
                } else {
                  deleteAlertDialog(context, 'Delete your Account',
                      '* Do you want Delete Rentiseazy Account*');
                }
              },
              icon: const Icon(
                Icons.arrow_right_rounded,
                size: 30,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  Future<void> deleteAlertDialog(
      BuildContext context, String title, String subttitle) {
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
                  SharedPreferences sharedPreferences = await prefs;
                  dynamic result = await deleteUser(
                      GetStorage().read(Constants.userId).toString());
                  if (result['success']) {
                    executeLogOut(context);
                  }
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

  Widget expandItemWeb(String image, String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget(image, 30, 30),
          width(0.1),
          Text(
            title,
            style: TextStyle(fontFamily: Constants.fontsFamily, fontSize: 16),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewPage(
                              title: title,
                              uri: subTitle,
                            )));
              },
              icon: const Icon(
                Icons.arrow_right_rounded,
                size: 30,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  Widget expandItemFollowUs(String image, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: iconWidget(image, 30, 30),
          title: Text(
            title,
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circleIcon('Facebook', Colors.indigoAccent,
                    'https://www.facebook.com/people/Rentiseazy/100085212123196/'),
                circleIcon('Twitter', Colors.blue,
                    'https://twitter.com/i/flow/login?redirect_after_login=%2Frentiseazy'),
                circleIcon('Instagram', Colors.pink,
                    'https://www.instagram.com/rentiseazy/')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget listTileWid(String title) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.01),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 1,
        title: Text(
          title,
          style: TextStyle(
              fontFamily: Constants.fontsFamily,
              color: Colors.black,
              fontSize: 15),
        ),
        leading: IconButton(
            onPressed: () {
              openDialPad(title, context);
            },
            icon: Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 2, color: Constants.primaryColor)),
              child: Center(
                child: Icon(
                  Icons.call,
                  size: 15,
                  color: Constants.primaryColor,
                ),
              ),
            )),
      ),
    );
  }

  Widget expandItemContactUs(String image, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: iconWidget(image, 30, 30),
          title: Text(
            title,
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            listTileWid(
              '+918867319955',
            ),
            listTileWid(
              AppUrls.phone,
            ),
            listTileWid(
              '+918867319933',
            ),
          ],
        ),
      ),
    );
  }

  Widget tenantWidget(String image, String title) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bookingController.myBookingData.length,
          itemBuilder: (context, index) {
            var item = bookingController.myBookingData[index];
            // return expandItemRentNew(image, title, item);
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: iconWidget(image, 30, 30),
                  title: Text(
                    title,
                    style: TextStyle(fontFamily: Constants.fontsFamily),
                  ),
                  expandedAlignment: Alignment.topLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding: const EdgeInsets.all(5),
                  tilePadding: const EdgeInsets.all(5),
                  children: [
                    rowText('Property name',
                        '${item.propUnit?.listing?.property?.name}'),
                    rowText('Flat No', '${item.propUnit?.flatNo}'),
                    rowText(
                        'Monthly Rent', '${Constants.currency}.${item.rent}'),
                    rowText('Deposit Amount',
                        '${Constants.currency}.${item.deposit}'),
                    rowText('Guest', '${Constants.currency}.${item.guest}'),
                    rowText('House Type', '${item.propUnit?.listing?.listingType}'),
                    rowText('11 Months Rent',
                        '${Constants.currency}.${(double.parse(item.rent.toString()) * 11)}'),
                    // rowText('Pay Date', getFormatedDate(tenantModel.payDate)),
                    rowText('Pay Status (This month)',
                        '${item.invoices?.first.status.toUpperCase()}'),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget expandItemRent(String image, String title, TenantModel tenantModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: iconWidget(image, 30, 30),
          title: Text(
            title,
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            rowText('Property name', tenantModel.propertyModel!.name),
            rowText('House  Id', tenantModel.houseId),
            rowText('Monthly Rent',
                '${Constants.currency}.${tenantModel.rentalAmt}'),
            rowText('Advance Paid',
                '${Constants.currency}.${tenantModel.advancePaid}'),
            rowText('Remaining Rent',
                '${Constants.currency}.${tenantModel.remainingRent}'),
            rowText('Total Amount',
                '${Constants.currency}.${tenantModel.totalAmt}'),
            rowText('11 Months Rent',
                '${Constants.currency}.${(double.parse(tenantModel.rentalAmt) * 11)}'),
            rowText('House Type', tenantModel.bhkType),
            rowText('Pay Date', getFormatedDate(tenantModel.payDate)),
            rowText('Pay Status (This month)',
                tenantModel.payStatus.split('T')[0].toUpperCase()),
          ],
        ),
      ),
    );
  }

  // Widget expandItemRentNew(
  //     String image, String title, MyBookingModel tenantModel) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 10, right: 10),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //       child: ExpansionTile(
  //         leading: iconWidget(image, 30, 30),
  //         title: Text(
  //           title,
  //           style: TextStyle(fontFamily: Constants.fontsFamily),
  //         ),
  //         expandedAlignment: Alignment.topLeft,
  //         expandedCrossAxisAlignment: CrossAxisAlignment.start,
  //         childrenPadding: const EdgeInsets.all(5),
  //         tilePadding: const EdgeInsets.all(5),
  //         children: [
  //           rowText('Property name', tenantModel.propertyModel!.name),
  //           rowText('House  Id', tenantModel.houseId),
  //           rowText('Monthly Rent',
  //               '${Constants.currency}.${tenantModel.rentalAmt}'),
  //           rowText('Advance Paid',
  //               '${Constants.currency}.${tenantModel.advancePaid}'),
  //           rowText('Remaining Rent',
  //               '${Constants.currency}.${tenantModel.remainingRent}'),
  //           rowText('Total Amount',
  //               '${Constants.currency}.${tenantModel.totalAmt}'),
  //           rowText('11 Months Rent',
  //               '${Constants.currency}.${(double.parse(tenantModel.rentalAmt) * 11)}'),
  //           rowText('House Type', tenantModel.bhkType),
  //           rowText('Pay Date', getFormatedDate(tenantModel.payDate)),
  //           rowText('Pay Status (This month)',
  //               tenantModel.payStatus.split('T')[0].toUpperCase()),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget profileView() {
    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: FloatingActionButton(
                          heroTag: UniqueKey(),
                          backgroundColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                const SizedBox(
                                  height: 75,
                                  width: 75,
                                ),
                                imgLoadWid(
                                    profileImg.contains('https://')
                                        ? profileImg
                                        : AppUrls.imagesRentIsEasyUrl +
                                            profileImg,
                                    'assets/images/user_vec.png',
                                    75,
                                    75,
                                    BoxFit.contain),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Visibility(
                                    visible: isTenant,
                                    child: Icon(
                                      Icons.verified,
                                      size: 20.0,
                                      color: Constants.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            height(0.005),
                            Text(
                              userName,
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              'Phone :$userPhone',
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.black,
                                  fontSize: 13),
                            ),
                            Text(
                              'Email : $userEmail',
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: Colors.black,
                                  fontSize: 13),
                            ),
                            height(0.005),
                            Visibility(
                              visible: isTenant,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // color: Constants.lightSearch,
                                  border: Border.all(
                                    color: Constants.lightSearch,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  'TENANT',
                                  style: TextStyle(
                                      fontFamily: Constants.fontsFamily,
                                      color: Constants.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: FloatingActionButton(
                          heroTag: UniqueKey(),
                          backgroundColor: Colors.white,
                          onPressed: () {
                            alertDialog(
                                context, 'LOG OUT', '* Do you want Logout *');
                          },
                          child: const Icon(
                            Icons.exit_to_app_rounded,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.005),
                ]),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Positioned(
            top: 30,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(children: [
                      profileView(),
                      height(0.005),
                      Card(
                        child: Column(children: [
                          Visibility(
                              visible: isTenant &&
                                  (vendorId != 'null' || vendorId != 'guest'),
                              child: tenantWidget('rent', 'Rent Details')),
                          Visibility(visible: isTenant, child: const Divider()),
                          expandItemContactUs('contact_us', 'Contact Info'),
                          const Divider(),
                          expandItemFollowUs('follow_us', 'Follow Us'),
                          const Divider(),
                          expandItemWeb(
                              'web_site', 'Website', 'https://rentiseazy.com/'),
                          const Divider(),
                          expandItemFaq('faq', 'FAQ '),
                          const Divider(),
                          expandItemFaq('delete-account',
                              'Delete My Rentiseasy Account '),
                        ]),
                      ),
                      height(0.05),
                      columnVersionText()
                    ]),
                  ),
                )))
      ]),
    );
  }
}
