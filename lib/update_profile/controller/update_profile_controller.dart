import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';
import 'package:http/http.dart' as http;
import '../../../dashboard/controller/dashboard_controller.dart';
import '../../../utils/const/appConfig.dart';
import '../../../utils/const/app_urls.dart';
import 'package:http_parser/http_parser.dart';

import '../../utils/widgets/custom_alert_dialogs.dart';

class UpdateProfileController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RIEUserApiService userApiService = RIEUserApiService();
  final storage = GetStorage();
  String? imagePath;

  String userId = '';

  @override
  void onInit() {
    super.onInit();
    getUserDataFromLocalStorage();
  }

  void getUserDataFromLocalStorage() async {
    if (storage.read(Constants.userId) != null && storage.read(Constants.userId) != '') {
      userId = storage.read(Constants.userId).toString();
    } else {
      userId = 'guest';
    }
    firstNameController.text = storage.read(Constants.firstName) ??'';
    lastNameController.text = storage.read(Constants.lastName) ??'';
    emailController.text = storage.read(Constants.emailkey) ??'';
    phoneController.text = storage.read(Constants.phonekey) ??'';
    imagePath = storage.read(Constants.profileUrl)??'';
    update();
  }

  void updateProfileImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await uploadImage(pickedImage.path, pickedImage.name.split('.').last);
    }
  }

  Future<void> uploadImage(String path, String mediaType) async {
    var request = http.MultipartRequest("PUT", Uri.parse(AppUrls.updateProfileImageUrl));
    var pic = await http.MultipartFile.fromPath("image", path,
        filename: 'profileImage', contentType: MediaType("image", mediaType));

    try {
      showProgressLoader(Get.context!);
      request.files.add(pic);
      request.headers.addAll({'user-auth-token': GetStorage().read(Constants.token)});
      var response = await request.send();
      cancelLoader();
      if (response.statusCode == 200) {
        var responseStream = await http.Response.fromStream(response);
        final result = jsonDecode(responseStream.body) as Map<String, dynamic>;
        imagePath = result['url'];
        update();
      }
    } catch (e) {
      cancelLoader();
      log('Error while uploading profile image :: ${e.toString()}');
    }
  }

  void updateUserData() async {
    showProgressLoader(Get.context!);
    final response = await userApiService.putApiCall(endPoint: AppUrls.updateProfileUrl, bodyParams: {
      'id': userId,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'imageUrl': imagePath
    });

    if (!response['message'].toString().toLowerCase().contains('failure')) {
      await storage.write(Constants.firstName, response['data']['firstName']);
      await storage.write(Constants.lastName, response['data']['lastName']);
      await storage.write(Constants.phonekey, response['data']['phone']);
      await storage.write(Constants.emailkey, response['data']['email']);
      await storage.write(Constants.profileUrl, response['data']['image']);
      await storage.write(Constants.userId, response['data']['id']);
      await storage.write(Constants.token, response['data']['authToken']);
      cancelLoader();
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(()=>const DashboardView());
    }else{
      cancelLoader();
    }
  }
}
