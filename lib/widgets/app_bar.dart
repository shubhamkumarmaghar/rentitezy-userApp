// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import '../utils/const/app_urls.dart';
import '../utils/const/widgets.dart';
import 'const_widget.dart';

Widget appBarWidget(String title, String image, Function() function) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Text("Hi, ",
                  style: TextStyle(
                      color: Constants.black,
                      fontSize: 19,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.bold)),
            ),
            WidgetSpan(
              child: Text(title,
                  style: TextStyle(
                      color: Constants.black,
                      fontSize: 19,
                      fontFamily: Constants.fontsFamily,
                      fontWeight: FontWeight.normal)),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: function,
        child: imgLoadWid( image,
            'assets/images/user_vec.png', 40, 40, BoxFit.contain),
      ),
    ],
  );
}

// Widget appBarMainWidget(String title, String image, Function() function) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Row(
//         children: [
//           GestureDetector(
//             onTap: function,
//             child: CachedNetworkImage(
//                 imageUrl: image.contains('http://')
//                     ? image
//                     : AppConfig.imagesRentIsEasyUrl + image,
//                 imageBuilder: (context, imageProvider) => Container(
//                       width: 45,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                             image: imageProvider, fit: BoxFit.cover),
//                       ),
//                     ),
//                 placeholder: (context, url) => loading(),
//                 errorWidget: (context, url, error) => Container(
//                       width: 45,
//                       height: 45,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                             image: AssetImage('assets/images/user_vec.png'),
//                             fit: BoxFit.cover),
//                       ),
//                     )),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: screenWidth * 0.03),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Hi, ",
//                     style: TextStyle(
//                         color: Constants.black,
//                         fontSize: 14,
//                         fontFamily: Constants.fontsFamily,
//                         fontWeight: FontWeight.bold)),
//                 Text(title,
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                         fontFamily: Constants.fontsFamily,
//                         fontWeight: FontWeight.normal))
//               ],
//             ),
//           )
//         ],
//       ),
//       const Spacer(),
//       Row(
//         children: [
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.exit_to_app,
//                 size: 20,
//                 color: Colors.black,
//               )),
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.exit_to_app,
//                 size: 20,
//                 color: Colors.black,
//               )),
//         ],
//       )
//     ],
//   );
// }
