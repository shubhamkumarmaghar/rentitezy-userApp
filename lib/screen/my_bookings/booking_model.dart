import 'package:flutter/cupertino.dart';

class MyBookingModel {
  String bookingId;
  PropUnit? property;
  String moveIn;
  String moveOut;
  String name;
  String email;
  String phone;
  int guest;
  int rent;
  int deposit;
  int onboarding;
  int amountPaid;
  String status;
  List<Invoices> invoicesList;

  MyBookingModel(
      {required this.bookingId,
      required this.property,
      required this.moveIn,
      required this.moveOut,
      required this.name,
      required this.email,
      required this.phone,
      required this.guest,
      required this.rent,
      required this.deposit,
      required this.onboarding,
      required this.amountPaid,
      required this.status,
      required this.invoicesList});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    debugPrint('mybooking - ${json.toString()}');
    return MyBookingModel(
        bookingId: json['id'].toString(),
        property: json.containsKey('propUnit')
            ? PropUnit.fromJson(json['propUnit'])
            : null,
        moveIn: json['moveIn'] ?? '--',
        moveOut: json['moveOut'] ?? "--",
        name: json['name'].toString(),
        email: json['email'].toString(),
        phone: json['phone'].toString(),
        guest: json['guest'] ?? '0',
        rent: json['rent'] ?? 0,
        deposit: json['deposit'] ?? 0,
        onboarding: json['onboarding'] ?? 0,
        amountPaid: json['amountPaid'] ?? 0,
        invoicesList: (json['invoices'] as List)
            .map((invoices) => Invoices.fromJson(invoices))
            .toList(),
        status: json['status']);
  }
}

class PropUnit {
  int id;
  String flatNo;
  PropListing propListing;

  PropUnit({required this.id, required this.flatNo, required this.propListing});

  factory PropUnit.fromJson(Map<String, dynamic> json) {
    debugPrint('json ${json.toString()}');
    return PropUnit(
        id: json['id'] ?? 'NA',
        flatNo: json['flatNo'] ?? 'NA',
        propListing: PropListing.fromJson(json['listing']));
  }
}

class PropListing {
  String unitType;
  Property property;

  PropListing({required this.unitType, required this.property});

  factory PropListing.fromJson(Map<String, dynamic> json) {
    return PropListing(
        unitType: json['unitType'] ?? 'NA',
        property: Property.fromJson(json['property']));
  }
}

class Property {
  String name;
  String address;
  String latlng;

  Property({required this.name, required this.address, required this.latlng});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        name: json['name'] ?? 'NA',
        address: json['address'] ?? 'NA',
        latlng: json['latlng'] ?? 'NA');
  }
}

class Invoices {
  String id;
  String type;
  String fromDate;
  String tillDate;
  String payable;
  String paid;
  String status;

  Invoices(
      {required this.id,
      required this.type,
      required this.fromDate,
      required this.tillDate,
      required this.payable,
      required this.paid,
      required this.status});

  factory Invoices.fromJson(Map<String, dynamic> json) {
    return Invoices(
      id: json['id'].toString(),
      type: json['type'].toString(),
      fromDate: json['fromDate'].toString(),
      tillDate: json['tillDate'].toString(),
      payable: json['payable'].toString(),
      paid: json['paid'].toString(),
      status: json['status'].toString(),
    );
  }
}
