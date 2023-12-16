import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/localDb/db_helper.dart';
import 'package:rentitezy/model/fav_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/model/search_listing_model.dart';

import 'package:rentitezy/single_property_details/view/single_properties_screen.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/widgets/fav_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../single_property_details/view/single_properties_screen_new.dart';

class FavWidget extends StatelessWidget {
  FavWidget({super.key, required this.favModel});
  final FavModel favModel;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
 // final controller = Get.put(FavController());
  final dbFavItem = DbHelper.instance;
  @override
  Widget build(BuildContext context) {
    debugPrint('listingId ${favModel.listingId.toString()}');
    return FutureBuilder<FlatModel?>(
       // future: controller.fetchProperties(favModel.listingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return FutureBuilder<List<PropertyModel>>(
                  //future: controller.fetchListingDetails(favModel.listingId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return loading();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return loading();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        PropertyModel data = snapshot.data!.first;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Dismissible(
                              key: Key(data.id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                var sharedPreferences = await prefs;
                                String userId = "guest";
                                if (sharedPreferences
                                    .containsKey(Constants.userId)) {
                                  userId = GetStorage().read(Constants.userId)
                                      .toString();
                                }
                                dbFavItem.deleteFav(data.id.toString(), userId);
                              },
                              background: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE6E6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    SvgPicture.asset("assets/images/trash.svg"),
                                  ],
                                ),
                              ),
                              child: FavListItem(
                                product: data,
                                onView: (view) {
                                  if (view) {
                                    Get.to(()=>  PropertiesDetailsPageNew(
                                      propertyId:
                                      data.id.toString(),
                                    ),arguments: data.id.toString()
                                    );
                                  }
                                },
                              )),
                        );
                      } else if (snapshot.hasError) {
                        return reloadErr(snapshot.error.toString(), (() {}));
                      }
                    }

                    return loading();
                  });
            } else if (snapshot.hasError) {
              return reloadErr(snapshot.error.toString(), (() {}));
            }
          }

          return loading();
        });
  }
}
