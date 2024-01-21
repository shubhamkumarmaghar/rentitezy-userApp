class WishlistModel {
  List<WishListSingleData>? data;
  bool? success;
  String? message;

  WishlistModel({this.data, this.success, this.message});

  WishlistModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WishListSingleData>[];
      json['data'].forEach((v) {
        data!.add(new WishListSingleData.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class WishListSingleData {
  Listing? listing;

  WishListSingleData({this.listing});

  WishListSingleData.fromJson(Map<String, dynamic> json) {
    listing =
    json['listing'] != null ? new Listing.fromJson(json['listing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listing != null) {
      data['listing'] = this.listing!.toJson();
    }
    return data;
  }
}

class Listing {
  int? id;
  int? propId;
  String? title;
  String? listingType;
  int? price;
  int? area;
  Property? property;
  List<Images>? images;

  Listing(
      {this.id,
        this.propId,
        this.title,
        this.listingType,
        this.price,
        this.area,
        this.property,
        this.images});

  Listing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propId = json['propId'];
    title = json['title'];
    listingType = json['listingType'];
    price = json['price'];
    area = json['area'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['propId'] = this.propId;
    data['title'] = this.title;
    data['listingType'] = this.listingType;
    data['price'] = this.price;
    data['area'] = this.area;
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Property {
  String? name;
  Location? location;
  String? latlng;
  String? type;
  String? address;
  String? plots;
  String? floor;

  Property(
      {this.name,
        this.location,
        this.latlng,
        this.type,
        this.address,
        this.plots,
        this.floor});

  Property.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    latlng = json['latlng'];
    type = json['type'];
    address = json['address'];
    plots = json['plots'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['latlng'] = this.latlng;
    data['type'] = this.type;
    data['address'] = this.address;
    data['plots'] = this.plots;
    data['floor'] = this.floor;
    return data;
  }
}

class Location {
  int? id;
  String? name;
  int? active;

  Location({this.id, this.name, this.active});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['active'] = this.active;
    return data;
  }
}

class Images {
  String? url;

  Images({this.url});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}