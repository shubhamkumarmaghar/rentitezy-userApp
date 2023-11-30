import 'package:flutter/cupertino.dart';
import 'package:rentitezy/utils/const/appConfig.dart';

import '../utils/const/app_urls.dart';

class PropertyModel {
  String id;
  String ownerId;
  String name;
  String type;
  String plots;
  String floor;
  String facility;
  String address;
  String area;
  String city;
  String latlng;
  String video;
  String description;
  String price;
  String ownerPhone;
  String createdOn;
  String bhkType;
  String availFrom;
  bool isFav = false;
  List<String> images;
  List<FlatNoModel> flatNoList;

  PropertyModel(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.type,
      required this.plots,
      required this.floor,
      required this.facility,
      required this.address,
      required this.area,
      required this.city,
      required this.latlng,
      required this.video,
      required this.description,
      required this.price,
      required this.images,
      required this.ownerPhone,
      required this.bhkType,
      required this.flatNoList,
      required this.availFrom,
      required this.createdOn});

  PropertyModel copyWith() => PropertyModel(
      id: id,
      ownerId: ownerId,
      name: name,
      type: type,
      plots: plots,
      floor: floor,
      facility: facility,
      address: address,
      area: area,
      city: city,
      latlng: latlng,
      video: video,
      description: description,
      price: price,
      ownerPhone: ownerPhone,
      images: [],
      bhkType: bhkType,
      flatNoList: flatNoList,
      availFrom: availFrom,
      createdOn: createdOn);

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    //List<String> images = ['https://'];
    // String imageItem =
    //     json['photo'].toString().replaceAll('[', '').replaceAll(']', '');
    // List<String> images = imageItem.split(',');
    List<String> li = [];
    for (var i in json['images']) {
      li.add(i["url"]);
    }
    Map<String, dynamic> proJson = json['property'];
    debugPrint(proJson['ownerId'].toString());
    return PropertyModel(
        id: json['id'].toString(),
        ownerId: proJson['ownerId'].toString(),
        name: proJson['name'].toString(),
        type: proJson['type'].toString(),
        plots: proJson['plots'].toString(),
        floor: proJson['floor'].toString(),
        facility: proJson['facility'].toString(),
        address: proJson['address'].toString(),
        area: json['area'].toString(),
        city: proJson['city'].toString(),
        latlng: proJson['latlng'].toString(),
        video: json['video'].toString(),
        description: json['description'].toString(),
        bhkType: json['listingType'].toString(),
        price: json['price'].toString(),
        availFrom: json['availFrom'].toString(),
        ownerPhone: AppUrls.phone,
        images: li,
        flatNoList: [],
        createdOn: json['createdOn'].toString());
  }
}

class FlatNoModel {
  int id;
  String flatNo;

  FlatNoModel({
    required this.id,
    required this.flatNo,
  });

  factory FlatNoModel.fromJson(Map<String, dynamic> json) {
    return FlatNoModel(id: json['id'] ?? -1, flatNo: json['flatNo'] ?? 'NA');
  }
}
