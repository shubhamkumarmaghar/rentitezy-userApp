import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/ticket/model/ticket_details_model.dart';
import 'package:rentitezy/utils/services/rie_user_api_service.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import 'package:rentitezy/widgets/custom_alert_dialogs.dart';
import '../../utils/const/app_urls.dart';

class CreateTicketScreenController extends GetxController {
  List<String> ticketCategoriesList = [];
  List<String> ticketStatusList = [];
  bool isLoading = false;
  final RIEUserApiService _apiService = RIEUserApiService();
  final String bookingId;
  String? selectedCategory = 'Select Category';
  String? selectedStatus = 'Select Status';
  final ticketDescriptionController = TextEditingController();

  CreateTicketScreenController({required this.bookingId});

  @override
  void onInit() {
    super.onInit();
    fetchTicketConfigListDetails();
  }

  void updateTicketStatus(String? status) {
    selectedStatus = status?.capitalizeFirst;
    update();
  }

  void updateTicketCategory(String? category) {
    selectedCategory = category?.capitalizeFirst;
    update();
  }

  Future<void> fetchTicketConfigListDetails() async {
    String url = AppUrls.ticket;
    isLoading = true;
    final response = await _apiService.getApiCallWithURL(endPoint: url);

    final data = response as Map<String, dynamic>;
    isLoading = false;
    if (data['message'].toString().toLowerCase().contains('success')) {
      final configModel = TicketDetailsModel.fromJson(data['data']);
      ticketCategoriesList = configModel.categories ?? [];
      ticketStatusList = configModel.status ?? [];
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  void onCategoryChange(String? category) {
    selectedCategory = category;
    update();
  }

  void onStatusChange(String? status) {
    selectedStatus = status;
    update();
  }

  Future<void> createTicket({
    required String ticketCate,
    required String ticketDesc,
    required String ticketStat,
  }) async {
    showProgressLoader(Get.context!);
    String url = AppUrls.ticket;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "bookingId": bookingId,
      "category": ticketCate,
      "description": ticketDesc,
      "status": ticketStat.toLowerCase(),
    });
    cancelLoader();

    final data = response as Map<String, dynamic>;
    if (!data['message'].toString().toLowerCase().contains('failure')) {
      RIEWidgets.getToast(message: 'Ticket Created Successfully.', color: CustomTheme.myFavColor);
      Get.find<DashboardController>().setIndex(0);
      Get.offAll(() => const DashboardView());
    } else {
      RIEWidgets.getToast(message: 'Something went wrong!', color: CustomTheme.errorColor);
    }
  }
}
