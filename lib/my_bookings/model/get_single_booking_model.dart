class SingleBookingModel {
  Data? data;
  bool? success;
  String? message;

  SingleBookingModel({this.data, this.success, this.message});

  SingleBookingModel.fromJson(Map<String, dynamic> json) {
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
  String? from;
  String? till;
  String? name;
  String? email;
  String? phone;
  int? guest;
  int? rent;
  int? deposit;
  int? onboarding;
  int? amountPaid;
  String? status;
  PropListing? propListing;
  List<Null>? invoices;

  Data(
      {this.id,
        this.from,
        this.till,
        this.name,
        this.email,
        this.phone,
        this.guest,
        this.rent,
        this.deposit,
        this.onboarding,
        this.amountPaid,
        this.status,
        this.propListing,
        this.invoices});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    till = json['till'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    guest = json['guest'];
    rent = json['rent'];
    deposit = json['deposit'];
    onboarding = json['onboarding'];
    amountPaid = json['amountPaid'];
    status = json['status'];

    propListing = json['propListing'] != null
        ? new PropListing.fromJson(json['propListing'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['till'] = this.till;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['guest'] = this.guest;
    data['rent'] = this.rent;
    data['deposit'] = this.deposit;
    data['onboarding'] = this.onboarding;
    data['amountPaid'] = this.amountPaid;
    data['status'] = this.status;

    if (this.propListing != null) {
      data['propListing'] = this.propListing!.toJson();
    }

    return data;
  }
}

class PropListing {
  String? listingType;
  List<Images>? images;
  Property? property;

  PropListing({this.listingType, this.images, this.property});

  PropListing.fromJson(Map<String, dynamic> json) {
    listingType = json['listingType'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listingType'] = this.listingType;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
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

class Property {
  String? name;
  String? address;
  String? latlng;

  Property({this.name, this.address, this.latlng});

  Property.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    latlng = json['latlng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['latlng'] = this.latlng;
    return data;
  }
}