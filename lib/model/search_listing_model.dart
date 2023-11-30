class FlatModel {
  int id;
  int propId;
  String title;
  String listingType;
  int price;
  int area;
  Property property;
  List<dynamic> images;
  List<dynamic> wishlist;
  List<Unit> units;
  Count count;

  FlatModel({
    required this.id,
    required this.propId,
    required this.title,
    required this.listingType,
    required this.price,
    required this.area,
    required this.property,
    required this.images,
    required this.wishlist,
    required this.units,
    required this.count,
  });

  factory FlatModel.fromJson(Map<String, dynamic> json) {
    return FlatModel(
      id: json['id'],
      propId: json['propId'],
      title: json['title'],
      listingType: json['listingType'],
      price: json['price'],
      area: json['area'],
      property: Property.fromJson(json['property']),
      images: json['images'],
      wishlist: json['wishlist'],
      units:
          (json["units"] as List).map((stock) => Unit.fromJson(stock)).toList(),
      count: Count.fromJson(json['_count']),
    );
  }
}

class Property {
  String name;
  String location;
  String latlng;
  String type;
  String address;
  String plots;
  String floor;

  Property({
    required this.name,
    required this.location,
    required this.latlng,
    required this.type,
    required this.address,
    required this.plots,
    required this.floor,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
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
