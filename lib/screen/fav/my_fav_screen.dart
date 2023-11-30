import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/screen/fav/fav_controller.dart';
import 'package:rentitezy/screen/fav/fav_widget.dart';
import 'package:rentitezy/widgets/const_widget.dart';

class FavScreen extends StatelessWidget {
  FavScreen({super.key});
  final controller = Get.put(FavController());

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
              'My Favorite',
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
        body: Obx(
          () => controller.loadFav.value
              ? SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Constants.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        title(controller.proFetch.value, 14)
                      ]),
                )
              : ListView.builder(
                  itemCount: controller.apiFavPropertyList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    debugPrint(
                        'controller.apiFavPropertyList[index] ${controller.apiFavPropertyList[index].listingId}');
                    return FavWidget(
                      favModel: controller.apiFavPropertyList[index],
                    );
                  },
                ),
        ));
  }
}
