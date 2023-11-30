import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instamojo/instamojo.dart';
import 'package:rentitezy/model/payment_model.dart';

import '../utils/const/appConfig.dart';

class PayInstamojoScreen extends StatefulWidget {
  final PaymentModel body;
  final String orderCreationUrl;

  const PayInstamojoScreen({
    Key? key,
    required this.body,
    required this.orderCreationUrl,
  }) : super(key: key);

  @override
  PayInstamojoScreenState createState() => PayInstamojoScreenState();
}

class PayInstamojoScreenState extends State<PayInstamojoScreen>
    implements InstamojoPaymentStatusListener {
  @override
  void initState() {
    print(widget.body);
    print(widget.orderCreationUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Constants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Checkout',
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: Instamojo(
                  isConvenienceFeesApplied: false,
                  listener: this,
                  environment: Environment.PRODUCTION,
                  apiCallType: ApiCallType.createOrder(
                      createOrderBody: CreateOrderBody(
                          amount: widget.body.amount,
                          buyerEmail: widget.body.email,
                          buyerName: widget.body.buyer_name,
                          buyerPhone: widget.body.phone,
                          description: widget.body.purpose),
                      orderCreationUrl: widget.orderCreationUrl),
                  stylingDetails: StylingDetails(
                      buttonStyle: ButtonStyling(
                          buttonColor: Colors.amber,
                          buttonTextStyle: const TextStyle(
                            color: Colors.black,
                          )),
                      listItemStyle: ListItemStyle(
                          borderColor: Colors.grey,
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          subTextStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      loaderColor: Colors.amber,
                      inputFieldTextStyle: InputFieldTextStyle(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          hintTextStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          labelTextStyle: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                      alertStyle: AlertStyle(
                        headingTextStyle:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        messageTextStyle:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        positiveButtonTextStyle: const TextStyle(
                            color: Colors.redAccent, fontSize: 10),
                        negativeButtonTextStyle:
                            const TextStyle(color: Colors.amber, fontSize: 10),
                      )),
                )))
      ]),
    );
  }

  @override
  void paymentStatus({Map<String, String>? status}) {
    Navigator.pop(context, status);
  }
}
