class PropertyInfoModel {
  int? id;
  int? propId;
  String? title;
  String? listingType;
  int? price;
  int? dailyPrice;
  int? area;
  String? furnishType;
  Property? property;
  List<Images>? images;
  int? wishlist;
  List<Units>? units;
  Count? cCount;
  String? availFrom;

  PropertyInfoModel(
      {this.id,
        this.propId,
        this.title,
        this.listingType,
        this.price,
        this.dailyPrice,
        this.area,
        this.furnishType,
        this.property,
        this.images,
        this.wishlist,
        this.units,
        this.cCount,
        this.availFrom});

  PropertyInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propId = json['propId'];
    title = json['title'];
    listingType = json['listingType'];
    price = json['price'];
    dailyPrice = json['dailyPrice'];
    area = json['area'];
    furnishType = json['furnishType'];
    property = json['property'] != null
        ?  Property.fromJson(json['property'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add( Images.fromJson(v));
      });
    }
    wishlist = json['wishlist'];
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add( Units.fromJson(v));
      });
    }
    cCount = json['_count'] != null ?  Count.fromJson(json['_count']) : null;
    availFrom = json['availFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['propId'] = this.propId;
    data['title'] = this.title;
    data['listingType'] = this.listingType;
    data['price'] = this.price;
    data['dailyPrice'] = this.dailyPrice;
    data['area'] = this.area;
    data['furnishType'] = this.furnishType;
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['wishlist'] = this.wishlist;
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    if (this.cCount != null) {
      data['_count'] = this.cCount!.toJson();
    }
    data['availFrom'] = this.availFrom;
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
        ?  Location.fromJson(json['location'])
        : null;
    latlng = json['latlng'];
    type = json['type'];
    address = json['address'];
    plots = json['plots'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

class Units {
  int? id;
  String? flatNo;
  String? availFrom;

  Units({this.id, this.flatNo, this.availFrom});

  Units.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flatNo = json['flatNo'];
    availFrom = json['availFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['flatNo'] = this.flatNo;
    data['availFrom'] = this.availFrom;
    return data;
  }
}

class Count {
  int? units;

  Count({this.units});

  Count.fromJson(Map<String, dynamic> json) {
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['units'] = this.units;
    return data;
  }
}