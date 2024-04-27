import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rentitezy/ticket/model/ticket_details_model.dart';
import '../../../utils/const/app_urls.dart';
import '../../../utils/services/rie_user_api_service.dart';
import '../model/ticket_list_model.dart';

class TicketsController extends GetxController {
  TextEditingController ticketDescription = TextEditingController();
  bool isLoading = false;
  final RIEUserApiService _apiService = RIEUserApiService();
  TicketDetailsModel? ticketDetailsModel;

  List<TicketModel>? ticketsList;

  @override
  void onInit() {
    super.onInit();
    fetchTicketsList();
  }

  Future<void> fetchTicketsList() async {
    String url = AppUrls.getTicket;
    isLoading = true;
    update();
    final response = await _apiService.getApiCallWithURL(endPoint: url);

    final data = response as Map<String, dynamic>;
    if (data['message'].toString().toLowerCase().contains('success')) {
      Iterable iterable = data['data'];
      ticketsList = iterable.map((element) => TicketModel.fromJson(element)).toList();
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
    }
  }
}
