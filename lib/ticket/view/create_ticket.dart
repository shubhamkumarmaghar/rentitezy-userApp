import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/custom_theme.dart';
import '../../../utils/view/custom_textField_title.dart';
import '../../utils/view/rie_widgets.dart';
import '../controller/get_all_ticket_controller.dart';
import '../model/ticket_config_model.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  Properties? selectedPropertyy;

  String? selectedCategoryy;

  String? selectedStatuss;

  AllTicketController controller = Get.find();

  @override
  void dispose() {
    super.dispose();
    controller.selectedProperty = selectedPropertyy;
    controller.selectedCategory = selectedCategoryy;
    controller.selectedStatus = selectedStatuss;
    controller.ticketDescription.text = '';
    controller.ticketPropertiesList?.clear();
    controller.ticketCategoriesList?.clear();
    controller.ticketStatusList?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: CustomTheme.white,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        titleSpacing: -10,
        backgroundColor: CustomTheme.appTheme,
        title: const Padding(
          padding: EdgeInsets.all(10),
          child: Text('Create Ticket '),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: 25,
            right: 25,
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.05,
              ),
           /*   Text(
                'Choose Flat',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'malgun',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButton<Properties>(
                  autofocus: true,
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  underline: SizedBox(),
                  hint: Text('Selcet Flat'),
                  onChanged: (property) {
                    setState(() => controller.selectedProperty = property);

                    log('selected property ${controller.selectedProperty?.title.toString()}');
                  },
                  value: controller.selectedProperty,
                  items:

                      /*controller.ticketPropertiesList.map((items) {

              return DropdownMenuItem<String>(

                value: items.toString(),

                child: Text(items.toString()),

              );

            }).toList(),*/

                      controller.ticketPropertiesList
                          ?.map<DropdownMenuItem<Properties>>(
                              (Properties prop) {
                    return DropdownMenuItem<Properties>(
                      value: prop,
                      child: Row(
                        children: [
                          Text('${prop.value} ${prop.title}'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),*/
              Text(
                'Choose Category',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'malgun',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.center,

                // margin: EdgeInsets.only(left: 25,right: 25,top: 20),

                padding: EdgeInsets.only(left: 10, right: 10),

                height: 50,

                width: Get.width,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: DropdownButton<String>(
                  underline: SizedBox(),
                  isExpanded: true,
                  hint: Text('Selcet Category'),
                  onChanged: (category) {
                    setState(() => controller.selectedCategory = category);

                    log('selected category ${controller.selectedCategory.toString()}');
                  },
                  value: controller.selectedCategory,
                  items:

                      /*controller.ticketPropertiesList.map((items) {

              return DropdownMenuItem<String>(

                value: items.toString(),

                child: Text(items.toString()),

              );

            }).toList(),*/

                      controller.ticketCategoriesList
                          ?.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              TextFieldWithTitle(
                title: 'Ticket  Description',
                controller: controller.ticketDescription,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ticket description';
                  } else {
                    return null;
                  }
                },
              ),
              Text(
                'Choose Status',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'malgun',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.center,

                // margin: EdgeInsets.only(left: 25,right: 25,top: 20),

                padding: EdgeInsets.only(left: 10, right: 10),

                height: 50,

                width: Get.width,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: DropdownButton<String>(
                  underline: SizedBox(),
                  hint: Text('Selcet Status'),
                  isExpanded: true,
                  onChanged: (status) {
                    setState(() => controller.selectedStatus = status);

                    log('selected status ${controller.selectedStatus}');
                  },
                  value: controller.selectedStatus,
                  items: /*controller.ticketPropertiesList.map((items) {

              return DropdownMenuItem<String>(

                value: items.toString(),

                child: Text(items.toString()),

              );

            }).toList(),*/

                      controller.ticketStatusList
                          ?.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                /*  if (controller.selectedProperty?.value == null) {
                    RIEWidgets.getToast(
                        message: 'Please Select Flat',
                        color: CustomTheme.white);

                    return;
                  }*/

                  if (controller.selectedCategory == null  ) {
                    RIEWidgets.getToast(
                        message: 'Please Select Category',
                        color: CustomTheme.white);

                    return;
                  }

                  if (controller.ticketDescription.text.isEmpty) {
                    RIEWidgets.getToast(
                        message: 'Please Enter description about the ticket',
                        color: CustomTheme.white);

                    return;
                  }

                  if (controller.selectedCategory == null ||
                      controller.selectedCategory == '') {
                    RIEWidgets.getToast(
                        message: 'Please Select tickets Status',
                        color: CustomTheme.white);

                    return;
                  }

                  await controller.createTicket(
                      flatId:
                          '55',
                      ticketCate: controller.selectedCategory.toString(),
                      ticketDesc: controller.ticketDescription.text,
                      ticketStat: controller.selectedStatus.toString());

                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width * 0.3,
                  height: Get.height * 0.04,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange,
                  ),
                  child: FittedBox(
                      child: Text(
                    "Create Ticket",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
