import 'package:get/get.dart';

class DashboardController extends GetxController {
  int selectedIndex = 0;

  void setIndex(int index) {
    selectedIndex = index;
    update();
  }
}
