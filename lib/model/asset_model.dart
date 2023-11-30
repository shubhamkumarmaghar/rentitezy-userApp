import 'dart:convert';

class AssetsModel {
  String id;
  String houseId;
  String productName;
  String brand;
  String type;
  String price;
  String image;
  List<String> imageList;
  String status;
  String createdOn;

  AssetsModel(
      {required this.id,
      required this.houseId,
      required this.productName,
      required this.brand,
      required this.type,
      required this.price,
      required this.image,
      required this.status,
      required this.imageList,
      required this.createdOn});

  factory AssetsModel.fromJson(Map<String, dynamic> json) {
    var imageDynamic = json['image'];
    List<String> images = [];
    if (imageDynamic.toString().contains("[")) {
      var imageDynamicList = jsonDecode(json['image']);
      for (var img in imageDynamicList) {
        images.add(img.toString());
      }
    } else {
      images.add(imageDynamic);
    }
    return AssetsModel(
        id: json['id'].toString(),
        houseId: json['houseId'],
        productName: json['productName'],
        brand: json['brand'],
        type: json['type'],
        price: json['price'],
        image: json['image'],
        imageList: images,
        status: json['status'],
        createdOn: json['createdOn']);
  }
}
