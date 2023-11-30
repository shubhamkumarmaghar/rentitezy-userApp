import 'package:flutter/material.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/widgets/const_widget.dart';
import 'package:rentitezy/model/property_model.dart';

import '../utils/const/app_urls.dart';

class FavListItem extends StatefulWidget {
  final PropertyModel product;
  final Function(bool) onView;

  const FavListItem({Key? key, required this.product, required this.onView})
      : super(key: key);

  @override
  State<FavListItem> createState() => CartListItemState();
}

class CartListItemState extends State<FavListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Constants.greyLight,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Constants.greyLight,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(7),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.product.images.first.contains('https://')
                                    ? widget.product.images.first
                                    : AppUrls.imagesRootUrl +
                                        widget.product.images.first),
                            fit: BoxFit.cover)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomText(
                                widget.product.name,
                                Constants.textColor,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                17),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 15),
                              child: Text(
                                widget.product.facility,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: Constants.fontsFamily),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: getCustomText(
                                        '${Constants.currency}.${widget.product.price}',
                                        Constants.textColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w500,
                                        15),
                                  ),

                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: ElevatedButton(
              onPressed: () {
                widget.onView(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
              ),
              child: Text(
                'VIEW',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
