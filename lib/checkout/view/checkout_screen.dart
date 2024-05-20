import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/checkout/controller/checkout_controller.dart';
import '../../home/model/property_list_nodel.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';
import '../../widgets/app_bar.dart';

class CheckoutScreen extends StatelessWidget {
  final String? listingType;
  final String listingId;

  final List<Units>? propertyUnitsList;

  const CheckoutScreen({super.key, required this.listingId, this.listingType, this.propertyUnitsList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      init: CheckoutController(listingId: listingId, propertyUnitsList: propertyUnitsList, listingType: listingType),
      builder: (controller) {
        return Scaffold(
          appBar: appBarWidget(
            title: 'Checkout',
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please Fill Your Details',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilterChip(
                              label: const Text('Monthly Booking'),
                              selectedColor: Constants.primaryColor,
                              backgroundColor: Colors.grey,
                              checkmarkColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.white),
                              selected: controller.monthSelected.value,
                              onSelected: (value) {
                                controller.monthSelected.value = true;
                              }),
                          FilterChip(
                              label: const Text('Daily Booking  '),
                              selectedColor: Constants.primaryColor,
                              backgroundColor: Colors.grey,
                              checkmarkColor: Colors.white,
                              labelStyle: const TextStyle(color: Colors.white),
                              selected: controller.monthSelected.value == false,
                              onSelected: (value) {
                                controller.monthSelected.value = false;
                              }),
                        ],
                      );
                    }),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    textHeading('No. of Guests'),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    pickerButton(
                        onTap: () async {
                          final guest = await showDataDialog(
                              context: context, title: 'Guest', dataList: controller.guestCountList);
                          if (guest != null) {
                            controller.guestController.text = guest;
                          }
                        },
                        textController: controller.guestController,
                        hintText: 'Guest'),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    Obx(() {
                      return textHeading(controller.monthSelected.value ? 'Select Months' : 'Select Days');
                    }),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Obx(() {
                      return Visibility(
                        visible: controller.monthSelected.value,
                        replacement: pickerButton(
                            onTap: () async {
                              final day = await showDataDialog(
                                  context: context,
                                  title: 'Select Days',
                                  dataList: List.generate(31, (index) => (index + 1).toString()));
                              if (day != null) {
                                controller.dayController.text = day;
                              }
                            },
                            textController: controller.dayController,
                            hintText: 'Select Days'),
                        child: pickerButton(
                            onTap: () async {
                              final month = await showDataDialog(
                                  context: context,
                                  title: 'Select Month',
                                  dataList: List.generate(11, (index) => (index + 1).toString()));
                              if (month != null) {
                                controller.monthController.text = month;
                              }
                            },
                            textController: controller.monthController,
                            hintText: 'Select Month'),
                      );
                    }),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    textHeading('Select Unit'),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Visibility(
                      visible: controller.propertyUnitsList != null,
                      replacement: const SizedBox.shrink(),
                      child: pickerButton(
                          onTap: () async {
                            List<String> data = controller.propertyUnitsList!.map((e) => e.flatNo ?? '').toList();

                            final flatUnit =
                                await showDataDialog(context: context, title: 'Select Unit', dataList: data);

                            if (flatUnit != null) {
                              final unit =
                                  controller.propertyUnitsList!.firstWhere((element) => element.flatNo == flatUnit);
                              controller.selectedPropertyUnitId.value = unit.id ?? 0;
                              controller.unitController.text = flatUnit;
                            }
                          },
                          textController: controller.unitController,
                          hintText: 'Select Unit'),
                    ),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    textHeading('Select Date'),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.lightBg,
                      ),
                      child: InkWell(
                        onTap: controller.onSelectDate,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Constants.primaryColor,
                              size: 20,
                            ),
                            Obx(() {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  DateFormat.yMMMd().format(controller.selectedDate.value),
                                  style:
                                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.16,
                    ),
                    Obx(() {
                      return Center(
                        child: SizedBox(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.8,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed:
                                  controller.selectedPropertyUnitId.value == 0 ? null : controller.submitBookingRequest,
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              )),
                        ),
                      );
                    }),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget pickerButton(
      {required Function onTap, required TextEditingController textController, required String hintText}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Constants.lightBg,
        ),
        height: screenHeight * 0.06,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.75,
              child: TextField(
                controller: textController,
                enabled: false,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hoverColor: Constants.hint,
                    contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                    hintText: hintText,
                    border: InputBorder.none),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_outlined,
              color: Constants.greyLight,
            )
          ],
        ),
      ),
    );
  }

  Future<String?> showDataDialog(
      {required BuildContext context, required String title, required List<String> dataList}) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05),
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: Container(
                height: Get.height * 0.45,
                width: Get.width * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: screenHeight * 0.01, bottom: screenHeight * 0.02),
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    Container(
                      height: Get.height * 0.37,
                      width: Get.width * 0.7,
                      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                      child: ListView.separated(
                        itemCount: dataList.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          var data = dataList[index];
                          return InkWell(
                            onTap: () {
                              Get.back(result: data.toString());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.01,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: Center(
                                child: Text(
                                  data.toString(),
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade500),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Text textHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}
