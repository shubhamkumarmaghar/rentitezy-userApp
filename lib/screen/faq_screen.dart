import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/faq_model.dart';
import 'package:rentitezy/utils/const/widgets.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqState();
}

class _FaqState extends State<FaqScreen> {
  List<FaqModel> faqModelList = [
    FaqModel(
        id: 1,
        question: "What is the Deposit amount?",
        ans:
            "Deposit amount is the part of the security deposit paid towards blocking the flat for the respective duration of stay.\nFor your convenience, you can block a property by paying this amount and make the remaining payment during movein."),
    FaqModel(
        id: 2,
        question: "Is my 1st month's rent covered in the security deposit?",
        ans:
            "No, your first month's rent needs to be paid in addition to the security deposit to Rentiseazy and You will have to pay the first month's rent on or before you move in to the property."),
    FaqModel(
        id: 3,
        question: "Is Security Deposit entirely refundable?",
        ans:
            "The deductions in the deposit will be as per your rental agreement.\nYour security deposit will be refunded to you within 4 business days after you move out."),
    FaqModel(
        id: 4,
        question: "Do I need to pay for electricity monthly?",
        ans:
            "Electricity is not included in the rent and need to be borne by tenants based on usage and requirement.\nOnce you book a property, for details on the billing cycle, due dates, etc., for electricity, will be provided.Please pay your utility bills on time to avoid interruption in services."),
    FaqModel(
        id: 5,
        question: "What if I cancel my booking?",
        ans:
            "The cancelation mail to be sent to support@rentiseazy.com\nOnce the mail is acknowledged the booking stays cancelled and the refund will be as below:\nIf the booking is cancelled before move in 30% of the amount will be applicable towards cancelation charges.\nIf the booking is cancelled on the day of move-in the amount is non refundable."),
    FaqModel(
        id: 6,
        question: "Say I've paid for my room. What all do I get with it?",
        ans:
            "Besides fully furnished rooms, we provide a long list of amenities and services. But the exact offerings vary per residence."),
    FaqModel(
        id: 7,
        question: "Do I get to pick and choose the house amenities?",
        ans:
            "That would be ideal. But our co-living spaces are designed for everyone residing in them at any given time. So it's easier for us to maintain a standard package with all amenities available."),
    FaqModel(
        id: 8,
        question:
            "If I don't use the amenities, will I be exempted from charges or availing discounts on my monthly rent?",
        ans:
            "That's not how it'll work, sorry. The common amenities are for everyone who's residing in our co-living spaces. So it's not possible to offer resident-wise customised packages. So you might as well make the best use of the standard package we offer."),
    FaqModel(
        id: 9,
        question: "Can I make a booking on behalf of another person?",
        ans:
            "If you're a close friend or a guardian, then sure. If you're just a random FB friend, then maybe not. Either way, at the time of booking, you'll have to enter the details of the person who'll be staying at the chosen home. Once the booking is confirmed, he/she/they will have to meet the caretaker in person to carry out the KYC formalities before moving in."),
    FaqModel(
        id: 10,
        question: "Can I share my room preference while confirming my booking?",
        ans:
            "Sure thing. While you're in the process of booking a stay at our residence, just reach out to our people to share your preferred room. If it's possible, we'll make sure it gets assigned to you. Promise."),
    FaqModel(
        id: 11,
        question: "What's the arrangement for the maintenance of the property?",
        ans:
            "Regular maintenance and repair of regular wear-and-tear is our headache. We only need your help in case there's work required at the structural level."),
    FaqModel(
        id: 12,
        question: "What if my rent payment gets delayed?",
        ans:
            "Instance 1: A minimum token amount has to be paid at the time of reserving the room for a future date. If delayed: We do not accept a partial Token amount at the time of booking.\nInstance 2: The booking amount (Security Deposit + Maintenance Charges in Advance) has to be cleared before moving into our residence.If delayed: The booking will get canceled 48 hours before onboarding and we will not be able to process any refund.\nInstance 3: The monthly rent has to be cleared on or before the 7th of every month.If delayed: A penalty fee will be charged in addition to the monthly rent."),
  ];

  @override
  void initState() {
    super.initState();
  }

//faqApi
  Widget listFaq() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => expandItemFaq(faqModelList[index]),
      itemCount: faqModelList.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
    );
  }

//faq list widget
  Widget expandItemFaq(FaqModel faqModel) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              '${faqModel.id}.',
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
          ),
          title: Text(
            faqModel.question,
            style: TextStyle(fontFamily: Constants.fontsFamily),
          ),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(5),
          tilePadding: const EdgeInsets.all(5),
          children: [
            Text(
              faqModel.ans,
              style: TextStyle(fontFamily: Constants.fontsFamily),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
        titleSpacing: -10,
        title: Text(
          'Faq',
          style: TextStyle(
              fontFamily: Constants.fontsFamily, color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(width: screenWidth, height: screenHeight, child: listFaq()),
    );
  }
}
