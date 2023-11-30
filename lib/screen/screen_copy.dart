import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/const/appConfig.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _MyProfileState();
}

class _MyProfileState extends State<ProfileScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool isTenant = false;

  @override
  void initState() {
    fetchTenant();
    super.initState();
  }

  void fetchTenant() async {
    SharedPreferences sharedPreferences = await prefs;
    if (sharedPreferences.containsKey(Constants.isTenant)) {
      if (sharedPreferences.getBool(Constants.isTenant) != null) {
        isTenant = sharedPreferences.getBool(Constants.isTenant)!;
      } else {
        isTenant = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Constants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'My Profile',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                ),
              ],
            ))
      ]),
    );
  }
}
