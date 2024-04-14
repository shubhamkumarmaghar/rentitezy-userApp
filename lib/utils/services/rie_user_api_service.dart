import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../login/view/login_screen.dart';
import '../const/appConfig.dart';
import '../const/app_urls.dart';
import '../view/rie_widgets.dart';

class RIEUserApiService {
  final String _baseURL = AppUrls.baseUrl;
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  String? registeredToken;

  Future<String?> _getRegisteredToken() async {
    registeredToken = GetStorage().read(Constants.token);
    return registeredToken;
  }

  Future<Map<String, String>> get getHeaders async {
    return {'user-auth-token': (registeredToken ?? await _getRegisteredToken()).toString()};
  }

  Future<dynamic> getApiCall({
    required String endPoint,
  }) async {
    log('URL :: $endPoint  -- ${await getHeaders}');
    try {
      final response = await http.get(Uri.https(_baseURL, endPoint), headers: await getHeaders);

      return await _response(
        response,
        url: Uri.https(_baseURL, endPoint).toString(),
      );
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return null;
  }

  Future<dynamic> getApiCallWithQueryParams({
    required String endPoint,
    required Map<String, dynamic> queryParams,
  }) async {
    log('URL :: $endPoint ---- QueryParams :: ${queryParams.toString()} -- ${await getHeaders} ');
    try {
      final response = await http.get(
        Uri.https(endPoint, '/aa/ticket?', queryParams),
        headers: await getHeaders,
      );

      return await _response(response, url: Uri.https(endPoint).toString());
    } on SocketException {
      log('Socket Exception Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'message': 'failure'};
  }

  Future<dynamic> getApiCallWithURL({
    required String endPoint,
  }) async {
    log('URL :: $endPoint , Token :: ${await getHeaders}');

    try {
      final response = await http.get(
          Uri.parse(
            endPoint,
          ),
          headers: await getHeaders);
      return await _response(
        response,
        url: Uri.parse(endPoint).toString(),
      );
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'message': 'failure'};
  }

  Future<dynamic> postApiCall({
    required String endPoint,
    required Map<String, dynamic> bodyParams,
    bool fromLogin = false,
  }) async {
    log('URL :: $endPoint ---- Model :: ${bodyParams.toString()} -- ${fromLogin ? '' : await getHeaders}');

    try {
      final response = await http.post(
        Uri.parse(endPoint),
        body: bodyParams,
        headers: fromLogin ? {} : await getHeaders,
      );
      return await _response(response,
          url: Uri.parse(
            endPoint,
          ).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'message': 'failure'};
  }

  /*
  Future<dynamic> postApiCallFormData(
      {required String endPoint, required FormData formData}) async {
    log('URL :: $_baseURL/$endPoint ---- Model :: ${formData.toString()} -- ${await getHeaders}');

    try {
      Dio dio = Dio();
      final response = await dio.post(Uri.https(_baseURL, endPoint).toString(),
          options: Options(headers: await getHeaders), data: formData);
      return response.statusCode == 200
          ? {'msg': 'success'}
          : {'msg': 'failure'};
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'msg': 'failure'};
  }
  */
  Future<dynamic> putApiCall({
    required String endPoint,
    required Map<String, dynamic> bodyParams,
  }) async {
    log('URL :: $endPoint ---- Model :: ${bodyParams.toString()} -- ${await getHeaders}');
    try {
      final response = await http.put(
        Uri.parse(endPoint),
        headers: await getHeaders,
        body: bodyParams,
      );

      return await _response(
        response,
        url: Uri.parse(endPoint).toString(),
      );
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'message': 'failure'};
  }

  dynamic deleteApiCall({required String endPoint}) async {
    try {
      final response = await http.delete(
        Uri.https(_baseURL, endPoint),
        headers: await getHeaders,
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          log('Logout Res ::  ${response.body}');
          return true;
        }
      }
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'message': 'failure'};
  }

  dynamic _response(
    http.Response response, {
    String? url,
  }) async {
    log('Status Code :: ${response.statusCode} -- $url    ${response.body}');
    switch (response.statusCode) {
      case 200:
        return response.body.isNotEmpty ? json.decode(response.body) : {'message': 'failure'};
      case 400:
        return _getErrorResponse(json.decode(response.body));
      case 401:
        return _getErrorResponse(json.decode(response.body));
      case 402:
        return _getErrorResponse(json.decode(response.body));
      case 403:
        return _getErrorResponse(json.decode(response.body));
      case 404:
        return _getErrorResponse(json.decode(response.body));
      case 405:
        return _getErrorResponse(json.decode(response.body));
      case 415:
        return _getErrorResponse(json.decode(response.body));
      case 500:
        return _getErrorResponse(json.decode(response.body));
      case 501:
        return _getErrorResponse(json.decode(response.body));
      case 502:
        return _getErrorResponse(json.decode(response.body));
      default:
        return _getErrorResponse(json.decode(response.body));
    }
  }

  Map<String, dynamic> _getErrorResponse(decode) {
    final error = decode as Map<String, dynamic>;
    log(error.toString());
    RIEWidgets.getToast(message: error['message'] ?? 'failure', color: Color(0xffFF0000));
    return {'message': 'failure ' + error['message']};
  }

  Future<dynamic> getApiCallWithQueryParamsWithHeaders(
      {required String endPoint,
      required Map<String, dynamic> queryParams,
      required Map<String, String> headers,
      bool fromLogin = false,
      required BuildContext context}) async {
    log('URL :: $_baseURL$endPoint ---- QueryParams :: ${queryParams.toString()} -- Auth(header) ---${headers} ');

    try {
      final response = await http.get(Uri.https(_baseURL, endPoint, queryParams), headers: headers);

      return await _response(response, url: Uri.https(_baseURL, endPoint).toString());
    } on SocketException {
      log('SocketException Happened');
    } catch (e) {
      log('Error : ${e.toString()}');
    }
    return {'message': 'failure'};
  }
}
