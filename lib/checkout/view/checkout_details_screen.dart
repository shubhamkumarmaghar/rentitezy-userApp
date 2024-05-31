
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rentitezy/checkout/controller/checkout_controller.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../../utils/widgets/app_bar.dart';
import '../model/checkout_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/view/rie_widgets.dart';

class CheckoutDetailsScreen extends StatelessWidget {
  final CheckoutModel checkoutModel;
  final checkoutController = Get.find<CheckoutController>();

  CheckoutDetailsScreen({super.key, required this.checkoutModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: 'Checkout  Details',
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Checkout Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.01),
              rowText(title: "Property Name", value: checkoutModel.name),
              rowText(title: "Duration", value: checkoutModel.duration),
              rowText(title: "Move In", value: checkoutModel.moveIn),
              rowText(title: "Move Out", value: checkoutModel.moveOut),
              rowText(title: "Guest", value: checkoutModel.guest),
              rowText(title: "Lock In", value: checkoutModel.lockIn),
              rowText(title: "Address", value: checkoutModel.address),
              SizedBox(height: screenHeight * 0.04),
              const Text(
                'Financial Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.01),
              rowText(title: "Rent", value: checkoutModel.rent, showCurrency: true),
              rowText(title: "Deposit", value: checkoutModel.deposit, showCurrency: true),
              rowText(title: "OnBoarding", value: checkoutModel.onboarding, showCurrency: true),
              rowText(title: "Maintenance", value: checkoutModel.maintenance, showCurrency: true),
              // SizedBox(height: screenHeight * 0.01),
              // Row(
              //
              //   children: List.generate(
              //       50,
              //       (index) => Expanded(
              //             child: Container(
              //               color: index % 2 == 0 ? Colors.transparent : Colors.grey,
              //               height: 1,
              //             ),
              //           )),
              // ),
              // SizedBox(height: screenHeight * 0.01),
              rowText(title: "Total", value: checkoutModel.total, showCurrency: true),
              const Divider(),
              rowText(title: "Amount to pay", value: checkoutModel.amount, showCurrency: true),
              SizedBox(
                height: screenHeight * 0.17,
              ),
              Center(
                child: SizedBox(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.8,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () => showUserDetailsBottomModalSheet(context),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowText({required String title, dynamic value, bool? showCurrency}) {
    return Visibility(
      visible: value != null,
      replacement: const SizedBox.shrink(),
      child: Container(
        padding: EdgeInsets.only(bottom: screenHeight * 0.01),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.24,
              child: Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            width(0.05),
            SizedBox(
              width: screenWidth * 0.58,
              child: Text(
                showCurrency != null && showCurrency == true
                    ? '${Constants.currency} ${value.toString().capitalizeFirst.toString()}'
                    : value.toString().capitalizeFirst.toString(),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.blueGrey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget inputField(
      {required TextEditingController controller,
      required String hintText,
      required TextInputType textInputType,
      required IconData prefixIcon,
      int? maxLength,
      List<TextInputFormatter>? inputFormatters}) {
    return Container(
      height: screenHeight * 0.06,
      margin: EdgeInsets.only(bottom: screenHeight * 0.025),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.04,
          ),
          Icon(
            prefixIcon,
            color: Constants.primaryColor,
            size: 20,
          ),
          SizedBox(
            width: screenWidth * 0.78,
            child: TextFormField(
              controller: controller,
              keyboardType: textInputType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              decoration: InputDecoration(
                  hoverColor: Constants.hint,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
            ),
          ),
        ],
      ),
    );
  }

  void showUserDetailsBottomModalSheet(BuildContext context) {
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Please Fill Your Details',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                          Center(
                              child: Container(
                            height: 0.5,
                            width: screenWidth * 0.2,
                            color: Colors.black,
                          )),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          inputField(
                              controller: checkoutController.nameController,
                              hintText: 'Name',
                              prefixIcon: Icons.person,
                              textInputType: TextInputType.text),
                          inputField(
                              controller: checkoutController.phoneController,
                              hintText: 'Mobile number',
                              prefixIcon: Icons.phone,
                              textInputType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ]),
                          inputField(
                              controller: checkoutController.emailController,
                              hintText: 'Email Address',
                              prefixIcon: Icons.email,
                              textInputType: TextInputType.emailAddress),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (checkoutController.nameController.text.isEmpty) {
                                RIEWidgets.getToast(message: 'Enter valid name', color: CustomTheme.errorColor);
                              } else if (checkoutController.emailController.text.isEmpty) {
                                RIEWidgets.getToast(message: 'Enter valid email', color: CustomTheme.errorColor);
                              } else if (checkoutController.phoneController.text.isEmpty) {
                                RIEWidgets.getToast(message: 'Enter valid phone number', color: CustomTheme.errorColor);
                              } else if (checkoutController.phoneController.text.length != 10) {
                                RIEWidgets.getToast(message: 'Enter valid phone number', color: CustomTheme.errorColor);
                              } else {
                                checkoutController.requestPayment(checkoutModel.cartId?.toString() ?? '');
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
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                        ],
                      ),
                    ))),
          );
        });
  }
}
