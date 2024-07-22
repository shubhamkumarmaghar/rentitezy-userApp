import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/login/view/login_screen.dart';
import '../../theme/custom_theme.dart';
import '../const/appConfig.dart';
import '../const/app_urls.dart';
import '../view/rie_widgets.dart';

class RIEUserApiService {
  final String _baseURL = AppUrls.baseUrl;
  String? registeredToken;

  Future<String?> _getRegisteredToken() async {
    registeredToken = GetStorage().read(Constants.token);
    return registeredToken;
  }

  Future<Map<String, String>>  getHeaders({bool canJsonEncode=false}) async {
    return canJsonEncode?{
      'user-auth-token': (registeredToken ?? await _getRegisteredToken()).toString(),
      'Content-Type': 'application/json'
    }:{
      'user-auth-token': (registeredToken ?? await _getRegisteredToken()).toString(),
    };
  }

  Future<dynamic> getApiCall({required String endPoint, Map<String, String>? headers}) async {
    log('URL :: $endPoint  -- ${headers ?? await getHeaders()}');
    try {
      final response = await http.get(Uri.parse(endPoint), headers: headers ?? await getHeaders());

      return await _response(
        response,
        url: Uri.parse(
          endPoint,
        ).toString(),
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
    log('URL :: $endPoint ---- QueryParams :: ${queryParams.toString()} -- ${await getHeaders()} ');
    try {
      final response = await http.get(
        Uri.https(endPoint, '/aa/ticket?', queryParams),
        headers: await getHeaders(),
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
    log('URL :: $endPoint , Token :: ${await getHeaders()}');

    try {
      final response = await http.get(
          Uri.parse(
            endPoint,
          ),
          headers: await getHeaders());
      return await _response(
        response,
        url: Uri.parse(endPoint).path,
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
    bool canJsonEncode = false,
    bool fromLogin = false,
  }) async {
    log('URL :: $endPoint ---- Model :: ${bodyParams.toString()} -- ${fromLogin ? '' : await getHeaders(canJsonEncode: canJsonEncode)}');

    try {
      final response = await http.post(
        Uri.parse(endPoint),
        body: canJsonEncode ? jsonEncode(bodyParams) : bodyParams,
        headers: fromLogin ? {} : await getHeaders(canJsonEncode: canJsonEncode),
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

  Future<dynamic> putApiCall({
    required String endPoint,
    required Map<String, dynamic> bodyParams,
  }) async {
    log('URL :: $endPoint ---- Model :: ${bodyParams.toString()} -- ${await getHeaders()}');
    try {
      final response = await http.put(
        Uri.parse(endPoint),
        headers: await getHeaders(),
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

  Future<dynamic> getApiCallWithQueryParamsWithHeaders(
      {required String endPoint,
      required Map<String, dynamic> queryParams,
      required Map<String, String> headers,
      bool fromLogin = false,
      required BuildContext context}) async {
    log('URL :: $_baseURL$endPoint ---- QueryParams :: ${queryParams.toString()} -- Auth(header) ---$headers ');

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

  dynamic deleteApiCall({required String endPoint}) async {
    try {
      final response = await http.delete(
        Uri.https(_baseURL, endPoint),
        headers: await getHeaders(),
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
        RIEWidgets.getToast(message: 'Unauthorized access.Please login to authorize.', color: CustomTheme.errorColor);
        Get.offAll(() => const LoginScreen());
      //return _getErrorResponse(json.decode(response.body));
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
    RIEWidgets.getToast(message: 'Error : ${error['message']}', color: const Color(0xffFF0000));
    return {'message': 'failure ${error['message']}'};
  }
}
