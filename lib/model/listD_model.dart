class ListingDModel {
  String id;
  String propId;
  String title;
  String listingType;
  String price;
  String area;
  PropertyM property;
  List<dynamic> images;
  List<String> imgList;
  List<dynamic> wishlist;
  List<Unit> units;
  Count count;

  ListingDModel(
      {required this.id,
      required this.propId,
      required this.title,
      required this.listingType,
      required this.price,
      required this.area,
      required this.property,
      required this.images,
      required this.wishlist,
      required this.units,
      required this.imgList,
      required this.count});
  factory ListingDModel.fromJson(Map<String, dynamic> json) {
    List<String> li = [];
    for (var i in json['images']) {
      li.add(i["url"]);
    }

    return ListingDModel(
      id: json['id'].toString(),
      propId: json['propId'].toString(),
      title: json['title'],
      listingType: json['listingType'],
      price: json['price'].toString(),
      area: json['area'].toString(),
      property: PropertyM.fromJson(json['property']),
      images: json['images'],
      imgList: li,
      wishlist: json['wishlist'],
      units:
          (json["units"] as List).map((stock) => Unit.fromJson(stock)).toList(),
      count: Count.fromJson(json['_count']),
    );
  }
}

class PropertyM {
  String name;
  String location;
  String latlng;
  String type;
  String address;
  String plots;
  String floor;
  PropertyM({
    required this.name,
    required this.location,
    required this.latlng,
    required this.type,
    required this.address,
    required this.plots,
    required this.floor,
  });

  factory PropertyM.fromJson(Map<String, dynamic> json) {
    return PropertyM(
      name: json['name'],
      location: json['location'],
      latlng: json['latlng'],
      type: json['type'],
      address: json['address'],
      plots: json['plots'],
      floor: json['floor'],
    );
  }
}

class Unit {
  int id;
  String flatNo;
  String furnishType;
  String availFrom;

  Unit({
    required this.id,
    required this.flatNo,
    required this.furnishType,
    required this.availFrom,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      flatNo: json['flatNo'],
      furnishType: json['furnishType'],
      availFrom: json['availFrom'],
    );
  }
}

class Count {
  int units;

  Count({
    required this.units,
  });

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      units: json['units'],
    );
  }
}
