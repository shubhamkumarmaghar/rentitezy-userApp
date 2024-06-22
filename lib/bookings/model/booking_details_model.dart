class BookingDetailsModel {
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
  PropUnit? propUnit;
  PropListing? propListing;
  List<Invoices>? invoices;
  List<Tenants>? tenants;

  BookingDetailsModel(
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
        this.propUnit,
        this.propListing,
        this.invoices,
        this.tenants});

  BookingDetailsModel.fromJson(Map<String, dynamic> json) {
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
    propUnit = json['propUnit'] != null
        ? new PropUnit.fromJson(json['propUnit'])
        : null;
    propListing = json['propListing'] != null
        ? new PropListing.fromJson(json['propListing'])
        : null;
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(new Invoices.fromJson(v));
      });
    }
    if (json['tenants'] != null) {
      tenants = <Tenants>[];
      json['tenants'].forEach((v) {
        tenants!.add(new Tenants.fromJson(v));
      });
    }
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
    if (this.propUnit != null) {
      data['propUnit'] = this.propUnit!.toJson();
    }
    if (this.propListing != null) {
      data['propListing'] = this.propListing!.toJson();
    }
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    if (this.tenants != null) {
      data['tenants'] = this.tenants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropUnit {
  int? id;
  String? flatNo;

  PropUnit({this.id, this.flatNo});

  PropUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flatNo = json['flatNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flatNo'] = this.flatNo;
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

class Invoices {
  int? id;
  String? type;
  String? fromDate;
  String? tillDate;
  int? payable;
  int? paid;
  String? status;

  Invoices(
      {this.id,
        this.type,
        this.fromDate,
        this.tillDate,
        this.payable,
        this.paid,
        this.status});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    fromDate = json['fromDate'];
    tillDate = json['tillDate'];
    payable = json['payable'];
    paid = json['paid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['fromDate'] = this.fromDate;
    data['tillDate'] = this.tillDate;
    data['payable'] = this.payable;
    data['paid'] = this.paid;
    data['status'] = this.status;
    return data;
  }
}

class Tenants {
  int? id;
  int? bookingId;
  String? name;
  String? email;
  String? phone;
  String? nationality;
  String? dob;
  String? address;
  String? addedOn;
  String? updateOn;
  String? addedById;
  List<Proofs>? proofs;

  Tenants(
      {this.id,
        this.bookingId,
        this.name,
        this.email,
        this.phone,
        this.nationality,
        this.dob,
        this.address,
        this.addedOn,
        this.updateOn,
        this.addedById,
        this.proofs});

  Tenants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    nationality = json['nationality'];
    dob = json['dob'];
    address = json['address'];
    addedOn = json['addedOn'];
    updateOn = json['updateOn'];
    addedById = json['addedById'];
    if (json['proofs'] != null) {
      proofs = <Proofs>[];
      json['proofs'].forEach((v) {
        proofs!.add(new Proofs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['nationality'] = this.nationality;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['addedOn'] = this.addedOn;
    data['updateOn'] = this.updateOn;
    data['addedById'] = this.addedById;
    if (this.proofs != null) {
      data['proofs'] = this.proofs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Proofs {
  int? id;
  int? tenantId;
  int? bookingId;
  String? type;
  String? url;
  String? addedOn;
  Null? addedById;

  Proofs(
      {this.id,
        this.tenantId,
        this.bookingId,
        this.type,
        this.url,
        this.addedOn,
        this.addedById});

  Proofs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenantId'];
    bookingId = json['bookingId'];
    type = json['type'];
    url = json['url'];
    addedOn = json['addedOn'];
    addedById = json['addedById'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tenantId'] = this.tenantId;
    data['bookingId'] = this.bookingId;
    data['type'] = this.type;
    data['url'] = this.url;
    data['addedOn'] = this.addedOn;
    data['addedById'] = this.addedById;
    return data;
  }
}


