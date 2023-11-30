// ignore_for_file: use_build_context_synchronously

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/model/asset_model.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/const/appConfig.dart';

class HouseholdPage extends StatefulWidget {
  @override
  State<HouseholdPage> createState() => _HouseState();
}

class _HouseState extends State<HouseholdPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void leadsRequest(String assetId) async {
    var sharedPreferences = await _prefs;
    try {
      dynamic result = await createAssetsReqApi(
        sharedPreferences.getString(Constants.userId).toString(),
        assetId,
      );
      if (result['success']) {
        Navigator.pop(context);
        showCustomToast(context, result['message']);
      } else {
        showCustomToast(context, result['message']);
      }
    } on Exception catch (error) {
      Navigator.pop(context);
      showCustomToast(context, error.toString());
    }
  }

  Widget _imageView(String image) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      child: imgLoadWid(
          image.contains('https://')
              ? image
              : AppUrls.imagesRentIsEasyUrl + image,
          'assets/images/app_logo.png',
          170,
          300,
          BoxFit.contain),
    );
  }

  void showBottomAssets(AssetsModel assetsModel) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
                builder: (BuildContext context, setState) =>
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Assets Details',
                                  style: TextStyle(
                                      fontFamily: Constants.fontsFamily,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Center(
                                child: Container(
                              height: 1,
                              width: 40,
                              color: Colors.black,
                            )),
                            height(10),
                            Center(
                              child: SizedBox(
                                height: 150,
                                width: 300,
                                child: CustomScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  slivers: [
                                    SliverPadding(
                                      padding: const EdgeInsets.all(0),
                                      sliver: SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: 170,
                                          child: ScrollPageView(
                                            controller: ScrollPageController(),
                                            delay: const Duration(seconds: 4),
                                            indicatorAlign:
                                                Alignment.bottomCenter,
                                            children: assetsModel.imageList
                                                .map((image) =>
                                                    _imageView(image))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            height(10),
                            title(assetsModel.productName, 18),
                            height(5),
                            title('Brand - ${assetsModel.brand}', 14),
                            height(5),
                            title('Type  - ${assetsModel.type}', 14),
                            height(5),
                            title(Constants.currency + assetsModel.price, 14),
                            height(20),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.primaryColor,
                                    padding: const EdgeInsets.only(
                                        top: 13,
                                        bottom: 13,
                                        left: 30,
                                        right: 30)),
                                child: Text('Request',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontFamily: Constants.fontsFamily,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  leadsRequest(assetsModel.id);
                                },
                              ),
                            ),
                            height(10),
                          ],
                        ))),
          );
        });
  }

  Widget cardIcon(AssetsModel houseHold) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(children: [
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  height(10),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(houseHold.productName,
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            color: Constants.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                  height(10),
                  imgLoadWid(
                      AppUrls.imagesRootUrl + houseHold.imageList.first,
                      'assets/images/app_logo.png',
                      50,
                      50,
                      BoxFit.cover),
                ],
              )),
          Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  showBottomAssets(houseHold);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.42,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Constants.greyLight,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Text(
                    'Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ]),
      ),
    );
  }

  Widget listIcon(List<AssetsModel> assetModelList) {
    return GridView.extent(
      childAspectRatio: (2 / 2),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      maxCrossAxisExtent: 200.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: assetModelList
          .map(
            (data) => GestureDetector(onTap: () {}, child: cardIcon(data)),
          )
          .toList(),
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
            'Household',
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
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              scrollDirection: Axis.vertical,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: FutureBuilder<List<AssetsModel>>(
                      future: getAssetsDetApi(AppUrls.assets),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none) {
                          return loading();
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loading();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasData) {
                            return listIcon(snapshot.data!);
                          } else if (snapshot.hasError) {
                            return Center(
                              child: AppUrls.emptyWidget(
                                  'https://assets6.lottiefiles.com/packages/lf20_ksrabxwb.json'),
                            );
                          }
                        }

                        return loading();
                      }))),
        ],
      ),
    );
  }
}
