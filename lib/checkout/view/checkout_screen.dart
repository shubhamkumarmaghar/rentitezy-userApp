import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/checkout/controller/checkout_controller.dart';
import 'package:rentitezy/property_details/model/property_details_model.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/widgets.dart';

class CheckoutScreen extends StatelessWidget {
  final PropertyDetailsModel propertyDetailsModel;

  const CheckoutScreen({super.key, required this.propertyDetailsModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      init: CheckoutController(propertyDetailsModel: propertyDetailsModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
              backgroundColor: Constants.primaryColor,
              title: Text(
                'Checkout',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                ),
                onPressed: () {
                  Get.back();
                },
              )),
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
                    Obx(() {
                      return Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Constants.primaryColor.withOpacity(0.1),
                          border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                        ),
                        child: DropdownButton<int>(
                          underline: const SizedBox(),
                          isExpanded: true,
                          padding: EdgeInsets.only(left: 10),
                          hint: const Text(
                            'Select Guest',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          iconEnabledColor: Constants.lightBg,
                          items: List.generate(5, (index) => index + 1).map((item) {
                            return DropdownMenuItem<int>(
                              value: item,
                              child: Text(
                                item.toString(),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            controller.numberOfGuests.value = newVal ?? 1;
                          },
                          value: controller.numberOfGuests.value,
                        ),
                      );
                    }),
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
                        replacement: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Constants.primaryColor.withOpacity(0.1),
                            border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                          ),
                          child: DropdownButton<int>(
                            underline: const SizedBox(),
                            padding: const EdgeInsets.only(left: 10),
                            isExpanded: true,
                            hint: Text(
                              'Select Days',
                              style: TextStyle(color: Constants.lightBg, fontFamily: Constants.fontsFamily),
                            ),
                            iconEnabledColor: Constants.lightBg,
                            items: List.generate(31, (index) => index + 1).map((item) {
                              return DropdownMenuItem<int>(
                                value: item,
                                child: Text(
                                  item.toString(),
                                  style:
                                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              controller.selectedDays.value = newVal ?? 1;
                            },
                            value: controller.selectedDays.value,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Constants.primaryColor.withOpacity(0.1),
                            border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                          ),
                          child: DropdownButton<int>(
                            underline: const SizedBox(),
                            padding: const EdgeInsets.only(left: 10),
                            isExpanded: true,
                            hint: Text(
                              'Select Months',
                              style: TextStyle(color: Constants.lightBg, fontFamily: Constants.fontsFamily),
                            ),
                            iconEnabledColor: Constants.lightBg,
                            items: List.generate(11, (index) => index + 1).map(
                              (item) {
                                return DropdownMenuItem<int>(
                                  value: item,
                                  child: Text(
                                    item.toString(),
                                    style:
                                        const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (newVal) {
                              controller.selectedMonths.value = newVal ?? 1;
                            },
                            value: controller.selectedMonths.value,
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    textHeading('Select Unit'),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Constants.primaryColor.withOpacity(0.1),
                        border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
                      ),
                      child: DropdownButton<Units>(
                        underline: const SizedBox(),
                        padding: const EdgeInsets.only(left: 10),
                        isExpanded: true,
                        hint: Text(
                          'Select Unit',
                          style: TextStyle(color: Colors.black54, fontFamily: Constants.fontsFamily),
                        ),
                        iconEnabledColor: Constants.lightBg,
                        items: controller.propertyDetailsModel.units?.map((item) {
                          return DropdownMenuItem<Units>(
                            value: item,
                            child: Text(
                              item.flatNo.toString(),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          controller.selectedPropertyUnitId.value = newVal?.id ?? 0;
                          log('unit id :: ${controller.selectedPropertyUnitId.value}');
                          controller.selectedUnit = newVal;
                          controller.update();
                        },
                        value: controller.selectedUnit,
                      ),
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
                        borderRadius: BorderRadius.circular(30),
                        color: Constants.primaryColor.withOpacity(0.1),
                        border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
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
                    Center(
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
                    ),
                  ],
                ),
              )),
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
