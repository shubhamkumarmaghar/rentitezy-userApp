import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/payment_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/model/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/rie_user_api_service.dart';
import 'app_urls.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String? registeredToken;

Future<String?> _getRegisteredToken() async {
  registeredToken = GetStorage().read(Constants.token);
  // registeredToken = await GetStorage().read(rms_registeredUserToken);
  return registeredToken;
}

Future<Map<String, String>> get getHeaders async {

  return {
    'user-auth-token':
    (registeredToken ?? await _getRegisteredToken()).toString()
  };
}




Future<List<PropertyModel>> allPropertyGet() async {
  var sharedPreferences = await _prefs;
  final response = await http.get(
    Uri.parse(AppUrls.property),
    headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
  );

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List).map((stock) => PropertyModel.fromJson(stock)).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Pro');
  }
}

Future<List<PropertyModel>> searchProperty() async {
  var sharedPreferences = await _prefs;
  final response = await http.get(
    Uri.parse(AppUrls.property),
    headers: <String, String>{"Auth-Token": GetStorage().read(Constants.token).toString()},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List).map((stock) => PropertyModel.fromJson(stock)).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Pro');
  }
}

Future<dynamic> createLeadsApi(String name, String phone, String address, String zipcode, String facility,
    String moveIn, String priceRange, String userId, String propertyId, String bhkType) async {
  var sharedPreferences = await _prefs;
  final response = await http.post(Uri.parse(AppUrls.leads),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Auth-Token": GetStorage().read(Constants.token).toString()
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "phone": phone,
        "address": address,
        "zipcode": zipcode,
        "facility": facility,
        "moveIn": moveIn,
        "priceRange": priceRange,
        "userId": userId,
        "propertyId": propertyId,
        "bhkType": bhkType
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}
Future<SettingsModel> fetchSetting() async {
  final response = await http.get(
    Uri.parse(AppUrls.settings),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    if (body['success']) {
      return SettingsModel.fromJson(jsonDecode((body["data"] as List)[0]['value']));
    } else {
      return SettingsModel(
        agreement: Constants.tempAgree,
      );
    }
  } else {
    return SettingsModel(
      agreement: Constants.tempAgree,
    );
  }
}




//otp request
Future<dynamic> reqOtp(String mobile) async {
  final response = await http.post(Uri.parse(AppUrls.otp),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "phone": mobile,
      }));

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load User');
  }
}

//reset pass
Future<dynamic> reqResetPass(String otp, String mobile, String newPass) async {
  final response = await http.post(Uri.parse(AppUrls.resetPass),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "phone": mobile,
        "newpw": newPass,
        "otp": otp,
      }));

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load User');
  }
}






Future<dynamic> generateToken() async {
  final response = await http.post(
    Uri.parse('https://api.instamojo.com/oauth2/token/'),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'grant_type': 'client_credentials',
      'client_id': 'FSJAOFT010tIxYfVrjhXHfDhLNWiO1cL9wZicYrD',
      'client_secret':
          'VS6NfAgttDdFEZVYx0WOIFEdRkAZehXEV6oNk9dEOdYUnADzBAatHAO4hAIW9kyLBKDDdmsuXEx9pMl7H0kxyAWea07tNmyg7kRfvgFyE36xxmLJdltTr7lK39VMkU2o',
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData;
  } else {
    throw Exception('Failed to generate token');
  }
}

Future<String> createPaymentLink(String token, PaymentModel paymentModel) async {
  final response = await http.post(
    Uri.parse('https://www.instamojo.com/api/1.1/payment-requests/'),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
      "X-Api-Key": "ddd71fc18a45f52ad11430efffd8b233",
      "X-Auth-Token": "24f7214efc45e8fde4546d369ae74ed7"
    },
    body: {
      //"amount": paymentModel.amount, //amount to be paid
      "amount": '10',
      "purpose": paymentModel.purpose,
      "buyer_name": paymentModel.buyer_name,
      "email": paymentModel.email,
      "phone": paymentModel.phone,
      "allow_repeated_payments": paymentModel.allow_repeated_payments,
      "send_email": paymentModel.send_email,
      "send_sms": paymentModel.send_sms,
      "redirect_url": paymentModel.redirect_url,
      "webhook": paymentModel.webhook,
    },
  );
  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
    final paymentLink = responseData['payment_request']['longurl'].toString();
    return paymentLink;
  } else {
    throw Exception('Failed to create payment link');
  }
}
