import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/functions/util_functions.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../utils/const/widgets.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/app_bar.dart';
import '../controller/tickets_controller.dart';

class TicketsListScreen extends StatelessWidget {
  const TicketsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (invoked) {
        Get.find<DashboardController>().setIndex(0);
      },
      child: GetBuilder<TicketsController>(
        init: TicketsController(),
        builder: (controller) {
          return Scaffold(
            appBar: appBarWidget(
              title: 'All Tickets',
              onBack: () => Get.find<DashboardController>().setIndex(0),
            ),
            backgroundColor: Colors.white,
            body: Container(
              height: screenHeight,
              width: screenWidth,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20,bottom: 20),
              child: controller.ticketsList == null
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : controller.ticketsList != null && controller.ticketsList!.isEmpty
                      ? RIEWidgets.noData(message: 'No Tickets found!')
                      : ListView.separated(
                          itemCount: controller.ticketsList!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            var data = controller.ticketsList![index];
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ExpansionTile(
                                childrenPadding: EdgeInsets.only(
                                  left: screenWidth * 0.04,
                                  right: screenWidth * 0.04,
                                ),
                                tilePadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                shape: const Border(),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    expandableTitleStyle('Booking id', data.id.toString()),
                                    expandableStatusStyle(
                                        'Status', data.status != null ? data.status!.capitalizeFirst! : 'NA')
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    expandableTitleStyle('Category', data.category ?? 'NA'),
                                  ],
                                ),
                                children: [
                                  expandableBodyStyle('Flat', data.unit ?? 'NA'),
                                  expandableBodyStyle('Created on', convertDateTimeToLocalTime('${data.createdOn}')),
                                  expandableDescriptionStyle('Description', data.description ?? 'NA'),
                                  SizedBox(
                                    height: screenHeight * 0.025,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget expandableBodyStyle(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenWidth * 0.3,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.5,
          child: Text(
            title.toLowerCase().contains('amount') ? '${Constants.currency} $value' : value.capitalizeFirst.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        )
      ],
    );
  }

  Widget expandableDescriptionStyle(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenWidth * 0.3,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.5,
          child: Text(
            title.toLowerCase().contains('amount') ? '${Constants.currency} $value' : value.capitalizeFirst.toString(),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        )
      ],
    );
  }

  Widget expandableTitleStyle(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.19,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        width(0.01),
        Text(
          value.capitalizeFirst.toString(),
          style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontsFamily),
        )
      ],
    );
  }

  Widget expandableStatusStyle(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.12,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: Constants.fontsFamily),
          ),
        ),
        width(0.01),
        Text(
          value.capitalizeFirst.toString(),
          style: TextStyle(
              color: Colors.blueGrey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontsFamily),
        )
      ],
    );
  }
}
