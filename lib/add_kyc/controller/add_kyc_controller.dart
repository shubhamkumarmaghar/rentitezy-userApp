import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:rentitezy/add_kyc/model/kyc_document_model.dart';
import 'package:rentitezy/utils/extentions/string_extentions.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../theme/custom_theme.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/const/app_urls.dart';
import '../../utils/const/widgets.dart';
import '../../utils/services/rie_user_api_service.dart';
import '../../utils/view/rie_widgets.dart';
import '../../utils/widgets/cupertiono_image_selector.dart';
import '../../utils/widgets/custom_alert_dialogs.dart';

class AddKycController extends GetxController {
  final int guestCount;
  final String bookingId;
  List<KycDocumentModel> documentModelList = [];
  RIEUserApiService apiService = RIEUserApiService();

  List<String> kycDocumentsList = ['Pan', 'Adhaar', 'Passport', 'Visa'];

  AddKycController({required this.guestCount,required this.bookingId});

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < guestCount; i++) {
      documentModelList.add(KycDocumentModel());
    }
  }

  Future<void> showImagePickerDialog({required int documentIndex}) async {
    if (documentModelList[documentIndex].documentName == null) {
      RIEWidgets.getToast(message: 'Please select document type', color: CustomTheme.errorColor);
      return;
    }
    final imageSource = await cupertinoGalleryBottomSheet(context: Get.context!);
    if (imageSource != null) {
      XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
      if (pickedImage != null) {
        final url = await uploadImage(
            path: pickedImage.path,
            mediaType: pickedImage.name.split('.').last,
            docType: documentModelList[documentIndex].documentName ?? '');
        documentModelList[documentIndex].documentUrl = url;
        update();
      }
    }
  }

  Future<String?> uploadImage({required String docType, required String path, required String mediaType}) async {
    var request = http.MultipartRequest("POST", Uri.parse(AppUrls.uploadFile));
    var pic =
        await http.MultipartFile.fromPath("file", path, filename: 'file', contentType: MediaType("image", mediaType));

    try {
      showProgressLoader(Get.context!);
      request.files.add(pic);
      request.fields.addAll({'type': docType.toLowerCase()});

      request.headers.addAll({'user-auth-token': GetStorage().read(Constants.token)});
      var response = await request.send();
      cancelLoader();
      if (response.statusCode == 200) {
        var responseStream = await http.Response.fromStream(response);
        final result = jsonDecode(responseStream.body) as Map<String, dynamic>;
        return result['data']['url'];
      }
    } catch (e) {
      cancelLoader();
      log('Error while uploading document :: ${e.toString()}');
    }
    return null;
  }

  Future<void> submitKycDocs() async {
    int validGuest = 0;

    for (var data in documentModelList) {
      if (!data.nationality.isNullEmptyOrWhitespace &&
          !data.email.isNullEmptyOrWhitespace &&
          !data.phone.isNullEmptyOrWhitespace &&
          !data.name.isNullEmptyOrWhitespace &&
          !data.documentName.isNullEmptyOrWhitespace &&
          !data.documentUrl.isNullEmptyOrWhitespace) {
        validGuest++;
      }
    }
    if (validGuest == 0) {
     // RIEWidgets.getToast(message: 'Please submit kyc document for atleast 1 Tenant', color: CustomTheme.errorColor);
      //return;
    }
    final response = await apiService.postApiCall(endPoint: AppUrls.uploadTenantsDocs, bodyParams: {
      'bookingId': bookingId,
      'tenants': jsonEncode([{
        'bookingId': bookingId,
        'name':'SuperTester',
        'phone':'1122334455',
        'email':'super@yopmail.com',
        'nationality':'india',
        'proofs':[{
          'type':'adhaar',
          'url':'https://tenant-proofs.s3.ap-south-1.amazonaws.com/test/file_1718444117169.webp'
        }]
      }]),
    });

    // Get.find<DashboardController>().setIndex(0);
    // Get.offAll(() => const DashboardView());

    log('valid guest data $validGuest');
  }

  void deleteDocumentDialog(int index) async {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.white,
          child: Container(
            height: screenHeight * 0.2,
            padding: const EdgeInsets.only(left: 20, right: 15, top: 20),
            child: Column(
              children: [
                Text(
                  'Are you sure to delete this document?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade500),
                ),
                height(0.04),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        documentModelList[index].documentUrl = null;
                        Get.back();
                        update();
                      },
                      child: Container(
                        height: 35,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), color: Constants.primaryColor.withOpacity(0.1)),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Constants.primaryColor),
                        ),
                      ),
                    ),
                    width(0.1),
                    InkWell(
                      onTap: () async {
                        Get.back();
                      },
                      child: Container(
                        height: 35,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomTheme.appThemeContrast.withOpacity(0.1)),
                        child: Text(
                          'Cancel',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.appThemeContrast),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
