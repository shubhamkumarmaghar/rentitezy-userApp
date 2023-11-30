import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/model/payment_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/const/appConfig.dart';

class InstaMojoDemo extends StatefulWidget {
  final PaymentModel paymentModel;
  const InstaMojoDemo({super.key, required this.paymentModel});

  @override
  _InstaMojoDemoState createState() => _InstaMojoDemoState();
}

bool isLoading = true; //this can be declared outside the class

class _InstaMojoDemoState extends State<InstaMojoDemo> {
  String selectedUrl = "";
  double progress = 0;

  @override
  void initState() {
    createToken();
    super.initState();
  }

  void createToken() async {
    dynamic result = await generateToken();
    final String accessToken = result['access_token'];
    print('accessToken');
    print(accessToken);
    createRequest(accessToken);
    //createRequest(); //creating the HTTP request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: const Text("Rentiseasy Payment"),
      ),
      body: Center(
        child: isLoading
            ? //check loadind status
            const CircularProgressIndicator() //if true
            : InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.tryParse(selectedUrl),
                ),
                onWebViewCreated: (InAppWebViewController controller) {},
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (_, Uri? uri, __) {
                  String url = uri.toString();
                  print(uri);
                  // uri containts newly loaded url
                  if (mounted) {
                    if (url.contains('https://www.google.com/')) {
//Take the payment_id parameter of the url.
                      String paymentRequestId =
                          uri!.queryParameters['payment_id']!;
//calling this method to check payment status
                      _checkPaymentStatus(paymentRequestId);
                    }
                  }
                },
              ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        // Uri.parse("https://test.instamojo.com/api/1.1/payments/$id/"),
        Uri.parse("https://api.instamojo.com/v2/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "ddd71fc18a45f52ad11430efffd8b233",
          "X-Auth-Token": "24f7214efc45e8fde4546d369ae74ed7"
        });
    var realResponse = json.decode(response.body);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print('sucesssssssssssful');
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //         builder: (context) => ()));
//payment is successful.
      } else {
        print('failed');
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }

  Future createRequest(String token) async {
    try {
      selectedUrl = await createPaymentLink(token, widget.paymentModel);
      // handlePaymentRequest(selectedUrl);
      isLoading = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> handlePaymentRequest(String paymentRequestUrl) async {
    if (await canLaunch(paymentRequestUrl)) {
      await launch(paymentRequestUrl);
    } else {
      throw Exception('Could not launch payment request URL');
    }
  }
}
