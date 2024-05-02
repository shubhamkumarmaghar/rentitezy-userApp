
/*
class MyBookingModel {
  String bookingId;
  PropUnit? property;
  String moveIn;
  String moveOut;
  String name;
  String email;
  String phone;
  int guest;
  int rent;
  int deposit;
  int onboarding;
  int amountPaid;
  String status;
  List<Invoices> invoicesList;

  MyBookingModel(
      {required this.bookingId,
      required this.property,
      required this.moveIn,
      required this.moveOut,
      required this.name,
      required this.email,
      required this.phone,
      required this.guest,
      required this.rent,
      required this.deposit,
      required this.onboarding,
      required this.amountPaid,
      required this.status,
      required this.invoicesList});

  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    debugPrint('mybooking - ${json.toString()}');
    return MyBookingModel(
        bookingId: json['id'].toString(),
        property: json.containsKey('propUnit')
            ? PropUnit.fromJson(json['propUnit'])
            : null,
        moveIn: json['moveIn'] ?? '--',
        moveOut: json['moveOut'] ?? "--",
        name: json['name'].toString(),
        email: json['email'].toString(),
        phone: json['phone'].toString(),
        guest: json['guest'] ?? '0',
        rent: json['rent'] ?? 0,
        deposit: json['deposit'] ?? 0,
        onboarding: json['onboarding'] ?? 0,
        amountPaid: json['amountPaid'] ?? 0,
        invoicesList: (json['invoices'] as List)
            .map((invoices) => Invoices.fromJson(invoices))
            .toList(),
        status: json['status']);
  }
}

class PropUnit {
  int id;
  String flatNo;
  PropListing propListing;

  PropUnit({required this.id, required this.flatNo, required this.propListing});

  factory PropUnit.fromJson(Map<String, dynamic> json) {
    debugPrint('json ${json.toString()}');
    return PropUnit(
        id: json['id'] ?? 'NA',
        flatNo: json['flatNo'] ?? 'NA',
        propListing: PropListing.fromJson(json['listing']));
  }
}

class PropListing {
  String unitType;
  Property property;

  PropListing({required this.unitType, required this.property});

  factory PropListing.fromJson(Map<String, dynamic> json) {
    return PropListing(
        unitType: json['unitType'] ?? 'NA',
        property: Property.fromJson(json['property']));
  }
}

class Property {
  String name;
  String address;
  String latlng;

  Property({required this.name, required this.address, required this.latlng});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
        name: json['name'] ?? 'NA',
        address: json['address'] ?? 'NA',
        latlng: json['latlng'] ?? 'NA');
  }
}
*/
class Invoices {
  String id;
  dynamic bookingId;
  String type;
  String fromDate;
  String tillDate;
  String payable;
  String paid;
  String status;
  dynamic createdOn;
  dynamic updatedOn;

  Invoices(
      {required this.id,
      required this.type,
      required this.fromDate,
      required this.tillDate,
      required this.payable,
      required this.paid,
      required this.status,
        required this.bookingId,
        required this.updatedOn,
        required this.createdOn
      });

  factory Invoices.fromJson(Map<String, dynamic> json) {
    return Invoices(
      id: json['id'].toString(),
      bookingId: json['bookingId'],
      type: json['type'].toString(),
      fromDate: json['fromDate'].toString(),
      tillDate: json['tillDate'].toString(),
      payable: json['payable'].toString(),
      paid: json['paid'].toString(),
      status: json['status'].toString(),
      createdOn: json['createdOn'].toString(),
      updatedOn: json['updatedOn'].toString()

    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['fromDate'] = fromDate;
    data['tillDate'] = tillDate;
    data['payable'] = payable;
    data['paid'] = paid;
    data['status'] = status;
    data['bookingId'] = bookingId;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    return data;
  }
}


class MyBookingModel {
  List<MyBookingModelData>? data;
  bool? success;
  String? message;

  MyBookingModel({this.data, this.success, this.message});

  MyBookingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MyBookingModelData>[];
      json['data'].forEach((v) {
        data!.add(new MyBookingModelData.fromJson(v));
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

class MyBookingModelData {
  int? id;
  String? moveIn;
  String? moveOut;
  String? name;
  String? email;
  String? phone;
  int? guest;
  int? rent;
  int? deposit;
  int? onboarding;
  int? amountPaid;
  String? status;
  PropUnit? propUnit;
  String? from;
  String? till;
  List<Invoices>? invoices;

  MyBookingModelData(
      {this.id,
        this.moveIn,
        this.moveOut,
        this.name,
        this.email,
        this.phone,
        this.guest,
        this.rent,
        this.deposit,
        this.onboarding,
        this.amountPaid,
        this.status,
        this.propUnit,
        this.from,
        this.till,
        this.invoices});

  MyBookingModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moveIn = json['moveIn'];
    moveOut = json['moveOut'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    guest = json['guest'];
    rent = json['rent'];
    deposit = json['deposit'];
    onboarding = json['onboarding'];
    amountPaid = json['amountPaid'];
    status = json['status'];
    from = json['from'];
    till = json['till'];
    propUnit = json['propUnit'] != null
        ? new PropUnit.fromJson(json['propUnit'])
        : null;
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(new Invoices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['moveIn'] = this.moveIn;
    data['moveOut'] = this.moveOut;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['guest'] = this.guest;
    data['rent'] = this.rent;
    data['deposit'] = this.deposit;
    data['onboarding'] = this.onboarding;
    data['amountPaid'] = this.amountPaid;
    data['status'] = this.status;
    data['from'] = this.from;
    data['till'] = this.till;
    if (this.propUnit != null) {
      data['propUnit'] = this.propUnit!.toJson();
    }
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropUnit {
  int? id;
  String? flatNo;
  Listing? listing;

  PropUnit({this.id, this.flatNo, this.listing});

  PropUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flatNo = json['flatNo'];
    listing =
    json['listing'] != null ? new Listing.fromJson(json['listing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flatNo'] = this.flatNo;
    if (this.listing != null) {
      data['listing'] = this.listing!.toJson();
    }
    return data;
  }
}

class Listing {
  String? listingType;
  List<Images>? images;
  Property? property;

  Listing({this.listingType, this.images, this.property});

  Listing.fromJson(Map<String, dynamic> json) {
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