import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentitezy/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

   Future<void> alertDialog(
      BuildContext context, String title, String subttitle) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                fontFamily: Constants.fontsFamily,
              )),
          content: Text(subttitle,
              style: TextStyle(
                fontFamily: Constants.fontsFamily,
              )),
          actions: [
            CupertinoDialogAction(
                child: Text("YES",
                    style: TextStyle(
                      fontFamily: Constants.fontsFamily,
                    )),
                onPressed: () async {
                  executeLogOut(context);
                }),
            CupertinoDialogAction(
              child: Text("NO",
                  style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

Map<String, String> amenitiesICons = {
  'Security Guard': 'security_guard',
  'Terrance': 'terrance',
  'Laundry Service': 'laundry',
  'Elevator Lift': 'lift',
  'Balcony': 'balcony',
  'Electricity': 'electricity',
  'Water Facility': 'water',
  'Emergency Exit': 'emergency_exit',
  'CCTV': 'security',
  'Wi-Fi': 'wifi',
  'Free Parking In The Area': 'parking',
  'Air Conditioning': 'rain_water',
};

String? mapIcon(String petName) {
  if (amenitiesICons.isNotEmpty) {
    for (final mapEntry in amenitiesICons.entries) {
      final key = mapEntry.key;
      final value = mapEntry.value;
      if (key == petName.trim()) {
        return value;
      }
    }
  }
  return null;
}

class Constants {
  static String fontsFamily = 'Kanit';
  static const usernamekey = "usernamekey";
  static const profileUrl = "profileUrl";
  static const userId = "userId";
  static const auth_key = "auth_key";
  static const token = "token";
  static const isAgree = "isAgree";
  static const tenantId = "tenantId";
  static const isLogin = "isLogin";
  static const emailkey = "emailkey";
  static const phonekey = "phonekey";
  static const isTenant = "isTenant";
  static const currency = 'Rs';
  static const latitude = "latitude";
  static const longitude = "longitude";

  static String tempAgree =
      'RESIDENTIAL RENTAL AGREEMENT This agreement made at [City, State] on this [Date, Month, Year] between [Landlord Name], residing at [Landlord Address Line 1, Address Line 2, City, State, Pin Code] hereinafter referred to as the `LESSOR` of the One Part AND [Tenant Name], residing at  [Tenant Address Line 1, Address Line 2, City, State, Pin Code] hereinafter referred to as the `LESSEE` of the other Part;WHEREAS the Lessor is the lawful owner of, and otherwise well sufficiently entitled to [Lease Property Address Line 1, Address Line 2, City, State, Pin Code] falling in the category, [Independent House / Apartment / Farm House / Residential Property] and comprising of [X Bedrooms], [X Bathrooms], [X Carparks] with an extent of [XXXX Square Feet] hereinafter referred to as the `said premises`; AND WHEREAS at the request of the Lessee, the Lessor has agreed to let the said premises to the tenant for a term of [Lease Term] commencing from [Lease Start Date] in the manner hereinafter appearing. RESIDENTIAL RENTAL AGREEMENT This agreement made at [City, State] on this [Date, Month, Year] between [Landlord Name], residing at [Landlord Address Line 1, Address Line 2, City, State, Pin Code] hereinafter referred to as the `LESSOR` of the One Part AND [Tenant Name], residing at  [Tenant Address Line 1, Address Line 2, City, State, Pin Code] hereinafter referred to as the `LESSEE` of the other Part;WHEREAS the Lessor is the lawful owner of, and otherwise well sufficiently entitled to [Lease Property Address Line 1, Address Line 2, City, State, Pin Code] falling in the category, [Independent House / Apartment / Farm House / Residential Property] and comprising of [X Bedrooms], [X Bathrooms], [X Carparks] with an extent of [XXXX Square Feet] hereinafter referred to as the `said premises`; AND WHEREAS at the request of the Lessee, the Lessor has agreed to let the said premises to the tenant for a term of [Lease Term] commencing from [Lease Start Date] in the manner hereinafter appearing.';

  static Color hint = getColorFromHex("CDCDCD");
  static Color lightBg = getColorFromHex("EFEFF4");
  static Color lightSearch = const Color.fromARGB(255, 241, 240, 240);
  static Color textColor = getColorFromHex('99000000');
  static Color bgNearProperties = getColorFromHex('D9D9D9');
  static Color black = getColorFromHex('000000');
  static Color primaryColor = getColorFromHex('0075FF');
  static Color greyLight = getColorFromHex('CDCDCD');
  static Color navBg = getColorFromHex('D9D9D9');
  static Color green = getColorFromHex('26C000');
  static Color getColorFromHex(String colors) {
    var color = "0xFF$colors";
    try {
      return Color(int.parse(color));
    } catch (e) {
      return const Color(0xFFFFFFFF);
    }
  }
}

executeLogOut(BuildContext context) async {
  final SharedPreferences prefs = await _prefs;
  prefs.setBool(Constants.isLogin, false);
  prefs.setString(Constants.usernamekey, "guest");
  prefs.setString(Constants.userId, "guest");
  prefs.setString(Constants.phonekey, "guest");
  prefs.setString(Constants.emailkey, "guest");
  prefs.setBool(Constants.isTenant, false);

  if (context.mounted) {
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}

void showSnackBar(BuildContext context, String result) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(result,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: Constants.fontsFamily,
        )),
    duration: const Duration(seconds: 2),
  ));
}

void showCustomToast(
  BuildContext context,
  String texts,
) {
  Fluttertoast.showToast(
    msg: texts,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

bool validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

String convertToAgo(String dateTime) {
  DateTime input = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateTime, true);
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
  } else {
    return 'just now';
  }
}

getFormatedDate(dateVal) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var inputDate = inputFormat.parse(dateVal);
  var outputFormat = DateFormat.yMMM().format(inputDate);
  return outputFormat;
}

addMonth(dateVal) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var inputDate = inputFormat.parse(dateVal);
  var tempInDate = DateTime(inputDate.year, inputDate.month + 1, inputDate.day);
  String changeFormat1 = tempInDate.toString().split('-')[1];
  var dateOne =
      '${tempInDate.toString().split('-')[0]}-$changeFormat1-01T00:00:00.000Z';
  var inputFive = inputFormat.parse(dateOne);
  DateTime addFive = inputFive.add(const Duration(days: 4));
  var outputFormat = DateFormat.yMMMd().format(addFive);
  return outputFormat;
}

curentMonth(dateVal) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var inputDate = inputFormat.parse(dateVal);
  // var tempInDate = DateTime(inputDate.year, inputDate.month - 1, inputDate.day);
  String changeFormat1 = inputDate.toString().split('-')[1];
  var dateOne =
      '${inputDate.toString().split('-')[0]}-$changeFormat1-01T00:00:00.000Z';
  var inputFive = inputFormat.parse(dateOne);
  DateTime addFive = inputFive.add(const Duration(days: 4));
  var outputFormat = DateFormat.yMMMd().format(addFive);
  return outputFormat;
}

lastMonth(dateVal) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var inputDate = inputFormat.parse(dateVal);
  var tempInDate = DateTime(inputDate.year, inputDate.month - 1, inputDate.day);
  String changeFormat1 = tempInDate.toString().split('-')[1];
  var dateOne =
      '${tempInDate.toString().split('-')[0]}-$changeFormat1-01T00:00:00.000Z';
  var inputFive = inputFormat.parse(dateOne);
  DateTime addFive = inputFive.add(const Duration(days: 4));
  var outputFormat = DateFormat.yMMMd().format(addFive);
  return outputFormat;
}

nextPayDate(dateVal) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var inputDate = inputFormat.parse(dateVal);
  var tempInDate = DateTime(inputDate.year, inputDate.month + 1, inputDate.day);
  String changeFormat1 = tempInDate.toString().split('-')[1];
  var dateOne =
      '${tempInDate.toString().split('-')[0]}-$changeFormat1-01T00:00:00.000Z';
  var inputFive = inputFormat.parse(dateOne);
  DateTime addFive = inputFive.add(const Duration(days: 4));
  var outputFormat = DateFormat.yMMMd().format(addFive);
  return outputFormat;
}

getDayCount(dateVal) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  DateTime dateCurrent = DateTime.now();
  var inputDate = inputFormat.parse(dateVal);
  var tempInDate = DateTime(inputDate.year, inputDate.month + 1, inputDate.day);
  String changeFormat1 = tempInDate.toString().split('-')[1];
  var dateOne =
      '${tempInDate.toString().split('-')[0]}-$changeFormat1-01T00:00:00.000Z';
  var inputFive = inputFormat.parse(dateOne);
  DateTime addFive = inputFive.add(const Duration(days: 4));
  return (addFive.difference(dateCurrent).inDays <= 0)
      ? '00'
      : (addFive.difference(dateCurrent).inDays < 10)
          ? ('0${addFive.difference(dateCurrent).inDays}')
          : (addFive.difference(dateCurrent).inDays).toString();
}

openDialPad(String phoneNumber, BuildContext context) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    showSnackBar(context, 'Can not open dial pad.');
  }
}
