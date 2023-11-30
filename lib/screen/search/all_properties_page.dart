import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/search_listing_model.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/widgets/search_items.dart';

import 'search_controller.dart';

class AllPropertiesPage extends StatelessWidget {
  AllPropertiesPage({super.key});
  final searchController = Get.put(SearchPController());
  Widget searchWidget(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Constants.lightSearch,
          borderRadius: BorderRadius.circular(30)),
      child: ListTile(
        leading: const Icon(Icons.search),
        horizontalTitleGap: 0,
        title: TextField(
          controller: searchController.searchQuery,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by property name',
          ),
        ),
      ),
    );
  }

  Widget recommendWidget(FlatModel propertyModel) {
    return SearchItem(
      propertyModel: propertyModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Constants.primaryColor,
          title: Text(
            'Search Properties',
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchWidget(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Obx(
                  () => searchController.isLoading.value
                      ? load()
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchController.apiPropertyList.length,
                          itemBuilder: (context, index) {
                            print(
                                'searchController.apiPropertyList.length ${searchController.apiPropertyList.length}');
                            return recommendWidget(
                                searchController.apiPropertyList[index]);
                          },
                        ),
                ),
              ),

              // Obx(
              //   () => Visibility(
              //     visible: searchController.apiPropertyList.isNotEmpty,
              //     child: Container(
              //       padding: const EdgeInsets.all(5),
              //       margin: const EdgeInsets.all(20),
              //       decoration: BoxDecoration(
              //           color: Colors.black,
              //           borderRadius: BorderRadius.circular(30)),
              //       child: TextButton(
              //           onPressed: () {
              //             searchController.scrollListener(false);
              //           },
              //           child: Text(
              //             'LOAD MORE',
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontFamily: Constants.fontsFamily,
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.bold),
              //           )),
              //     ),
              //   ),
              // )
            ],
          )),
    );
  }
}
