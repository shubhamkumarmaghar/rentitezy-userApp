import 'dart:convert';

class LeadsModel {
  String id;
  String marketingStaff;
  String name;
  String phone;
  String address;
  String zipcode;
  String facility;
  String moveIn;
  String priceRange;
  String stage;
  String progress;
  String createdOn;
  String propertyId;
  List<int> proIds;

  LeadsModel(
      {required this.id,
      required this.marketingStaff,
      required this.name,
      required this.phone,
      required this.address,
      required this.zipcode,
      required this.facility,
      required this.moveIn,
      required this.priceRange,
      required this.stage,
      required this.progress,
      required this.proIds,
      required this.propertyId,
      required this.createdOn});

  factory LeadsModel.fromJson(Map<String, dynamic> json) {
    var idsDynamic = json['propertyId'];
    List<int> idsTemp = [];
    if (idsDynamic.toString().contains("[")) {
      var idsDynamicList = jsonDecode(json['propertyId']);
      for (var id in idsDynamicList) {
        idsTemp.add(int.parse(id));
      }
    } else {
      idsTemp.add(idsDynamic);
    }
    return LeadsModel(
        id: json['id'].toString(),
        marketingStaff: json['marketingStaff'],
        name: json['name'],
        phone: json['phone'],
        address: json['address'],
        zipcode: json['zipcode'],
        facility: json['facility'],
        moveIn: json['moveIn'],
        priceRange: json['priceRange'],
        stage: json['stage'],
        progress: json['progress'],
        proIds: idsTemp,
        propertyId: json['propertyId'],
        createdOn: json['createdOn']);
  }
}
