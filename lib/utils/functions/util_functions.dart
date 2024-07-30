import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_theme.dart';
import '../view/rie_widgets.dart';

String getLocalTime(String? dateTime) {
  if (dateTime == null || dateTime.isEmpty) {
    return 'NA';
  }
  var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime, true);
  var showDate = '${date.toLocal().year}-${handleZero(date.toLocal().month)}-${handleZero(date.toLocal().day)}';
  return showDate;
}
int calculateDateDifference(String dateTime) {
  var date = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime, true);
  DateTime now = DateTime.now();
  int count = DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  return count;
}

String handleZero(int data) {
  return data < 10 ? '0$data' : data.toString();
}
void navigateToNativeMap({required String lat, required String long}) {
  String mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';

  if (Platform.isAndroid) {
    mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  } else if (Platform.isIOS) {
    mapUrl = 'https://maps.apple.com/?q=$lat,$long';
  } else {
    mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  }
  navigateToUrl(mapUrl);
}
Future<void> navigateToUrl(String url) async {
  Uri uri = Uri.parse(url);
  final canLaunch = await canLaunchUrl(uri);

  if (canLaunch) {
    try {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      log('while launching ${e.toString()}');
    }
  }
}
Future<void> openDialPad(String phoneNumber) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    RIEWidgets.getToast(message: 'Can not open dial pad.',color: CustomTheme.errorColor);
  }
}
