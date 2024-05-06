
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/ticket/controller/create_ticket_controller.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import '../../../theme/custom_theme.dart';
import '../../utils/view/rie_widgets.dart';

class CreateTicketScreen extends StatelessWidget {
  final String bookingId;

  const CreateTicketScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateTicketScreenController>(
      init: CreateTicketScreenController(bookingId: bookingId),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: CustomTheme.white,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            titleSpacing: -10,
            centerTitle: true,
            backgroundColor: Constants.primaryColor,
            title: const Text('Create Ticket '),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const Text(
                          'Select Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        GestureDetector(
                            onTap: () async {
                              final category = await showTicketOptionsList(
                                  title: 'Select Category',
                                  context: context,
                                  statusList: controller.ticketCategoriesList ?? []);
                              if (category != null) {
                                controller.updateTicketCategory(category);
                              }
                            },
                            child: Container(
                                height: screenHeight * 0.06,
                                padding: EdgeInsets.only(left: screenWidth * 0.04),
                                alignment: Alignment.centerLeft,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400, width: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.selectedCategory ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: controller.selectedCategory?.toLowerCase() == 'select category'
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    )
                                  ],
                                ))),
                        SizedBox(height: screenHeight * 0.04),

                        // const Text(
                        //   'Select Status',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        // SizedBox(height: screenHeight * 0.01),
                        // GestureDetector(
                        //     onTap: () async {
                        //       final status = await showTicketOptionsList(
                        //           title: 'Select Status',
                        //           context: context,
                        //           statusList: controller.ticketStatusList ?? []);
                        //       if (status != null) {
                        //         controller.updateTicketStatus(status);
                        //       }
                        //     },
                        //     child: Container(
                        //         height: screenHeight * 0.06,
                        //         padding: EdgeInsets.only(left: screenWidth * 0.04),
                        //         alignment: Alignment.centerLeft,
                        //         width: screenWidth,
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           border: Border.all(color: Colors.grey.shade400, width: 0.5),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               controller.selectedStatus ?? '',
                        //               style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w500,
                        //                   color: controller.selectedStatus?.toLowerCase() == 'select status'
                        //                       ? Colors.grey
                        //                       : Colors.black),
                        //             ),
                        //             const Icon(
                        //               Icons.arrow_drop_down,
                        //               color: Colors.grey,
                        //             )
                        //           ],
                        //         ))),
                        // SizedBox(height: screenHeight * 0.02),
                        const Text(
                          'Ticket Description',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          //  color: Constants.primaryColor.withOpacity(0.1),
                            border: Border.all(color: Colors.grey,width: 0.5)
                          ),
                          height: screenHeight * 0.15,
                          child: TextField(
                            controller: controller.ticketDescriptionController,
                            focusNode: controller.descriptionFocusNode,
                              keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                hoverColor: Constants.hint,
                                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                hintText: 'Please enter an ticket description',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade400
                                ),
                                border: InputBorder.none),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.44),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (controller.bookingId == "") {
                                RIEWidgets.getToast(
                                    message: 'No booking Found so we can not Create ticket.',
                                    color: CustomTheme.errorColor);
                                return;
                              }

                              if (controller.selectedCategory == null ||
                                  controller.selectedCategory == 'Select Category') {
                                RIEWidgets.getToast(
                                    message: 'Please select ticket category', color: CustomTheme.errorColor);
                                return;
                              }

                              if (controller.ticketDescriptionController.text.length < 3) {
                                RIEWidgets.getToast(
                                    message: 'Please enter description about the ticket',
                                    color: CustomTheme.errorColor);
                                FocusScope.of(context).requestFocus(controller.descriptionFocusNode);
                                return;
                              }

                              // if (controller.selectedStatus == null || controller.selectedStatus == 'Select Status') {
                              //   RIEWidgets.getToast(
                              //       message: 'Please select ticket status', color: CustomTheme.errorColor);
                              //   return;
                              // }

                              await controller.createTicket(
                                  ticketCate: controller.selectedCategory.toString(),
                                  ticketDesc: controller.ticketDescriptionController.text,
                                 // ticketStat: controller.selectedStatus.toString()
                               );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: Get.width * 0.8,
                              height: Get.height * 0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Constants.primaryColor,
                              ),
                              child: const Text(
                                "Create Ticket",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<String?> showTicketOptionsList(
      {required BuildContext context, required List<String> statusList, required String title}) async {
    return showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return SizedBox(
            height: title.toLowerCase() == 'select category' ? screenHeight * 0.6 : screenHeight * 0.4,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  height: title.toLowerCase() == 'select category' ? screenHeight * 0.52 : screenHeight * 0.32,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        var data = statusList[index];
                        return GestureDetector(
                          onTap: () => Get.back(result: data),
                          child: Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              height: screenHeight * 0.04,
                              child: Text(
                                data.capitalizeFirst ?? '',
                                style:
                                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                              )),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: statusList.length),
                ),
              ],
            ),
          );
        });
  }
}
