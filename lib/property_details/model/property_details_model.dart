import '../../home/model/property_list_nodel.dart';

class PropertyDetailsModel {
  int? id;
  int? propId;
  String? listingType;
  String? furnishType;
  String? title;
  String? video;
  String? description;
  int? price;
  int? dailyPrice;
  int? rent;
  int? area;
  dynamic balconies;
  dynamic bathrooms;
  String? createdOn;
  String? updateOn;
  String? status;
  int? active;
  Property? property;
  List<Units>? units;
  List<Images>? images;
  List<ListingAmenities>? listingAmenities;
  int? wishlist;
  String? availFrom;
  int? stPrice;
  int? deposit;
  int? stDeposit;
  List<NearByPlaces>? nearByPlaces;

  PropertyDetailsModel(
      {this.id,
      this.propId,
      this.listingType,
      this.furnishType,
      this.title,
      this.video,
      this.description,
      this.price,
      this.dailyPrice,
      this.rent,
      this.area,
      this.balconies,
      this.bathrooms,
      this.createdOn,
      this.updateOn,
      this.status,
      this.active,
      this.property,
      this.units,
      this.images,
      this.listingAmenities,
      this.wishlist,
      this.availFrom,
      this.stPrice,
      this.deposit,
      this.stDeposit,
      this.nearByPlaces});

  PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propId = json['propId'];
    listingType = json['listingType'];
    furnishType = json['furnishType'];
    title = json['title'];
    video = json['video'];
    description = json['description'];
    price = json['price'];
    dailyPrice = json['dailyPrice'];
    rent = json['rent'];
    area = json['area'];
    balconies = json['balconies'];
    bathrooms = json['bathrooms'];
    createdOn = json['createdOn'];
    updateOn = json['updateOn'];
    status = json['status'];
    active = json['active'];
    property = json['property'] != null ? Property.fromJson(json['property']) : null;
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add(Units.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['listingAmenities'] != null) {
      listingAmenities = <ListingAmenities>[];
      json['listingAmenities'].forEach((v) {
        listingAmenities!.add(ListingAmenities.fromJson(v));
      });
    }
    wishlist = json['wishlist'];
    availFrom = json['availFrom'];
    stPrice = json['stPrice'];
    deposit = json['deposit'];
    stDeposit = json['stDeposit'];
    if (json['nearByPlaces'] != null) {
      nearByPlaces = <NearByPlaces>[];
      json['nearByPlaces'].forEach((v) {
        nearByPlaces!.add(NearByPlaces.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['propId'] = propId;
    data['listingType'] = listingType;
    data['furnishType'] = furnishType;
    data['title'] = title;
    data['video'] = video;
    data['description'] = description;
    data['price'] = price;
    data['dailyPrice'] = dailyPrice;
    data['rent'] = rent;
    data['area'] = area;
    data['balconies'] = balconies;
    data['bathrooms'] = bathrooms;
    data['createdOn'] = createdOn;
    data['updateOn'] = updateOn;
    data['status'] = status;
    data['active'] = active;
    if (property != null) {
      data['property'] = property!.toJson();
    }
    if (units != null) {
      data['units'] = units!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (listingAmenities != null) {
      data['listingAmenities'] = listingAmenities!.map((v) => v.toJson()).toList();
    }
    data['wishlist'] = wishlist;
    data['availFrom'] = availFrom;
    data['stPrice'] = stPrice;
    data['deposit'] = deposit;
    data['stDeposit'] = stDeposit;
    if (nearByPlaces != null) {
      data['nearByPlaces'] = nearByPlaces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Property {
  int? id;
  String? type;
  String? name;
  int? locationId;
  String? city;
  String? latlng;
  String? lat;
  String? long;
  String? plots;
  String? floor;
  String? address;
  int? maintenance;
  String? createdOn;
  String? updateOn;
  int? active;
  int? online;
  dynamic age;
  dynamic positionDate;

  Property(
      {id,
      type,
      name,
      locationId,
      city,
      latlng,
      lat,
      long,
      plots,
      floor,
      address,
      maintenance,
      createdOn,
      updateOn,
      active,
      online,
      age,
      positionDate});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    locationId = json['locationId'];
    city = json['city'];
    latlng = json['latlng'];
    lat = json['lat'];
    long = json['long'];
    plots = json['plots'];
    floor = json['floor'];
    address = json['address'];
    maintenance = json['maintenance'];
    createdOn = json['createdOn'];
    updateOn = json['updateOn'];
    active = json['active'];
    online = json['online'];
    age = json['age'];
    positionDate = json['positionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['locationId'] = locationId;
    data['city'] = city;
    data['latlng'] = latlng;
    data['lat'] = lat;
    data['long'] = long;
    data['plots'] = plots;
    data['floor'] = floor;
    data['address'] = address;
    data['maintenance'] = maintenance;
    data['createdOn'] = createdOn;
    data['updateOn'] = updateOn;
    data['active'] = active;
    data['online'] = online;
    data['age'] = age;
    data['positionDate'] = positionDate;
    return data;
  }
}

class Images {
  String? url;

  Images({url});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class ListingAmenities {
  Amenity? amenity;

  ListingAmenities({amenity});

  ListingAmenities.fromJson(Map<String, dynamic> json) {
    amenity = json['amenity'] != null ? Amenity.fromJson(json['amenity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (amenity != null) {
      data['amenity'] = amenity!.toJson();
    }
    return data;
  }
}

class Amenity {
  String? name;
  String? webIcon;
  String? appIcon;

  Amenity({name, webIcon, appIcon});

  Amenity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    webIcon = json['webIcon'];
    appIcon = json['appIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['webIcon'] = webIcon;
    data['appIcon'] = appIcon;
    return data;
  }
}

class NearByPlaces {
  String? placeType;
  List<PlaceList>? placeList;

  NearByPlaces({this.placeType, this.placeList});

  NearByPlaces.fromJson(Map<String, dynamic> json) {
    placeType = json['placeType'];
    if (json['placeList'] != null) {
      placeList = <PlaceList>[];
      json['placeList'].forEach((v) {
        placeList!.add(PlaceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeType'] = placeType;
    if (placeList != null) {
      data['placeList'] = placeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlaceList {
  String? name;
  String? lat;
  String? long;
  dynamic distance;

  PlaceList({this.name, this.lat, this.long, this.distance});

  PlaceList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    long = json['long'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['lat'] = lat;
    data['long'] = long;
    data['distance'] = distance;
    return data;
  }
}
