import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/ticket/view/create_ticket_screen.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../invoices/view/invoices_screen.dart';
import '../../theme/custom_theme.dart';
import '../../utils/functions/util_functions.dart';
import '../../widgets/app_bar.dart';
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
        var data = controller.getSingleBooking?.data;
        bool navigateToMap = false;
        if (controller.getSingleBooking?.data?.propListing?.property?.latlng != null) {
          if (controller.getSingleBooking?.data?.propListing?.property?.latlng != '' &&
              controller.getSingleBooking!.data!.propListing!.property!.latlng!.contains('undefined') == false) {
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
                  SizedBox(
                    height: getScreenHeight * 0.01,
                  ),
                  const Divider(),
                  SizedBox(
                    height: getScreenHeight * 0.01,
                  ),
                  const Text(
                    'Financial Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    height: getScreenHeight * 0.01,
                  ),
                  getPropertyFinancialInfo(controller: controller),
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
                  getPropertyUserInfo(controller: controller),
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
                  getPropertyBookingInfo(controller: controller),
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
                            bookingId: controller.getSingleBooking!.data!.id.toString(),
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
                    controller.getSingleBooking?.data?.propListing != null &&
                            controller.getSingleBooking?.data?.propListing!.images != null &&
                            controller.getSingleBooking!.data!.propListing!.images!.isNotEmpty
                        ? controller.getSingleBooking?.data?.propListing?.images![0].url ?? ''
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
                      controller.getSingleBooking?.data?.propListing?.property?.name ?? '',
                      style: TextStyle(color: Constants.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getScreenHeight * 0.005,
              ),
              Visibility(
                visible: controller.getSingleBooking?.data?.propListing?.property?.address != null &&
                    controller.getSingleBooking!.data!.propListing!.property!.address.toString().isNotEmpty,
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
                        '${controller.getSingleBooking?.data?.propListing?.property?.address}',
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
        getBookingDataText(text: 'Rent', value: '₹ ${controller.getSingleBooking?.data?.rent ?? ''}'),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Deposit', value: '₹ ${controller.getSingleBooking?.data?.deposit ?? ''}'),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Onboarding', value: '₹ ${controller.getSingleBooking?.data?.onboarding ?? ''}'),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Amount Paid', value: '₹ ${controller.getSingleBooking?.data?.amountPaid ?? ''}'),
      ],
    );
  }

  Widget getPropertyUserInfo({required BookingsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getBookingDataText(text: 'Name', value: controller.getSingleBooking?.data?.name),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Email', value: controller.getSingleBooking?.data?.email),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Mobile', value: controller.getSingleBooking?.data?.phone),
      ],
    );
  }

  Widget getPropertyBookingInfo({required BookingsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getBookingDataText(
            text: 'No. of Guest',
            value: controller.getSingleBooking?.data?.guest != null
                ? controller.getSingleBooking?.data?.guest.toString()
                : ''),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Move-In', value: getLocalTime(controller.getSingleBooking?.data?.from)),
        SizedBox(
          height: getScreenHeight * 0.01,
        ),
        getBookingDataText(text: 'Move-Out', value: getLocalTime(controller.getSingleBooking?.data?.till)),
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
