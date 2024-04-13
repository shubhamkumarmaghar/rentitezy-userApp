import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/const/app_urls.dart';
import '../../../utils/services/rie_user_api_service.dart';
import '../../utils/const/appConfig.dart';
import '../model/TicketListModel.dart';
import '../model/ticketModel.dart';
import '../model/ticket_config_model.dart';

class AllTicketController extends GetxController {
  TextEditingController ticketDescription = TextEditingController();
  String? bookingId;
  bool isLoading = false;
  String? selectFlat = 'Select Flat';
  final RIEUserApiService _apiService = RIEUserApiService();
  TicketListModel getAllDetails = TicketListModel();
  TicketConfigModel ticketConfigModel = TicketConfigModel();
  TicketModel getSingleTicketDetails = TicketModel();
  List<String>? ticketCategoriesList;
  List<String>? ticketStatusList;
  List<Properties>? ticketPropertiesList;
  Properties? selectedProperty;

  String? selectedCategory;

  String? selectedStatus;

  AllTicketController({this.bookingId});

  @override
  void onInit() {
    super.onInit();
    getData();
    log('booking id :: $bookingId');
  }

  void getData() async {
    await fetchTicketListDetails();
    await fetchTicketConfigListDetails();
  }

  Future<void> fetchTicketListDetails() async {
    String url = AppUrls.getTicket;
    isLoading = true;
    final response = await _apiService.getApiCallWithURL(endPoint: url);

    final data = response as Map<String, dynamic>;
    if (data['message'].toString().toLowerCase().contains('success')) {
      getAllDetails = TicketListModel.fromJson(data);
      update();
      isLoading = false;
    } else {
      getAllDetails = TicketListModel(
        message: 'failure',
      );
      isLoading = false;
      update();
    }
  }

  Future<void> fetchTicketConfigListDetails() async {
    String url = AppUrls.ticket;
    isLoading = true;
    final response = await _apiService.getApiCallWithURL(endPoint: url);

    final data = response as Map<String, dynamic>;
    if (data['message'].toString().toLowerCase().contains('success')) {
      ticketConfigModel = TicketConfigModel.fromJson(data);
      ticketCategoriesList = ticketConfigModel.data?.categories ?? [];
      update();
      isLoading = false;
      ticketStatusList = ticketConfigModel.data?.status ?? [];
      update();
    } else {
      ticketConfigModel = TicketConfigModel(
        message: 'failure',
      );
      isLoading = false;
      update();
    }
  }

  Future<int> createTicket({
    //location="+location+"&prop_type="+prop_type+"&added_on="+added_on+"&assign_to="+assign_to+"&contact_details="+contact_details+"&lead_status=Active"+"&origin="+area;
    required String bookingId,
    required String ticketCate,
    required String ticketDesc,
    required String ticketStat,
  }) async {
    String url = AppUrls.ticket;
    final response = await _apiService.postApiCall(endPoint: url, bodyParams: {
      "bookingId": bookingId,
      "category": ticketCate,
      "description": ticketDesc,
      "status": ticketStat,
    });
    final data = response as Map<String, dynamic>;

    return data['message'].toString().toLowerCase().contains('failure') ? 404 : 200;
  }

  Future<int> updateTicket({
    //location="+location+"&prop_type="+prop_type+"&added_on="+added_on+"&assign_to="+assign_to+"&contact_details="+contact_details+"&lead_status=Active"+"&origin="+area;
    required String flatId,
    required String ticketCate,
    required String ticketDesc,
    required String ticketStat,
    required String ticketId,
  }) async {
    String url = AppUrls.ticket;
    final response = await _apiService.putApiCall(endPoint: url, bodyParams: {
      "id": ticketId,
      "unitId": flatId,
      "category": ticketCate,
      "description": ticketDesc,
      "status": ticketStat,
    });
    final data = response as Map<String, dynamic>;

    return data['message'].toString().toLowerCase().contains('success') ? 200 : 404;
  }

  Future<void> fetchTicketDetails(String ticketId) async {
    String url = AppUrls.ticket;
    url = '$url?id=$ticketId';
    isLoading = true;
    final response = await _apiService.getApiCallWithURL(
      endPoint: url,
    );
    // final data = response as Map<String, dynamic>;
    if (response['message'].toString().toLowerCase().contains('success')) {
      getSingleTicketDetails = TicketModel.fromJson(response['data']);
      update();
      isLoading = false;
    } else {
      getSingleTicketDetails = TicketModel(
        message: 'failure',
      );
      isLoading = false;
      update();
    }
  }
}
