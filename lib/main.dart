import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'dashboard/controller/dashboard_controller.dart';
import 'screen/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
  GetStorage.init();
  Get.put(DashboardController());
  _portraitModeOnly();
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppUrls.appName,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9), child: child ?? const Text(''));
      },

      theme: ThemeData(
        useMaterial3: false,
       // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // colorScheme: ColorScheme.fromSwatch(primarySwatch:Colors.blue ),
        textTheme: GoogleFonts.kanitTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: CustomTheme.white),
        progressIndicatorTheme:  ProgressIndicatorThemeData(
          color: Constants.primaryColor,
        ),
        //primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Constants.primaryColor,
        ),
      ),
      //home: const ForgotScreen(),
      home: const SplashScreenPage(),
      //home: const ProfileScreenNew(),
    );
  }
}
