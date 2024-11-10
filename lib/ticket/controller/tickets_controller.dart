import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/ticket/model/ticket_details_model.dart';
import '../../../utils/const/app_urls.dart';
import '../../../utils/services/rie_user_api_service.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../login/view/login_screen.dart';
import '../../utils/const/appConfig.dart';
import '../model/ticket_list_model.dart';

class TicketsController extends GetxController {
  TextEditingController ticketDescription = TextEditingController();
  bool isLoading = false;
  final RIEUserApiService _apiService = RIEUserApiService();
  TicketDetailsModel? ticketDetailsModel;
  final bool isLogin = GetStorage().read(Constants.isLogin) ?? false;
  List<TicketModel>? ticketsList;

  @override
  void onInit() {
    super.onInit();
    if (isLogin) {
      fetchTicketsList();
    } else {
      Future.delayed(const Duration(seconds: 0)).then(
        (value) {
          Get.to(() => const LoginScreen(
                canPop: true,
              ))?.then(
            (value) {
              Get.find<DashboardController>().setIndex(0);
            },
          );
        },
      );
    }
  }

  Future<void> fetchTicketsList() async {
    String url = AppUrls.getTicket;
    isLoading = true;
    update();
    final response = await _apiService.getApiCallWithURL(endPoint: url);
    if (response != null) {
      final data = response as Map<String, dynamic>;
      if (data['message'].toString().toLowerCase().contains('success') && data['data'] != null) {
        Iterable iterable = data['data'];
        ticketsList = iterable.map((element) => TicketModel.fromJson(element)).toList();
        isLoading = false;
      } else {
        isLoading = false;
      }
      update();
    }
  }
}
