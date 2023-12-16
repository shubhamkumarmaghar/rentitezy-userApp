import 'package:get/get.dart';

import '../controller/single_property_details_controller.dart';
class SinglePropertyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SinglePropertyDetailsController>(
          () => SinglePropertyDetailsController(),
    );
  }
}
