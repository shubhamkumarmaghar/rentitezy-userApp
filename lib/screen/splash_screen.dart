import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/image_consts.dart';
import 'package:rentitezy/utils/const/settings.dart';
import 'package:rentitezy/model/settings_model.dart';
import 'package:rentitezy/login/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard/controller/dashboard_controller.dart';
import '../utils/const/appConfig.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreenPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late LocationPermission permission;
  late Position position;
  late StreamSubscription<Position> positionStream;
  bool serviceStatus = false;

  @override
  void initState() {
    goToSplash();
    super.initState();
  }

  void getBackgroundLatLong() async {
    var sharedPreferences = await _prefs;
    if (!serviceStatus) {
      serviceStatus = await Geolocator.isLocationServiceEnabled();
      if (serviceStatus) {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
          } else if (permission == LocationPermission.deniedForever) {
          } else {
            serviceStatus = true;
          }
        } else {
          serviceStatus = true;
        }

        if (serviceStatus) {
          position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          GetStorage().write(Constants.latitude, position.latitude.toString());
          GetStorage().write(Constants.longitude, position.longitude.toString());
        }
      }
    } else {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, //accuracy of the location data
        distanceFilter: 100, //minimum distance (measured in meters) a
      );
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
        GetStorage().write(Constants.latitude, position.latitude.toString());
        GetStorage().write(Constants.longitude, position.longitude.toString());
      });
      if (kDebugMode) {
        print(positionStream);
      }
    }
  }

  void goToSplash() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      try {
        getBackgroundLatLong();
        SettingsModel settings = await fetchSetting();
        Timer(const Duration(seconds: 3), () async {
          if (GetStorage().read(Constants.isLogin) != null && GetStorage().read(Constants.isLogin) != false) {
            if (settings.agreement.isNotEmpty) {
              Settings().init(context, settings);
              Get.find<DashboardController>().setIndex(0);
              Get.offAll(() => const DashboardView());
            }
          } else {
            Get.offAll(() => const LoginScreen());
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            appLogo,
            height: 200,
            width: 200,
          ),
        ));
  }
}
