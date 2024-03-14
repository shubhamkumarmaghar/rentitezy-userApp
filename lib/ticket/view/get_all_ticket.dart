import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/ticket/view/view_ticket_details.dart';

import '../../../theme/custom_theme.dart';
import '../../utils/const/widgets.dart';
import '../controller/get_all_ticket_controller.dart';
import '../model/TicketListModel.dart';
import 'create_ticket.dart';

class GetAllTickets extends StatefulWidget {
  const GetAllTickets({super.key});

  @override
  State<GetAllTickets> createState() => _GetAllTicketsState();
}


class _GetAllTicketsState extends State<GetAllTickets> {

  AllTicketController controller = Get.put(AllTicketController());
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.appTheme4,
      appBar: AppBar(
        leading: BackButton(
          color: CustomTheme.white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        titleSpacing: -10,
        backgroundColor: CustomTheme.appTheme,
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Text('Get All Tickets '),
        ),
      ),
      body: GetBuilder<AllTicketController>(
        init: AllTicketController(),
        builder: (controller) {
          var dataList = controller.getAllDetails.data;
           return controller.isLoading == false ? TicketListScreen(
             dataList: dataList,):
           const Center(child: CircularProgressIndicator.adaptive(),);
              }),
      floatingActionButton: Container(
        width: Get.width*0.35
      ,margin: EdgeInsets.all(10),
        child: FloatingActionButton( shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
         onPressed: () async{
           await controller.fetchTicketConfigListDetails();
              Get.to(const CreateTicket());
           },
           backgroundColor: CustomTheme.appTheme,
           child: const FittedBox(
             child: Row(
               children: [
                 Text('   Create Ticket  '),
                 Icon(CupertinoIcons.add_circled),
               ],
             ),
           ),
         ),
      ),
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
        return  GestureDetector(onTap:() async {
        //  await ticketController.fetchTicketConfigListDetails();
          //await ticketController.fetchTicketDetails('${data?.id.toString()}');
          //Get.to(const ViewTicketDetails());
        },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: EdgeInsets.symmetric(
                vertical: 10,horizontal: 10
            ),
            decoration: BoxDecoration(
              color: CustomTheme.white,

              borderRadius: BorderRadius.circular(10),
              boxShadow: [
              BoxShadow(
              blurRadius: 3,
              color: CustomTheme.grey,
                blurStyle:BlurStyle.outer ,
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
                              style:
                              TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Flat : ${data?.unit} ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text('Created on :${dateConvert('${data?.createdOn}')}',
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Category ${data?.category} ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text('Updated on :${dateConvert('${data?.updatedOn}')}'
                                  ,
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Added By  :  ${data?.addedBy}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Status  : ${data?.status.toString().capitalizeFirst}',
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              'Description  :  ${data?.description}',maxLines: 3,
                              style: TextStyle(fontSize: 13),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*   Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 2.5.h,
                              ),
                              Flexible(
                                child: Text(
                                  'Plan',
                                  style: TextStyle(
                                      fontSize: 14.sp, fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                            ],
                          ),*/
                          SizedBox(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },);
  }


}

