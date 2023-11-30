// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/settings.dart';
import 'package:rentitezy/model/settings_model.dart';
import 'package:rentitezy/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const/appConfig.dart';
import 'home_screen.dart';

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
          position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          sharedPreferences.setString(
              Constants.latitude, position.latitude.toString());
          sharedPreferences.setString(
              Constants.longitude, position.longitude.toString());
        }
      }
    } else {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, //accuracy of the location data
        distanceFilter: 100, //minimum distance (measured in meters) a
      );
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position position) {
        sharedPreferences.setString(
            Constants.latitude, position.latitude.toString());
        sharedPreferences.setString(
            Constants.longitude, position.longitude.toString());
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
          var sharedPreferences = await _prefs;
          if (sharedPreferences.containsKey(Constants.isLogin)) {
            if (sharedPreferences.getBool(Constants.isLogin) != null &&
                sharedPreferences.getBool(Constants.isLogin) != false) {
              if (settings.agreement.isNotEmpty) {
                Settings().init(context, settings);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              } else {
                print('errr');
              }
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
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
        body: Center(
      child: Image.asset(
        'assets/images/splash_logo.png',
        height: 100,
        width: 100,
      ),
    ));
  }
}
