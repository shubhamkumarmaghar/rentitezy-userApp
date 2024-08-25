import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/bookings/model/booking_details_model.dart';
import 'package:rentitezy/ticket/view/create_ticket_screen.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:rentitezy/utils/widgets/custom_elevated_button.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../add_kyc/view/add_kyc_screen.dart';
import '../../invoices/view/invoices_screen.dart';
import '../../theme/custom_theme.dart';
import '../../utils/functions/util_functions.dart';
import '../../utils/widgets/app_bar.dart';
import '../../utils/widgets/custom_photo_view.dart';
import '../controller/bookings_controller.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({
    super.key,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      builder: (controller) {
        var data = controller.bookingDetailsModel;
        bool navigateToMap = false;
        if (controller.bookingDetailsModel?.propListing?.property?.latlng != null) {
          if (controller.bookingDetailsModel?.propListing?.property?.latlng != '' &&
              controller.bookingDetailsModel!.propListing!.property!.latlng!.contains('undefined') == false) {
            navigateToMap = true;
          }
        }
        return Scaffold(
          appBar: appBarWidget(
            title: 'Booking Details',
            onRefresh: () => controller.getBookingDetails(bookingId: '${data?.id}', showLoader: true),
          ),
          body: Container(
            width: getScreenWidth,
            height: getScreenHeight,
            padding: EdgeInsets.symmetric(horizontal: getScreenWidth * 0.035, vertical: getScreenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getPropInfoView(controller: controller),
                  SizedBox(
                    height: getScreenHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
                        decoration: BoxDecoration(
                            color: data!.status!.toLowerCase().contains('cancel')
                                ? CustomTheme.errorColor
                                : CustomTheme.myFavColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Booking Status : ${data.status?.capitalizeFirst ?? ''}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                      Visibility(
                        visible: navigateToMap,
                        replacement: const SizedBox.shrink(),
                        child: GestureDetector(
                          onTap: () => controller.navigateToMap(data.propListing?.property?.latlng),
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
                            decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: getScreenWidth * 0.05,
                                  color: Constants.primaryColor,
                                ),
                                SizedBox(
                                  width: getScreenWidth * 0.01,
                                ),
                                Text(
                                  'Map',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500, color: Constants.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  getPropertyFinancialInfo(controller: controller),
                  getPropertyUserInfo(controller: controller),
                  getPropertyBookingInfo(controller: controller),
                  getTenantsInfo(controller: controller),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Visibility(
            visible: data.status != null ? !data.status!.toLowerCase().contains('cancel') : false,
            replacement: const SizedBox.shrink(),
            child: Container(
              margin: EdgeInsets.only(
                  left: getScreenWidth * 0.035, right: getScreenWidth * 0.035, bottom: getScreenHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    child: SizedBox(
                      width: screenWidth * 0.42,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(CustomTheme.appThemeContrast),
                          ),
                          onPressed: () async {
                            Get.to(() => InvoiceScreen(bookingId: data.id?.toString() ?? ''));
                          },
                          child: const Text('Invoice(s)')),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.42,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Constants.primaryColor),
                        ),
                        onPressed: () {
                          if (data.status!.toLowerCase().contains('cancel')) {
                            RIEWidgets.getToast(
                                message: "Can't create ticket for cancelled booking!", color: CustomTheme.errorColor);
                            return;
                          }
                          Get.to(CreateTicketScreen(
                            bookingId: controller.bookingDetailsModel!.id.toString(),
                          ));
                        },
                        child: const Text('Create Ticket')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getPropInfoView({required BookingsController controller}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Container(
            height: getScreenHeight * 0.15,
            width: getScreenWidth * 0.32,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(
                    controller.bookingDetailsModel?.propListing != null &&
                            controller.bookingDetailsModel?.propListing!.images != null &&
                            controller.bookingDetailsModel!.propListing!.images!.isNotEmpty
                        ? controller.bookingDetailsModel?.propListing?.images![0].url ?? ''
                        : '',
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        SizedBox(
          width: getScreenWidth * 0.04,
        ),
        SizedBox(
          width: getScreenWidth * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.house,
                    size: getScreenWidth * 0.05,
                    color: CustomTheme.appThemeContrast,
                  ),
                  SizedBox(
                    width: getScreenWidth * 0.01,
                  ),
                  SizedBox(
                    width: getScreenWidth * 0.47,
                    child: Text(
                      controller.bookingDetailsModel?.propListing?.property?.name ?? '',
                      style: TextStyle(color: Constants.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getScreenHeight * 0.005,
              ),
              Visibility(
                visible: controller.bookingDetailsModel?.propListing?.property?.address != null &&
                    controller.bookingDetailsModel!.propListing!.property!.address.toString().isNotEmpty,
                replacement: const SizedBox.shrink(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_searching_rounded,
                      size: getScreenWidth * 0.05,
                      color: CustomTheme.appThemeContrast,
                    ),
                    SizedBox(
                      width: getScreenWidth * 0.01,
                    ),
                    SizedBox(
                      width: Get.width * 0.47,
                      child: Text(
                        '${controller.bookingDetailsModel?.propListing?.property?.address}',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getPropertyFinancialInfo({required BookingsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Divider(),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Text(
          'Payment Info',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Rent', value: '₹ ${controller.bookingDetailsModel?.rent ?? ''}'),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Deposit', value: '₹ ${controller.bookingDetailsModel?.deposit ?? ''}'),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Onboarding', value: '₹ ${controller.bookingDetailsModel?.onboarding ?? ''}'),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Amount Paid', value: '₹ ${controller.bookingDetailsModel?.amountPaid ?? ''}'),
      ],
    );
  }

  Widget getPropertyUserInfo({required BookingsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: getScreenHeight * 0.02,
        ),
        const Divider(),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Text(
          'User Info',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Name', value: controller.bookingDetailsModel?.name),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Email', value: controller.bookingDetailsModel?.email),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Mobile', value: controller.bookingDetailsModel?.phone),
      ],
    );
  }

  Widget getPropertyBookingInfo({required BookingsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Divider(),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Text(
          'Booking Info',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(
            text: 'No. of Guest',
            value:
                controller.bookingDetailsModel?.guest != null ? controller.bookingDetailsModel?.guest.toString() : ''),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'From Date', value: getLocalTime(controller.bookingDetailsModel?.from)),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Till Date', value: getLocalTime(controller.bookingDetailsModel?.till)),
      ],
    );
  }

  Widget getTenantsInfo({required BookingsController controller}) {
    if ( controller.bookingDetailsModel == null || controller.bookingDetailsModel?.tenants == null ||  !controller.bookingDetailsModel!.status!.toLowerCase().contains('success')) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Divider(),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        const Text(
          'Tenants Info',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        Visibility(
          visible: controller.bookingDetailsModel!.status!.toLowerCase().contains('success') &&
              controller.bookingDetailsModel!.tenants!.length < controller.bookingDetailsModel!.guest!,
          child: Row(
            children: [
              Container(
                width: screenWidth * 0.66,
                padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                decoration: BoxDecoration(color: CustomTheme.errorColor, borderRadius: BorderRadius.circular(2)),
                child: Text(
                  'Please add kyc documents for other ${controller.bookingDetailsModel!.guest! - controller.bookingDetailsModel!.tenants!.length} tenant.',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              CustomElevatedButton(
                  onClick: () {
                    int remainingKyc =
                        controller.bookingDetailsModel!.guest! - controller.bookingDetailsModel!.tenants!.length;
                    Get.to(() => AddKycScreen(
                          guestCount: remainingKyc,
                          fromPayment: false,
                          bookingId: controller.bookingDetailsModel!.id.toString(),
                        ));
                  },
                  height: screenHeight * 0.03,
                  width: screenWidth * 0.2,
                  radius: 5,
                  text: 'Add Kyc'),
            ],
          ),
        ),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        Visibility(
          visible: controller.bookingDetailsModel != null &&
              controller.bookingDetailsModel?.tenants != null &&
              controller.bookingDetailsModel!.tenants!.isNotEmpty,
          replacement: const SizedBox.shrink(),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.bookingDetailsModel!.tenants!.length,
            separatorBuilder: (context, index) => height(0.03),
            itemBuilder: (context, index) {
              var data = controller.bookingDetailsModel?.tenants![index];
              return getTenantDataView(tenants: data!, index: index);
            },
          ),
        ),
      ],
    );
  }

  Widget getTenantDataView({required Tenants tenants, required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tenant ${index + 1}',
          style: TextStyle(color: CustomTheme.appThemeContrast, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        getBookingDataText(text: 'Name', value: tenants.name),
        getBookingDataText(text: 'Email', value: tenants.email),
        getBookingDataText(text: 'Phone', value: tenants.phone),
        getBookingDataText(text: 'Nationality', value: tenants.nationality),
        height(0.02),
        Visibility(
          visible: tenants.proofs != null && tenants.proofs!.isNotEmpty,
          replacement: const SizedBox.shrink(),
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tenants.proofs?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 20, childAspectRatio: 1.0),
            itemBuilder: (BuildContext context, int index) {
              var docUrl = tenants.proofs![index];
              return GestureDetector(
                onTap: (){
                  Get.to(() => CustomPhotoView(
                    imageUrl: docUrl.url ?? '',
                  ));
                },
                child: SizedBox(
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.1,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        docUrl.url ?? '',
                        fit: BoxFit.cover,
                      )),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget getBookingDataText({required String text, String? value}) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.3,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.55,
          child: Text(
            value ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade500),
          ),
        ),
      ],
    );
  }
}
