import 'package:rentitezy/model/property_model.dart';

class TenantModel {
  String id;
  String leadId;
  String propertyId;
  String assetId;
  String name;
  String email;
  String phone;
  String address;
  String aadharCard;
  String panCard;
  String photo;
  String rentalAgreement;
  String houseId;
  String advancePaid;
  String remainingRent;
  String amentiesAvail;
  String gdprAgreement;
  String rentalAmt;
  String closingDate;
  String isAgree;
  String totalAmt;
  String payDate;
  String createdOn;
  String payStatus;
  String bhkType;
  PropertyModel? propertyModel;

  TenantModel(
      {required this.id,
      required this.leadId,
      required this.propertyId,
      required this.assetId,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.aadharCard,
      required this.panCard,
      required this.photo,
      required this.rentalAgreement,
      required this.houseId,
      required this.advancePaid,
      required this.remainingRent,
      required this.amentiesAvail,
      required this.gdprAgreement,
      required this.rentalAmt,
      required this.closingDate,
      required this.isAgree,
      required this.totalAmt,
      required this.payDate,
      required this.propertyModel,
      required this.payStatus,
      required this.bhkType,
      required this.createdOn});

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    PropertyModel? temp;
    if (json.containsKey('propertyDet')) {
      if (json['propertyDet'] != 'NA') {
        temp = PropertyModel.fromJson(json['propertyDet']);
      } else {
        temp = null;
      }
    } else {
      temp = null;
    }
    return TenantModel(
        id: json['id'].toString(),
        leadId: json['leadId'],
        propertyId: json['propertyId'],
        assetId: json['assetId'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        aadharCard: json['aadharCard'],
        panCard: json['panCard'],
        photo: json['photo'],
        rentalAgreement: json['rentalAgreement'],
        houseId: json['houseId'],
        advancePaid: json['advancePaid'].toString(),
        remainingRent: json['remainingRent'],
        amentiesAvail: json['amentiesAvail'],
        gdprAgreement: json['gdprAgreement'],
        rentalAmt: json['rentalAmt'].toString(),
        closingDate: json['closingDate'],
        isAgree: json['isAgree'] ?? 'false',
        totalAmt: json['totalAmt'],
        payDate: json['payDate'],
        bhkType: json['bhkType'] ?? 'NA',
        payStatus: json['payStatus'] ?? 'paid',
        propertyModel: temp,
        createdOn: json['createdOn']);
  }
}
