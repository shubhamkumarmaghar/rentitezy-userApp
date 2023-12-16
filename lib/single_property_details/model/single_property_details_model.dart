class SinglePropertyDetails {
  Data? data;
  bool? success;
  String? message;

  SinglePropertyDetails({this.data, this.success, this.message});

  SinglePropertyDetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  int? propId;
  String? listingType;
  String? furnishType;
  String? title;
  String? video;
  String? description;
  int? price;
  int? area;
  String? createdOn;
  String? updateOn;
  String? status;
  int? active;
  Property? property;
  List<Units>? units;
  List<Images>? images;
  dynamic availFrom;
  int? stPrice;
  int? deposit;
  int? stDeposit;

  Data(
      {this.id,
        this.propId,
        this.listingType,
        this.furnishType,
        this.title,
        this.video,
        this.description,
        this.price,
        this.area,
        this.createdOn,
        this.updateOn,
        this.status,
        this.active,
        this.property,
        this.units,
        this.images,
        this.availFrom,
        this.stPrice,
        this.deposit,
        this.stDeposit});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propId = json['propId'];
    listingType = json['listingType'];
    furnishType = json['furnishType'];
    title = json['title'];
    video = json['video'];
    description = json['description'];
    price = json['price'];
    area = json['area'];
    createdOn = json['createdOn'];
    updateOn = json['updateOn'];
    status = json['status'];
    active = json['active'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add(new Units.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    availFrom = json['availFrom'];
    stPrice = json['stPrice'];
    deposit = json['deposit'];
    stDeposit = json['stDeposit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['propId'] = this.propId;
    data['listingType'] = this.listingType;
    data['furnishType'] = this.furnishType;
    data['title'] = this.title;
    data['video'] = this.video;
    data['description'] = this.description;
    data['price'] = this.price;
    data['area'] = this.area;
    data['createdOn'] = this.createdOn;
    data['updateOn'] = this.updateOn;
    data['status'] = this.status;
    data['active'] = this.active;
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['availFrom'] = this.availFrom;
    data['stPrice'] = this.stPrice;
    data['deposit'] = this.deposit;
    data['stDeposit'] = this.stDeposit;
    return data;
  }
}

class Property {
  int? id;
  int? ownerId;
  String? type;
  String? name;
  String? location;
  String? city;
  String? latlng;
  String? plots;
  String? floor;
  String? facilities;
  String? address;
  int? maintenance;
  String? createdOn;
  String? updateOn;
  int? active;
  int? online;

  Property(
      {this.id,
        this.ownerId,
        this.type,
        this.name,
        this.location,
        this.city,
        this.latlng,
        this.plots,
        this.floor,
        this.facilities,
        this.address,
        this.maintenance,
        this.createdOn,
        this.updateOn,
        this.active,
        this.online});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    type = json['type'];
    name = json['name'];
    location = json['location'];
    city = json['city'];
    latlng = json['latlng'];
    plots = json['plots'];
    floor = json['floor'];
    facilities = json['facilities'];
    address = json['address'];
    maintenance = json['maintenance'];
    createdOn = json['createdOn'];
    updateOn = json['updateOn'];
    active = json['active'];
    online = json['online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownerId'] = this.ownerId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['location'] = this.location;
    data['city'] = this.city;
    data['latlng'] = this.latlng;
    data['plots'] = this.plots;
    data['floor'] = this.floor;
    data['facilities'] = this.facilities;
    data['address'] = this.address;
    data['maintenance'] = this.maintenance;
    data['createdOn'] = this.createdOn;
    data['updateOn'] = this.updateOn;
    data['active'] = this.active;
    data['online'] = this.online;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flatNo'] = this.flatNo;
    data['availFrom'] = this.availFrom;
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