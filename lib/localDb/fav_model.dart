import 'dart:convert';

import '../utils/const/app_urls.dart';

class FavModel {
  int id;
  String proID;
  String userId;
  String ownerId;
  String relationShip;
  String name;
  String type;
  String plots;
  String floor;
  String facility;
  String amenities;
  String address;
  String area;
  String city;
  String latlng;
  String photo;
  String video;
  String description;
  String price;
  String ownerPhone;
  String createdOn;
  List<String> images;
  List<String> amenitiesList;

  FavModel(
      {required this.id,
      required this.proID,
      required this.userId,
      required this.ownerId,
      required this.relationShip,
      required this.name,
      required this.type,
      required this.plots,
      required this.floor,
      required this.facility,
      required this.amenities,
      required this.address,
      required this.area,
      required this.city,
      required this.latlng,
      required this.photo,
      required this.video,
      required this.description,
      required this.price,
      required this.images,
      required this.amenitiesList,
      required this.ownerPhone,
      required this.createdOn});

  factory FavModel.fromJson(Map<String, dynamic> json) {
    var imageDynamic = json['photo'];
    List<String> images = [];
    if (imageDynamic.toString().contains("[")) {
      var imageDynamicList = jsonDecode(json['photo']);
      for (var img in imageDynamicList) {
        images.add(img.toString());
      }
    } else {
      images.add(imageDynamic);
    }

    var iconDynamic = json['amenities'];
    List<String> amenitiesTemp = [];
    if (iconDynamic.toString().contains("[")) {
      var listAmenties = jsonDecode(json['amenities']);
      for (var item in listAmenties) {
        amenitiesTemp.add(item);
      }
    }
    return FavModel(
        id: json['id'],
        proID: json['proID'],
        ownerId: json['ownerId'],
        userId: json['userId'],
        relationShip: json['relationShip'],
        name: json['name'],
        type: json['type'],
        plots: json['plots'],
        floor: json['floor'],
        facility: json['facility'],
        amenities: json['amenities'],
        address: json['address'],
        area: json['area'],
        city: json['city'],
        latlng: json['latlng'],
        photo: json['photo'],
        video: json['video'],
        description: json['description'],
        price: json['price'],
        ownerPhone: AppUrls.phone,
        images: images,
        amenitiesList: amenitiesTemp,
        createdOn: json['createdOn']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proID': proID,
      'userId': userId,
      'ownerId': ownerId,
      'relationShip': relationShip,
      'name': name,
      'type': type,
      'plots': plots,
      'floor': floor,
      'facility': facility,
      'amenities': amenities,
      'address': address,
      'area': area,
      'city': city,
      'latlng': latlng,
      'photo': photo,
      'video': video,
      'description': description,
      'price': price,
      'ownerPhone': ownerPhone,
      'createdOn': createdOn,
    };
  }

  @override
  String toString() {
    return 'FavModel{id: $id, proID:$proID, userId:$userId, ownerId: $ownerId, relationShip: $relationShip, name: $name, type: $type,plots:$plots, floor:$floor,facility:$facility,amenities: $amenities,address:$address,area:$area,latlng:$latlng,photo:$photo,video:$video,description$description,price$price,ownerPhone$ownerPhone,createdOn$createdOn}';
  }
}
