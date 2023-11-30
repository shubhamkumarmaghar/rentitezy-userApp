import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/localDb/db_helper.dart';
import 'package:rentitezy/model/asset_model.dart';
import 'package:rentitezy/model/assets_req_model.dart';
import 'package:rentitezy/model/issues_model.dart';
import 'package:rentitezy/model/leads_model.dart';
import 'package:rentitezy/model/payment_model.dart';
import 'package:rentitezy/model/property_model.dart';
import 'package:rentitezy/model/rent_req_model.dart';
import 'package:rentitezy/model/review_model.dart';
import 'package:rentitezy/model/settings_model.dart';
import 'package:rentitezy/model/tenant_model.dart';
import 'package:rentitezy/model/ticketModel.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_urls.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//user create
Future<dynamic> createUser(String fName, String lName, String phone,
    String password, String email, String image) async {
  final response = await http.post(Uri.parse(AppUrls.userRegister),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "firstName": fName,
        "lastName": lName,
        "phone": phone,
        "password": password,
        "email": email,
        "image": image
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<dynamic> userLogin(String phone, String password) async {
  final response = await http.post(Uri.parse(AppUrls.userLogin),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "phone": phone,
        "password": password,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);

    return body;
  } else {
    throw Exception('Failed to load Rentiseazy User');
  }
}

Future<List<UserModel>> fetchUserApi(String url) async {
  final SharedPreferences sharedPreferences = await _prefs;
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Auth-Token': sharedPreferences.getString(Constants.token).toString()
    },
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List)
            .map((stock) => UserModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to User');
  }
}

Future<dynamic> fetchTenantUserApi(String url) async {
  final SharedPreferences sharedPreferences = await _prefs;

  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Auth-Token': sharedPreferences.getString(Constants.token).toString()
    },
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to User');
  }
}

Future<List<PropertyModel>> nearPropertyGet(
    String url, DbHelper favDb, Future<SharedPreferences> prefs) async {
  final SharedPreferences sharedPreferences = await prefs;
  String userId = "guest";
  if (sharedPreferences.containsKey(Constants.userId)) {
    userId = sharedPreferences.getString(Constants.userId).toString();
  }
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return Future.wait(((body["data"] as List).map((stock) async {
          PropertyModel s = PropertyModel.fromJson(stock);
          int count = await favDb.favCount(s.id.toString(), userId);
          s.isFav = count > 0;
          return s;
        }).toList()));
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

Future<List<PropertyModel>> fetchAllProductsById(List<int> ids) async {
  final response = await http.post(Uri.parse(AppUrls.fetchAllFavByIds),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, List<int>>{
        'id': ids,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    var result =
        (body["data"] as List).map((i) => PropertyModel.fromJson(i)).toList();
    return result;
  } else {
    throw Exception('Failed to load Fav Products');
  }
}

Future<List<PropertyModel>> allPropertyGet() async {
  var sharedPreferences = await _prefs;
  final response = await http.get(
    Uri.parse(AppUrls.property),
    headers: <String, String>{
      "Auth-Token": sharedPreferences.getString(Constants.token).toString()
    },
  );

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List)
            .map((stock) => PropertyModel.fromJson(stock))
            .toList();
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
    headers: <String, String>{
      "Auth-Token": sharedPreferences.getString(Constants.token).toString()
    },
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List)
            .map((stock) => PropertyModel.fromJson(stock))
            .toList();
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

Future<dynamic> createLeadsApi(
    String name,
    String phone,
    String address,
    String zipcode,
    String facility,
    String moveIn,
    String priceRange,
    String userId,
    String propertyId,
    String bhkType) async {
  var sharedPreferences = await _prefs;
  final response = await http.post(Uri.parse(AppUrls.leads),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Auth-Token": sharedPreferences.getString(Constants.token).toString()
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

Future<dynamic> createIssuesApi(
    String userId, String propertyId, String question) async {
  final response = await http.post(Uri.parse(AppUrls.issues),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "userId": userId,
        "propertyId": propertyId,
        "question": question,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<dynamic> updateUser(String name, String uLName, String phone,
    String email, String image, String userId) async {
  final response = await http.put(Uri.parse(AppUrls.user),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "id": userId,
        "firstName": name,
        "lastName": uLName,
        "phone": phone,
        "email": email,
        "image": image
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<dynamic> deleteUser(String id) async {
  final response = await http.put(Uri.parse(AppUrls.userDelete),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "id": id,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<List<AssetsModel>> getAssetsDetApi(String url) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List)
            .map((stock) => AssetsModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Assset items');
  }
}

Future<dynamic> createAssetsReqApi(String userId, String assetId) async {
  final response = await http.post(Uri.parse(AppUrls.assetReq),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "userId": userId,
        "assetId": assetId,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Assets');
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
      return SettingsModel.fromJson(
          jsonDecode((body["data"] as List)[0]['value']));
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

Future<dynamic> tenantAgreeApi(String tenantId) async {
  final response = await http.put(Uri.parse(AppUrls.tenantAgree),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "id": tenantId,
        "isAgree": 'true',
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy agreement');
  }
}

Future<TenantModel?> getUserTenant(String url) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return TenantModel.fromJson(body["data"]);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  } else {
    throw Exception('Failed to Tenant');
  }
}

Future<List<TenantModel>> fetchTenantApi(
  String url,
) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    int success = body["success"];
    if (success == 1) {
      try {
        return (body["data"] as List)
            .map((stock) => TenantModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Tenant');
  }
}

Future<dynamic> createTicketApi(String tenantId, String ticket, String comments,
    String houseId, String propertyId) async {
  final response = await http.post(Uri.parse(AppUrls.ticket),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "tenantId": tenantId,
        "ticket": ticket,
        "comments": comments,
        "houseId": houseId,
        "propertyId": propertyId,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Ticket');
  }
}

Future<List<IssuesModel>> allIssuesGet(String userId) async {
  final response = await http.get(
    Uri.parse('${AppUrls.issues}?userId=$userId'),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List)
            .map((stock) => IssuesModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Faq');
  }
}

Future<List<AssetReqModel>> getAllAssetsReq(String userId) async {
  final response = await http.get(
    Uri.parse('${AppUrls.assetReq}?userId=$userId'),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    int success = body["success"];
    if (success == 1) {
      try {
        return (body["data"] as List)
            .map((stock) => AssetReqModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Assets Request');
  }
}

Future<List<TicketModel>> getAllTicketReq(String tenantId) async {
  final response = await http.get(
    Uri.parse('${AppUrls.ticket}?tenantId=$tenantId'),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    int success = body["success"];
    if (success == 1) {
      try {
        return (body["data"] as List)
            .map((stock) => TicketModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Ticket Request');
  }
}

Future<dynamic> createRentApi(
    String id, String tenantId, String status, String paymentId) async {
  final response = await http.put(Uri.parse(AppUrls.rentReq),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "id": id,
        "tenantId": tenantId,
        "status": status,
        "paymentId": paymentId,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rent Request');
  }
}

Future<List<RentReqModel>> getAllRentReq(String url, String token) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      "Auth-Token": token
    },
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    // bool success = body["success"];
    // if (success) {
    try {
      return (body["data"] as List)
          .map((stock) => RentReqModel.fromJson(stock))
          .toList();
    } catch (e) {
      return [];
    }
    // } else {
    //   throw Exception(body["message"]);
    // }
  } else {
    throw Exception('Failed to Rent Request');
  }
}

Future<List<LeadsModel>> getAllLeadReq(String url) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        return (body["data"] as List)
            .map((stock) => LeadsModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Lead Request');
  }
}

Future<dynamic> createReviewApi(
    String userId, String tenantId, String propertyId, String review) async {
  final response = await http.post(Uri.parse(AppUrls.review),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "userId": userId,
        "tenantId": tenantId,
        "propertyId": propertyId,
        "review": review,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<List<ReviewModel>> fetchReviewApi(String url) async {
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{},
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    int success = body["success"];
    if (success == 1) {
      try {
        return (body["data"] as List)
            .map((stock) => ReviewModel.fromJson(stock))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Review');
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

//cashfree tocken
Future<dynamic> createTocken(String orderId, String amount) async {
  final response = await http.post(
      Uri.parse('https://api.cashfree.com/api/v2/cftoken/order'),
      headers: <String, String>{
        'x-client-secret': '186eae94262d9b424b4924ecdb835f5ee6abd52f',
        'x-client-id': '109131d02ec2392634d5bf1c45131901',
        'x-api-version': '2022-01-01',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'orderId': orderId,
        'orderAmount': amount,
        'orderCurrency': 'INR'
      }));
  var body = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return body;
  } else {
    throw Exception('Failed to load OrderId');
  }
}

Future<String> getOrderId(
    String amount, String recipt, String authorization) async {
  final response = await http.post(Uri.parse(AppUrls.orderIdRzy),
      headers: <String, String>{
        'Authorization': authorization,
        "Content-Type": "application/json"
      },
      body: jsonEncode(
          {"amount": int.parse(amount), "currency": "INR", "receipt": recipt}));
  var body = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return body["id"];
  } else {
    throw Exception(body["description"]);
  }
}

Future<dynamic> createBookNowApi(
    String name,
    String phone,
    String address,
    String zipcode,
    String facility,
    String moveIn,
    String priceRange,
    String userId,
    String propertyId,
    String advancePaid,
    String advancePayId,
    String bhkType) async {
  final response = await http.post(Uri.parse(AppUrls.bookNow),
      headers: <String, String>{
        'Content-Type': 'application/json',
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
        "advancePaid": advancePaid,
        "advancePayId": advancePayId,
        "stage": "qualified",
        "progress": "discussed",
        "bhkType": bhkType
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<dynamic> webAdminLogin() async {
  final response = await http.post(Uri.parse(AppUrls.loginWeb),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <String, String>{"phone": "9787665850", "password": "12344321"}));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<dynamic> getCheckOut(String url, String token) async {
  var headers = {'Auth-Token': token};
  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to Checkout Request');
  }
}

Future<dynamic> checkOutUrl(String name, String email, String phone,
    String cartId, String token) async {
  var headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    'User-Auth-Token': token
  };
  final response = await http.post(Uri.parse(AppUrls.checkout),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: {
        "name": name,
        "email": email,
        "phone": phone,
        "cartId": cartId,
      });
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);

    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
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

Future<String> createPaymentLink(
    String token, PaymentModel paymentModel) async {
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

Future<dynamic> createPaymentRequest(String invoiceId, String token) async {
  final url = Uri.parse(AppUrls.rentPay);
  final headers = {'Content-Type': 'application/json', 'auth-token': token};
  final body = jsonEncode({
    'invoiceId': invoiceId.toString(),
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    if (responseData['success']) {
      return responseData;
    } else {
      return 'Payment request creation failed';
    }
  } else {
    return 'Failed to create payment request';
  }
}

//add fav
Future<dynamic> addToFav(
  String listingId,
) async {
  var sharedPreferences = await _prefs;
  final response = await http.post(Uri.parse(AppUrls.addFav),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Auth-Token": sharedPreferences.getString(Constants.token).toString()
      },
      body: jsonEncode(<String, String>{
        "listingId": listingId,
      }));
  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    return body;
  } else {
    throw Exception('Failed to load Rentiseazy');
  }
}

Future<PropertyModel?> singlePropertyGet(String url) async {
  var sharedPreferences = await _prefs;
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      "Auth-Token": sharedPreferences.getString(Constants.token).toString()
    },
  );

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    bool success = body["success"];
    if (success) {
      try {
        List<PropertyModel> dataList = (body["data"] as List)
            .map((stock) => PropertyModel.fromJson(stock))
            .toList();
        if (dataList.isNotEmpty) {
          return dataList.first;
        }
        return null;
      } catch (e) {
        return null;
      }
    } else {
      throw Exception(body["message"]);
    }
  } else {
    throw Exception('Failed to Pro');
  }
}

//UploadImage
Future<String> uploadImage(String path, String name) async {
  var request =
      http.MultipartRequest("POST", Uri.parse(AppUrls.urlImgUpload));
  var pic = await http.MultipartFile.fromPath("image", path);
  request.files.add(pic);
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  if (kDebugMode) {
    print(responseString);
  }
  return AppUrls.imagesRootUrl + name;
}
