// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:rentitezy/single_property_details/controller/single_property_details_controller.dart';
// import 'package:rentitezy/theme/custom_theme.dart';
// import 'package:rentitezy/utils/const/appConfig.dart';
// import 'package:rentitezy/checkout/model/checkout_model.dart';
// import 'package:rentitezy/utils/view/rie_widgets.dart';
// import '../single_property_details/model/single_property_details_model.dart';
// import '../utils/const/widgets.dart';
//
// class CheckOutPage extends StatefulWidget {
//   final CheckoutModel? checkoutModel;
//   final String from;
//   final SinglePropertyDetails? propertyModel;
//   final DateTime? currentDate;
//
//   const CheckOutPage(
//       {super.key, required this.checkoutModel, required this.from, this.currentDate, this.propertyModel});
//
//   @override
//   State<CheckOutPage> createState() => _CheckOutPageState();
// }
//
// class _CheckOutPageState extends State<CheckOutPage> {
//   SinglePropertyDetailsController singlePropertyDetailsController = Get.find();
//
//   Widget textWid(String txt, Color clr, double font, FontWeight fw) {
//     return Text(
//       txt,
//       style: TextStyle(fontFamily: Constants.fontsFamily, color: clr, fontSize: font, fontWeight: fw),
//     );
//   }
//
//   Widget columnTxt(String title, String subTitle) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         textWid(title, Constants.black, 15, FontWeight.normal),
//         textWid(subTitle, Constants.black, 13, FontWeight.bold)
//       ],
//     );
//   }
//
//   bool loadingLeads = false;
//
//   void showBottomDetails(String data, BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
//         ),
//         builder: (context) {
//           return Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: StatefulBuilder(
//                 builder: (BuildContext context, setState) => SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Text(
//                             'Please Fill Your Details',
//                             style: TextStyle(
//                                 fontFamily: Constants.fontsFamily,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20),
//                           ),
//                         ),
//                         Center(
//                             child: Container(
//                           height: 1,
//                           width: 40,
//                           color: Colors.black,
//                         )),
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: TextField(
//                             keyboardType: TextInputType.text,
//                             controller: singlePropertyDetailsController.nameController,
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: "Name",
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: TextField(
//                             keyboardType: TextInputType.text,
//                             controller: singlePropertyDetailsController.emailController,
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: "Email",
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: TextField(
//                             keyboardType: TextInputType.phone,
//                             controller: singlePropertyDetailsController.phoneController,
//                             inputFormatters: <TextInputFormatter>[
//                               FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: "Phone",
//                             ),
//                           ),
//                         ),
//                         height(0.05),
//                         GestureDetector(
//                           onTap: () async {
//                             if (singlePropertyDetailsController.nameController.text.isEmpty) {
//                               RIEWidgets.getToast(message: 'Enter valid name', color: CustomTheme.white);
//                             } else if (singlePropertyDetailsController.emailController.text.isEmpty) {
//                               RIEWidgets.getToast(message: 'Enter valid email', color: CustomTheme.white);
//                             } else if (singlePropertyDetailsController.phoneController.text.isEmpty) {
//                               RIEWidgets.getToast(message: 'Enter valid phone', color: CustomTheme.white);
//                             } else if (singlePropertyDetailsController.phoneController.text.length != 10) {
//                               RIEWidgets.getToast(message: 'Enter valid phone digit', color: CustomTheme.white);
//                             } else {
//                               singlePropertyDetailsController
//                                   .paymentRequest('${singlePropertyDetailsController.checkoutModel?.cartId}');
//                             }
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * 0.70,
//                             height: 50,
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Constants.primaryColor,
//                               borderRadius: BorderRadius.circular(40),
//                             ),
//                             child: loadingLeads
//                                 ? const Center(
//                                     child: SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   )
//                                 : Center(
//                                     child: Text(
//                                       'Submit',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           fontFamily: Constants.fontsFamily,
//                                           color: Colors.white,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         height(0.005),
//                       ],
//                     ))),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
//         titleSpacing: -10,
//         backgroundColor: Constants.primaryColor,
//         title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
//       ),
//       body: Container(
//         width: screenWidth,
//         height: screenHeight,
//         padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(child: columnTxt("Name", '${singlePropertyDetailsController.checkoutModel?.name}')),
//                     Expanded(child: columnTxt("Address", '${singlePropertyDetailsController.checkoutModel?.address}'))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(child: columnTxt("Move In", '${singlePropertyDetailsController.checkoutModel?.moveIn}')),
//                     Expanded(child: columnTxt("Move Out", '${widget.checkoutModel?.moveOut}'))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         child: columnTxt("Duration", '${singlePropertyDetailsController.checkoutModel?.duration}')),
//                     Expanded(
//                         child: columnTxt(
//                             "Rent", '${Constants.currency}.${singlePropertyDetailsController.checkoutModel?.rent}'))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         child: columnTxt("Deposit",
//                             '${Constants.currency} ${singlePropertyDetailsController.checkoutModel?.deposit}')),
//                     Expanded(
//                       child: columnTxt("OnBoarding", '${widget.checkoutModel?.onboarding}'),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(child: columnTxt("Guest", '${singlePropertyDetailsController.checkoutModel?.guest}')),
//                     Expanded(child: columnTxt("Lock In", '${singlePropertyDetailsController.checkoutModel?.lockIn}'))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         child: columnTxt("Amount",
//                             '${Constants.currency} ${singlePropertyDetailsController.checkoutModel?.amount}')),
//                     Expanded(
//                         child: columnTxt(
//                             "Total", '${Constants.currency} ${singlePropertyDetailsController.checkoutModel?.total}'))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         child: columnTxt("Maintenance",
//                             '${Constants.currency} ${singlePropertyDetailsController.checkoutModel?.maintenance}'))
//                   ],
//                 ),
//               ),
//               height(0.25),
//               InkWell(
//                 onTap: () async {
//                   showBottomDetails('${singlePropertyDetailsController.checkoutModel?.cartId}', context);
//                 },
//                 child: Container(
//                   width: screenWidth * 0.8,
//                   height: screenHeight * 0.065,
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Constants.primaryColor,
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Submit',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: Constants.fontsFamily,
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
