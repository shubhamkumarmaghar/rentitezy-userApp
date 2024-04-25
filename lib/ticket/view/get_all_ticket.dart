import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rentitezy/ticket/view/view_ticket_details.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import '../../../theme/custom_theme.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../utils/const/widgets.dart';
import '../controller/get_all_ticket_controller.dart';
import '../model/TicketListModel.dart';
import 'create_ticket.dart';

class GetAllTickets extends StatefulWidget {
  final bool? fromBottom;

  const GetAllTickets({super.key, this.fromBottom});

  @override
  State<GetAllTickets> createState() => _GetAllTicketsState();
}

class _GetAllTicketsState extends State<GetAllTickets> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.appTheme4,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.find<DashboardController>().setIndex(0);
          },
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
        titleSpacing: -10,
        backgroundColor: Constants.primaryColor,
        title: const Padding(
          padding: EdgeInsets.all(10),
          child: Text('All Tickets '),
        ),
      ),
      body: GetBuilder<AllTicketController>(
          init: AllTicketController(),
          builder: (controller) {
            var dataList = controller.getAllDetails.data;
            return controller.isLoading == false
                ? TicketListScreen(
                    dataList: dataList,
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
          }),
    );
  }
}

class TicketListScreen extends StatelessWidget {
  AllTicketController ticketController = Get.find();

  TicketListScreen({
    required this.dataList,
  });

  final List<Data>? dataList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList?.length,
      itemBuilder: (context, index) {
        var data = dataList?[index];
        return GestureDetector(
          onTap: () async {
            // await ticketController.fetchTicketConfigListDetails();
            // await ticketController.fetchTicketDetails('${data?.id.toString()}');
            // Get.to(const ViewTicketDetails());
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: CustomTheme.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: CustomTheme.grey,
                  blurStyle: BlurStyle.outer,
                  //spreadRadius: 0.5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ticket Id : ${data?.id} ',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Flat : ${data?.unit} ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Created on :${dateConvert('${data?.createdOn}')}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Category ${data?.category} ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Updated on :${dateConvert('${data?.updatedOn}')}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Added By  :  ${data?.addedBy}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Status  : ${data?.status.toString().capitalizeFirst}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              'Description  :  ${data?.description}',
                              maxLines: 3,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
